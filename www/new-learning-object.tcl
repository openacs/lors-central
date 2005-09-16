ad_page_contract {
    Creates a one new learning object (ims_item_id)
    
    @author         Miguel Marin (miguelmarin@viaro.net)
    @author         Viaro Networks www.viaro.net
    @creation_date  2005-03-28
} {
    man_id:integer,notnull
    org_id:notnull
    parent:integer,optional
    file_upload:trim,optional
    file_upload.tmpfile:optional,tmpfile
    clipboard_object_id:integer,optional
    ims_item_id:integer,optional
    {sort_order ""}
}

set user_id [ad_conn user_id]
# Checking privilege over lors-central
lors_central::check_permissions


set title "[_ lors-central.new_object]"
set context "[list [list "one-course?man_id=$man_id" \
                   [_ lors-central.one_course]] [_ lors-central.new_object]]"

if {![exists_and_not_null parent]} {
    set parent $org_id
}

set add_link "add-lo?man_id=$man_id&org_id=$org_id&parent_item=$parent&sort_order=$sort_order"

ad_form -name upload_file -html {enctype multipart/form-data} -form {
    {item_title:text(text)
        {label "[_ lors-central.item_title]"}
    }
    {file_upload:text(file)
        {label "[_ lors-central.choose_the_file]"}
        {help_text "[_ lors-central.help_text]"}
    }
    {zip_p:text(checkbox),optional
        {label "[_ lors-central.zip_file]"}
        {options {{"" 1}}}
        {help_text "[_ lors-central.this_is_a]"}	
    }
    {man_id:text(hidden)
        {value $man_id}
    }
    {org_id:text(hidden)
        {value $org_id}
    }
    {sort_order:text(hidden)
        {value $sort_order}
    }
    {parent:text(hidden)
        {value $parent}
    }
} -on_submit {
    if { ![empty_string_p $zip_p] } {
        # It's a zip file so we need to make some things
        # unzips the file
        if { ![empty_string_p $file_upload] &&
            [ catch {set tmp_dir [lors::imscp::expand_file $file_upload ${file_upload.tmpfile} expand_$file_upload] } \
                   errMsg] } {
            ad_return_complaint 1 "[_ lorsm.lt_The_uploaded_file_doe]"
            ad_script_abort
        }
        # Now that we have the zip expanded we will process the files
        set allfiles [lors::imscp::dir_walk $tmp_dir]

        db_transaction {
            if { [empty_string_p $sort_order] } {
                set max_sort_order [db_string get_max_sort_order { } ]
                set sort_order [expr $max_sort_order + 1]
            } else {
                incr sort_order
            } 

            # First we need to create a new resource
            # We need to know where the new resource should be
            set res_root_folder_id [lors_central::get_root_resources_folder_id]
            set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]
            
            # We are going to make the first file that is in the tmp folder the default one
            set first_file [lindex $allfiles 0]
            set first_file_split [split $first_file "/"]
            set first_filename [lindex $first_file_split [expr [llength $first_file_split] - 1]]
            
            # We are going to check if the file_name already exists
            set first_filename [lors_central::check_item_name -parent_id $res_folder_id -name $first_filename]
            set new_res_item_id [content::item::new -name $first_filename -creation_user $user_id \
                                     -parent_id $res_folder_id -content_type "ims_resource_object"]
            
            set new_res_rev_id [content::revision::new -item_id $new_res_item_id -title $first_filename \
                                    -creation_user $user_id -is_live "t"]
            
            # Now we have to update the new row in the ims_cp_resources using this new resource (new_res_id)
            # we need a new href
            set new_href "$first_filename"
            
            db_dml update_new_res {
                update 
                ims_cp_resources 
                set
                man_id = :man_id,
                identifier = :first_filename,
                type = 'webcontent',
                href = :new_href,
                hasmetadata = 'f'
                where
                res_id = :new_res_rev_id
            }

            
            # First we are going to create a new cr_item (file) for the new resource
            # We need the folder_id of the course to store the new item
            set course_name [lors_central::get_course_name -man_id $man_id]
            set root_folder [lors_central::get_root_folder_id]
            set folder_id [db_string get_folder_id { }]

            # Now we are going to store all files in the Content Repository and insert the rows on ims_cp_files
            # Here we are going to create a new cr_item and revision for the files that exist on
            # the zip
            foreach tmp_filename $allfiles {
                set split_file [split $tmp_filename "/"]
                set filename [lindex $split_file [expr [llength $split_file] - 1]]
                set mime_type [cr_filename_to_mime_type -create $filename]
                set tmp_size [file size $tmp_filename]
                
                # We are going to create a new item. First we are going to check 
                # if the name already exists to generate a new one
                set filename [lors_central::check_item_name -parent_id $folder_id -name $filename]
                set new_file_item_id [content::item::new -name $filename -creation_user $user_id \
                                          -parent_id $folder_id]
                set new_file_id [content::revision::new -item_id $new_file_item_id -title $filename \
                                     -creation_user $user_id -mime_type $mime_type -is_live "t"]
                
                # Now we store the content in the CR
                set cr_file [cr_create_content_file $new_file_item_id $new_file_id $tmp_filename]
                
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
                # some insert to some tables to adjust to the new cr_item.
                # First we have to reflect the new file in the resources table.
                # We need to create a new row in the ims_cp_files to associate the new resource to the new file
                
                db_dml insert_new_file {
                    insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
                    values (:new_file_id, :new_res_rev_id, :filename, :filename, 'f')
                }
                file delete $tmp_filename
            }
            
            # Now are going to create a new item (ims_cp_item)
            # We need the folder_id of the course to store the new item
            set root_ims_folder [lors_central::get_root_items_folder_id]
            set items_folder_id [db_string get_items_folder_id { }]


            set new_ims_item_id [content::item::new -name $item_title -creation_user $user_id \
                             -parent_id $items_folder_id -content_type "ims_item_object"]
            set new_ims_rev_id [content::revision::new -item_id $new_ims_item_id -title $item_title \
                            -creation_user $user_id -is_live "t"]
    
            # We need to insert in the ims_cp_items at the proper sort_order so we are going 
            # to rearrenge the items sort_order and then fill the information for the item
            db_foreach get_items_to_reorder { } {
                set new_sort [expr $order + 1]
                db_dml reorder_items { }
            }
            
            db_dml update_ims_cp_items {
                update ims_cp_items set 
                org_id = :org_id,
                identifier = :first_filename,
                identifierref = :first_filename,
                item_title = :item_title,
                sort_order = :sort_order,
                parent_item = :parent
                where ims_item_id = :new_ims_rev_id
            }
            # Now this new revision_id is the one that holds the content of the new resource 
            # We have to make a row in ims_cp_items_to_resources table
            
            db_dml insert_new_item_to_res {
                insert into ims_cp_items_to_resources (ims_item_id, res_id )
                values (:new_ims_rev_id, :new_res_rev_id)
            } 
            
            # We also need to map this item to (ims_cp_items_map)
            # We need to do it for every community that is associated to this course (man_id)
            set com_list [db_list_of_lists get_community_id { 
                select distinct community_id from ims_cp_items_map
                where man_id = :man_id
            }]
            foreach community_id $com_list {
                db_dml insert_item {
                    insert into ims_cp_items_map
                    (man_id,org_id,community_id,ims_item_id)
                    values
                    (:man_id,:org_id,:community_id,:new_ims_rev_id)
                }	    
            }


            # We delete the temporary directory created when unzipping the file
            exec rm -fr $tmp_dir
        }

    } else {
        db_transaction {
            set tmp_filename [ns_queryget file_upload.tmpfile]
            if { [empty_string_p $sort_order] } {
                set max_sort_order [db_string get_max_sort_order { } ]
                set sort_order [expr $max_sort_order + 1]
            } else {
                incr sort_order
            } 
            set mime_type [cr_filename_to_mime_type -create $file_upload]
            set tmp_size [file size $tmp_filename]
            
            # First we are going to create a new cr_item (file) for the new resource
            # We need the folder_id of the course to store the new item
            set course_name [lors_central::get_course_name -man_id $man_id]
            set root_folder [lors_central::get_root_folder_id]
            set folder_id [db_string get_folder_id { }]
            
            
            # We are going to create a new item. First we are going to check 
            # if the name already exists to generate a new one
            set file_upload [lors_central::check_item_name -parent_id $folder_id -name $file_upload]
            set new_file_item_id [content::item::new -name $file_upload -creation_user $user_id \
                                      -parent_id $folder_id]
            set new_file_id [content::revision::new -item_id $new_file_item_id -title $file_upload -creation_user $user_id \
                                 -mime_type $mime_type -is_live "t"]
            
            # Now we store the content in the CR
            set cr_file [cr_create_content_file $new_file_item_id $new_file_id $tmp_filename]
            
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
            # some insert to some tables to adjust to the new cr_item.
            # First we have to reflect the new file in the resources table, so we have to make
            # a new cr_item and revision for the resource and insert it on the ims_cp_resources table
            
            # We need to know where the new resource should be
            set res_root_folder_id [lors_central::get_root_resources_folder_id]
            set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]
            
            set new_res_item_id [content::item::new -name $file_upload -creation_user $user_id \
                                     -parent_id $res_folder_id -content_type "ims_resource_object"]
            
            set new_res_rev_id [content::revision::new -item_id $new_res_item_id -title $file_upload \
                                    -creation_user $user_id -is_live "t"]
            
            
            # Now we have to update the new row in the ims_cp_resources using this new resource (new_res_id)
            # we need a new href
            set new_href "$file_upload"
            
            db_dml update_new_res {
                update 
                ims_cp_resources 
                set
                man_id = :man_id,
                identifier = :file_upload,
                type = 'webcontent',
                href = :new_href,
                hasmetadata = 'f'
                where
                res_id = :new_res_rev_id
            }
            # We need to create a new row in the ims_cp_files to associate the new resource to the new file
            db_dml insert_new_file {
                insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
                values (:new_file_id, :new_res_rev_id, :new_href, :file_upload, 'f')
            }
            
            # Now are going to create a new item (ims_cp_item)
            # We need the folder_id of the course to store the new item
            set root_ims_folder [lors_central::get_root_items_folder_id]
            set items_folder_id [db_string get_items_folder_id { }]

            set new_ims_item_id [content::item::new -name $item_title -creation_user $user_id -parent_id $items_folder_id \
                                     -content_type "ims_item_object"]
            set new_ims_rev_id [content::revision::new -item_id $new_ims_item_id -title $item_title \
                                    -creation_user $user_id -is_live "t"]

            # We need to insert in the ims_cp_items at the proper sort_order so we are going 
            # to rearrenge the items sort_order and then fill the information for the item
            db_foreach get_items_to_reorder { } {
                set new_sort [expr $order + 1]
                db_dml reorder_items { }
            }

            db_dml update_ims_cp_items {
                update ims_cp_items set 
                org_id = :org_id,
                identifier = :file_upload,
                identifierref = :file_upload,
                item_title = :item_title,
                sort_order = :sort_order,
                parent_item = :parent
                where ims_item_id = :new_ims_rev_id
            }
            # Now this new revision_id is the one that holds the content of the new resource 
            # We have to make a row in ims_cp_items_to_resources table

            db_dml insert_new_item_to_res {
                insert into ims_cp_items_to_resources (ims_item_id, res_id )
                values (:new_ims_rev_id, :new_res_rev_id)
            } 

            # We also need to map this item to (ims_cp_items_map)
            # We need to do it for every community that is associated to this course (man_id)
            set com_list [db_list_of_lists get_community_id { 
                select distinct community_id from ims_cp_items_map
                where man_id = :man_id
            }]
            foreach community_id $com_list {
                db_dml insert_item {
                    insert into ims_cp_items_map
                    (man_id,org_id,community_id,ims_item_id)
                    values
                    (:man_id,:org_id,:community_id,:new_ims_rev_id)
                }	    
            }
        }
        file delete $tmp_filename
    }
} -after_submit {
        ad_returnredirect "one-learning-object?man_id=$man_id&ims_item_id=$new_ims_rev_id"
    }

