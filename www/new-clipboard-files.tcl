ad_page_contract {
    Add all checked files to the specific resource
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    man_id:notnull
    ims_item_id:notnull
    {name ""}
    object_id:multiple
    sort_order:optional
}

set user_id [ad_conn user_id]

lors_central::check_permissions

foreach object $object_id {
    #The same file can not be added to the same res_id twice so we are going to check that
    set ims_res_id [db_string get_res_id { } ]
    if { [db_string check_file { } -default 0] } {
	ad_return_complaint 1 "<b>[_ lors-central.this_file_is]</b>"
	ad_script_abort
    }
}

db_transaction {
    # We get the resource_id to get the href of the item that is the default
    # since this is the default file the ims_item has
    db_0or1row get_resource_info { }

    # We need the info about the ims_item_id
    db_0or1row get_item_info { }
    
    set cr_revision [lors_central::get_content_revision_id -ims_item_id $ims_item_id]
    set cr_item_id [lors_central::get_item_id -revision_id $cr_revision]
    if { [string equal $cr_item_id 0] } {
	# It's probably an URL so we are going to treat it as one
	set cr_item_id [lors_central::get_item_url -ims_item_id $ims_item_id -man_id $man_id]
    }
    # We get the folder_id to know where to store the new cr_item
    set folder_id [lors_central::get_parent_id -item_id $cr_item_id]
    
    set res_root_folder_id [lors_central::get_root_resources_folder_id]
    set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]
    
    set title [lors_central::check_item_name -parent_id $res_folder_id -name $identifierref]
    set new_res_item_id [content::item::new -name $title -creation_user $user_id \
			     -parent_id $res_folder_id -content_type "ims_resource_object"]
    
    set new_res_rev_id [content::revision::new -item_id $new_res_item_id -title $title \
			    -creation_user $user_id -is_live "t"]
    
    
    db_dml update_new_res {
	update
	ims_cp_resources
	set
	man_id = :man_id,
	identifier = :identifierref,
	type = 'webcontent',
	href = :res_href,
	hasmetadata = 'f'
	where
	res_id = :new_res_rev_id
    }
    
    
    # We need to create a new row in the ims_cp_files for each file that was sen here from clipboard
    foreach object $object_id {
	db_0or1row get_file_info { }
	db_dml insert_new_file {
	    insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
	    values (:object, :new_res_rev_id, :pathtofile, :filename, 'f')
	}
    }

    set item_id [lors_central::get_item_id -revision_id $ims_item_id]
    set new_ims_rev_id [content::revision::new -item_id $item_id -title $item_title \
			    -creation_user $user_id -is_live "t"]
    
    db_dml update_ims_cp_items {
	update ims_cp_items
	set
	org_id = :org_id,
	identifier = :identifier,
	identifierref = :identifierref,
	item_title = :item_title,
	parent_item = :parent_item,
	sort_order = :sort_order
	where ims_item_id = :new_ims_rev_id
	
    }

    # Now this new revision_id is the one that holds the content of the new resource
    # We have to make a row in ims_cp_items_to_resources table
    db_dml insert_new_item_to_res {
	insert into ims_cp_items_to_resources (ims_item_id, res_id )
	values (:new_ims_rev_id, :new_res_rev_id)
    }
    
    set old_res_id [db_string get_old_res_id { } -default ""]
    db_dml carry_forward_files {
	insert into ims_cp_files ( 
				  select 
				  file_id, 
				  :new_res_rev_id,
				  pathtofile,
				  filename,
				  hasmetadata 
				  from 
				  ims_cp_files 
				  where 
				  res_id = :old_res_id)
    }
}

ad_returnredirect [export_vars -base "one-learning-object" {man_id {ims_item_id $new_ims_rev_id}}]


