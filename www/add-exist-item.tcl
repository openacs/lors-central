ad_page_contract {
    Add one existent LO to a course
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    org_id:notnull
    man_id:notnull
    parent_item:notnull
    ims_item_id:notnull
    {sort_order ""}
    item_man_id:notnull
}

# Checking swa privilege over lors-central
lors_central::is_swa

set the_ims_item_id $ims_item_id
set user_id [ad_conn user_id]

db_transaction {
    # Here we makee reference to the same res_id
    set res_id [db_string get_res_id { }]
    set identifierref [db_string get_identifierref { }]

    if { [empty_string_p $sort_order] } {
	set max_sort_order [db_string get_max_sort_order { } ]
	set sort_order [expr $max_sort_order + 1]
    } else {
            incr sort_order
    }
    
    # First we are going to create a new cr_item (file) for the new resource
    # We need the folder_id of the course to store the new item
    set course_name [lors_central::get_course_name -man_id $man_id]
    set root_folder [lors_central::get_root_folder_id]
    set items_root_folder [lors_central::get_root_items_folder_id]
    set folder_id [db_string get_folder_id { }]
    set item_folder_id [db_string get_item_folder_id { }]
    set item_name [db_string get_item_name { }]
    set item_org_name $item_name    

    # We are going to create a new item. First we are going to check
    # if the name already exists to generate a new one
    set item_name [lors_central::check_item_name -parent_id $folder_id -name $item_name]
    set item_name [lors_central::check_item_name -parent_id $item_folder_id -name $item_name]

    ###############################
    # We need to know where the new resource should be
    set res_root_folder_id [lors_central::get_root_resources_folder_id]
    set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]
    
    set new_res_item_id [content::item::new -name $item_name -creation_user $user_id \
			     -parent_id $res_folder_id -content_type "ims_resource_object"]
    
    set new_res_rev_id [content::revision::new -item_id $new_res_item_id -title $item_name \
			    -creation_user $user_id -is_live "t"]
    
    
    # Now we have to update the new row in the ims_cp_resources using this new resource (new_res_id)
    # we need a new href
    set href [db_string get_res_href { select href from ims_cp_resources where res_id = :res_id }]
    set identifier [db_string get_res_identifier { select identifier from ims_cp_resources where res_id = :res_id }]
 	
        db_dml update_new_res {
             update 
                    ims_cp_resources 
             set
                    man_id = :man_id,
                    identifier = :identifier,
                    type = 'webcontent',
                    href = :href,
                    hasmetadata = 'f'
             where
                    res_id = :new_res_rev_id
	}

    # We need to make a copy of the rows on ims_cp_files
    db_dml insert_files "
	insert into ims_cp_files  (select file_id,$new_res_rev_id,pathtofile,filename,hasmetadata from ims_cp_files where res_id = :res_id)"
	
    

    ############################################

    # Now are going to create a new item (ims_cp_item)
    # We need the folder_id of the course to store the new item
    set root_ims_folder [lors_central::get_root_items_folder_id]
    set items_folder_id [db_string get_items_folder_id { }]

    set new_ims_item_id [content::item::new -name $item_name -creation_user $user_id -parent_id $items_folder_id \
			     -content_type "ims_item_object"]
    set new_ims_rev_id [content::revision::new -item_id $new_ims_item_id -title $item_name -creation_user $user_id \
			    -is_live "t"]
    
    # We need to insert in the ims_cp_items at the proper sort_order so we are going
    # to rearrenge the items sort_order and then fill the information for the item
    db_foreach get_items_to_reorder { } {
	set new_sort [expr $order + 1]
	db_dml reorder_items { }
    }
    

    db_dml update_ims_cp_items {
	update ims_cp_items set
	org_id = :org_id,
	identifier = :item_name,
	identifierref = :identifierref,
	item_title = :item_org_name,
	sort_order = :sort_order,
	parent_item = :parent_item
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

ad_returnredirect "one-course?man_id=$man_id"