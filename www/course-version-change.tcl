ad_page_contract {
   author Miguel Marin (miguelmarin@viaro.net)
   author Viaro Networks www.viaro.net
} {
    man_id:notnull
}

set user_id [ad_conn user_id]

# Checking privilege over lors-central
lors_central::check_permissions

set item_id [lors_central::get_item_id -revision_id $man_id]

# Check for admin permissions over the course
set permission_p [lors_central::check_privilege -item_id $item_id -user_id $user_id]

if { !$permission_p } {
    ad_return_complaint 1 "You don't have permission to change versions on this course"
    ad_script_abort
}

# Update the man_id field on all classes that use this man_id
lors_central::change_version_all_courses -man_id $man_id -item_id $item_id

# We need to update the ims_cp_items_map table to have same man_id for all clases
# First we are going to get all the communities id that are associated to this man_id

set com_list [db_list_of_lists get_communities {
    select distinct community_id from ims_cp_manifest_class
    where man_id in ( select revision_id from cr_revisions where item_id = :item_id )
}]

# Now we ae going to delete all from ims_cp_items related to this man_id
db_dml delete_from_items_map {
    delete from ims_cp_items_map 
    where man_id in ( select revision_id from cr_revisions where item_id = :item_id )
}


# Now we are going to insert the same course for all dotlrn classes
set org_list [db_list_of_lists get_organizations { 
   select org_id
   from ims_cp_organizations
   where man_id = :man_id
}]
foreach community_id $com_list { 
    foreach org_id $org_list {
	set items_list [db_list_of_lists get_items {
	    select ims_item_id
	    from ims_cp_items 
	    where org_id = :org_id
            and ims_item_id in ( select live_revision 
                                 from cr_items 
                                )
	}]
	foreach ims_item_id $items_list {
	    db_dml insert_items {
		insert into ims_cp_items_map
		(man_id,org_id,community_id,ims_item_id)
		values
		(:man_id,:org_id,:community_id,:ims_item_id)
	    }
	}
    }
    
}

ad_returnredirect "one-course-associations?man_id=$man_id"