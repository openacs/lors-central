ad_page_contract {
    Edits one learning object (ims_item_id)
    
    @author         Miguel Marin (miguelmarin@viaro.net)
    @author         Viaro Networks www.viaro.net
    @creation_date  2005-03-22
} {
    man_id:integer,notnull
    ims_item_id:integer,notnull
    {name ""}
    file_upload:trim,optional
    file_upload.tmpfile:optional,tmpfile
    file_id:integer
    {mime_type ""}
    {edit_p ""}
}

# Checking privilege over lors-central
lors_central::check_permissions

set parent_item [db_string get_parent_item "select parent_item from ims_cp_items where ims_item_id = :ims_item_id"]

set user_id [ad_conn user_id]
set title "[_ lors-central.edit_object]"
set context "[list [list "one-learning-object?ims_item_id=$ims_item_id&man_id=$man_id&name=$name" \
                   [_ lors-central.One_learning]] [_ lors-central.edit_object]]"

if { ![string equal $file_id 0] } {
    set version_id $file_id
    set mime_type [db_string get_mime_type { } -default t]
    if { [string eq $mime_type "text/html"] || [string eq $mime_type "text/plain"] } {
	set edit_p "t"
    } else {
	set edit_p "f"
    }
    
} else {
    set mime_type "URL"
    set edit_p "f"
}

ad_form -name upload_file -html {enctype multipart/form-data} -form {
    {file_upload:text(file)
        {label "[_ lors-central.choose_the_file]"}
	{help_text "[_ lors-central.help_text]"}
    }
    {man_id:text(hidden)
	{value $man_id}
    }
    {ims_item_id:text(hidden)
	{value $ims_item_id}
    }
    {name:text(hidden)
	{value $name}
    }
    {file_id:text(hidden)
	{value $file_id}
    }
    {parent_item:text(hidden)
	{value $parent_item}
    }
} -on_submit {
    db_transaction {
	# We get the pathtofile from the editing file and the resources
	# table since this is the default file the ims_item has
	set res_id [db_string get_res_id { }]
	set file_href [db_string get_pathtofile { } ]
	set file_name [db_string get_filename { } ]
	set res_href [db_string get_href { } ]
	      
	set tmp_filename [ns_queryget file_upload.tmpfile]
	set mime_type [cr_filename_to_mime_type -create $file_upload]
	set tmp_size [file size $tmp_filename]
	
	# We are going to create a new cr_revision (file) for the new file
	# We get the revision_id that holds the content on the CR, this is the 
	# live_revision of one file_id
	
	set cr_revision [lors_central::get_content_revision_id -ims_item_id $ims_item_id]
	set cr_item_id [lors_central::get_item_id -revision_id $cr_revision]
	if { [string equal $cr_item_id 0] } {
            # It's probably an URL so we are going to treat it as one
	    set cr_item_id [lors_central::get_item_url -ims_item_id $ims_item_id -man_id $man_id]
	}
	# We get the folder_id to know where to store the new cr_item
	set folder_id [lors_central::get_parent_id -item_id $cr_item_id]
	
	# We are going to create a new item for the ims_item_id
        # First we are going to check if the name already exists to generate a new one
	
	set res_root_folder_id [lors_central::get_root_resources_folder_id]
	set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]
        set file_upload [lors_central::check_item_name -parent_id $folder_id -name $file_upload]
        set file_upload [lors_central::check_item_name -parent_id $res_folder_id -name $file_upload]
	
	#set new_file_item_id [content::item::new -name $file_upload -creation_user $user_id -parent_id $folder_id]
	set file_item_id [lors_central::get_item_id -revision_id $file_id]
	set new_file_id [content::revision::new -item_id $file_item_id -title $file_name -creation_user $user_id \
			 -mime_type $mime_type -is_live "t"]
	
	# Now we store the content in the CR
	set cr_file [cr_create_content_file $file_item_id $new_file_id $tmp_filename]
	
	# get the size
	set file_size [cr_file_size $cr_file]
	
	# update the file path in the CR and the size on cr_revisions
	db_dml update_revision { 
	    update 
	    cr_revisions 
	    set 
	    content = :cr_file, 
	    content_length = :file_size 
	    where 
	    revision_id = :new_file_id
	} 
	# Now that we have the new item store in the CR, we have to make 
	# some insert in some tables to adjust to the new cr_item.
	# First we have to reflect the new file in the resources table, so we have to make
	# a new cr_item and revision for the resource and insert it on the ims_cp_resources table
    
	
	set new_res_item_id [content::item::new -name $file_upload -creation_user $user_id \
				 -parent_id $res_folder_id -content_type "ims_resource_object"]
	
	set new_res_rev_id [content::revision::new -item_id $new_res_item_id -title $file_upload \
				-creation_user $user_id -is_live "t"]
	
        db_dml update_new_res {
             update 
                    ims_cp_resources 
             set
                    man_id = :man_id,
                    identifier = :file_upload,
                    type = 'webcontent',
	            href = :res_href,
                    hasmetadata = 'f'
             where
                    res_id = :new_res_rev_id
	}
	# We need to create a new row in the ims_cp_files to associate the new resource to the new file
	db_dml insert_new_file {
	    insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
            values (:new_file_id, :new_res_rev_id, :file_href, :file_name, 'f')
	}
	# Now are going to create a new version of the item (ims_cp_item)
	set item_id [lors_central::get_item_id -revision_id $ims_item_id]
        set item_title [lors_central::get_item_title -item_id $item_id]
        set item_count [expr [lors_central::get_revision_count -item_id $item_id] + 1 ]
        append item_title "_$item_count"
	set new_ims_rev_id [content::revision::new -item_id $item_id -title $item_title -creation_user $user_id \
				-is_live "t"]
	
        # We need to fill the extra information
        set item_name [lors_central::get_item_name -ims_item_id $ims_item_id]
        set org_id [db_string get_org_id "select org_id from ims_cp_items where ims_item_id = :ims_item_id"]
        set item_title [db_string get_item_title_id "select item_title from ims_cp_items where ims_item_id = :ims_item_id"]
 	db_dml update_ims_cp_items {
            update ims_cp_items
            set
                 org_id = :org_id,
                 identifier = :item_name,
                 identifierref = :file_upload,
                 item_title = :item_title,
                 parent_item = :parent_item 
            where ims_item_id = :new_ims_rev_id
                  
	}
	# Now this new revision_id is the one that holds the content of the new resource 
        # We have to make a row in ims_cp_items_to_resources table
	db_dml insert_new_item_to_res {
	    insert into ims_cp_items_to_resources (ims_item_id, res_id )
	    values (:new_ims_rev_id, :new_res_rev_id)
	} 
	    # get old res_id
	    set old_res_id [db_string get_old_res_id "select f.res_id from ims_cp_files f, ims_cp_items_to_resources r where f.file_id=:file_id and f.res_id=r.res_id and r.ims_item_id=:ims_item_id" -default ""]
	    ns_log notice "\nDAVEB: edit resource ims_item_id='${ims_item_id}' file_id='${file_id}' old_res_id='${old_res_id}'\n"	
	    if {![string equal "" $old_res_id]} {
		db_dml carry_forward_files "
		    insert into ims_cp_files (select file_id, $new_res_rev_id,pathtofile,filename,hasmetadata from ims_cp_files where res_id=:old_res_id and file_id <> :file_id)"
	    }
        # We are going to set the sort_order field
        lors_central::set_sort_order -ims_item_id $new_ims_rev_id
    }

} -after_submit {
    ad_returnredirect "one-learning-object?ims_item_id=$ims_item_id&man_id=$man_id&name=$name"
}