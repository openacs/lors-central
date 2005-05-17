ad_page_contract {
    Display all shared items for adding
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    man_id:notnull
    org_id:notnull
    {sort_order ""}
    parent_item:notnull
    {ims_item_id ""}
    clipboard_object_id:optional
}

set user_id [ad_conn user_id]

# Checking swa privilege over lors-central
lors_central::is_swa

set new_lo_link "man_id=$man_id&org_id=$org_id&parent=$parent_item"
set page_title [_ lors-central.add_an_existent]
set context "[list [list "one-course?man_id=$man_id" [_ lors-central.one_course]] [list "new-learning-object?$new_lo_link" [_ lors-central.new_object]] $page_title]"


if {[exists_and_not_null clipboard_object_id]} {
    db_transaction {
	if { [empty_string_p $sort_order] } {
	    set max_sort_order [db_string get_max_sort_order { } ]
	    set sort_order [expr $max_sort_order + 1]
	} else {
	    incr sort_order
	} 
	set course_name [lors_central::get_course_name -man_id $man_id]
	set root_folder [lors_central::get_root_folder_id]
	set folder_id [db_string get_folder_id { }]
	set clipboard_object_item_id [lors_central::get_item_id -revision_id $clipboard_object_id]
	set item [content::item::get -item_id $clipboard_object_item_id -array_name original_item]
        if { !$item } {
	    ad_return_complaint 1 "No Item associated to this object"
	    ad_script_abort
	}

	# We get the identifier from the clipped resource
	set identifierref [db_string get_res_identifier { } -default ""]
	set href [db_string get_res_href { } -default ""]

	# We get the item_title and identifier that the clipped object has associated
	set item_title [db_string get_item_title { } -default "Untitled"]
	set identifier [db_string get_item_title { } -default "Untitled"]
	
	# No item, create a new one
	# We need to know where the new resource should be
	set res_root_folder_id [lors_central::get_root_resources_folder_id]
	set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]
	
	# We check the name 
	set item_title [lors_central::check_item_name -parent_id $res_folder_id -name $item_title]
	
	set new_res_rev_id $clipboard_object_id

	# Now are going to create a new item (ims_cp_item)
	# We need the folder_id of the course to store the new item
	set root_ims_folder [lors_central::get_root_items_folder_id]
	set items_folder_id [db_string get_items_folder_id { }]
	    
	# We check the name and create a new item
	set item_title [lors_central::check_item_name -parent_id $items_folder_id -name $item_title]
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
	    identifier = :identifier,
	    identifierref = :identifierref,
	    parent_item = :parent_item,
	    item_title = :item_title,
	    sort_order = :sort_order
	    where ims_item_id = :new_ims_rev_id
	}
	
    	# Now this new revision_id is the one that holds the content of the new resource 
        # We have to make a row in ims_cp_items_to_resources table
	db_dml insert_new_item_to_res {
	    insert into ims_cp_items_to_resources (ims_item_id, res_id )
	    values (:new_ims_rev_id, :new_res_rev_id)
	} 
	
    }
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
    
    ad_returnredirect [export_vars -base "one-learning-object" {man_id {ims_item_id $new_ims_rev_id}}]
}

set clipboard_add_url [export_vars -base "add-lo" {man_id ims_item_id org_id sort_order parent_item}]

