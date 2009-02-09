ad_library {
    Tcl API for lors-central testing
}

aa_register_case null_parent_items_reference {
    Checks if null parent_item exist in ims_cp_items table, since all ims_item_id must have one 
    parent_item.
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
            set null_parent_items [db_string get_null_parents { 
		select 
                        count(ims_item_id) 
		from 
                        ims_cp_items 
		where 
                        parent_item is null
	    } -default 0]
            if { $null_parent_items > 0 } {
               set success_p 0
	    } else {
               set success_p 1 
	    }
	    aa_equals "There are not null parent_items" $success_p 1
	}
} 

aa_register_case lors_central_add_relation_check {
    Check if adds a new row (only one) to the ims_cp_manifest_class associating man_id and community_id
    ** Requirements:
    1. Two dotlrn classes
    2. One lors course
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set test_com_id [db_string get_community { 
		select max(community_id)
                from dotlrn_communities_all
	    }]
	    set test_com_id_2 [db_string get_community { 
		select min(community_id)
                from dotlrn_communities_all
	    }]
	    set test_man_id [db_string get_man_id { 
		select max(man_id)
                from ims_cp_manifests
	    }]
            set test_item_id [db_string get_item_id {
                select item_id
                from cr_revisions
                where revision_id = :test_man_id
            }]

	    # Testing where there is no association
            lors_central::add_relation -item_id $test_item_id -community_id $test_com_id
            set row_count [db_string get_row_count { 
		select count(man_id)
		from ims_cp_manifest_class
		where community_id = :test_com_id and man_id = :test_man_id
	    }]
            if { [string equal $row_count "1"] } {
		set success_p 1
	    } else {
		set success_p 0
	    }           
	    aa_true "Creates only one row" [string equal "1" "$success_p"]
	    
	    # Testing where there is already one association
            lors_central::add_relation -item_id $test_item_id -community_id $test_com_id_2
            set row_count [db_string get_row_count { 
		select count(man_id)
		from ims_cp_manifest_class
		where man_id = :test_man_id
	    }]
            if { [string equal $row_count "2"] } {
		set success_p 1
	    } else {
		set success_p 0
	    }           
	    aa_equals "Associate more than one communities to the same man_id" $success_p 1
	}
} 


aa_register_case lors_central_get_version_num {
    Check if giving one number for one item_id returns a revision_id with the same item_id
    ** Requirements:
    1. One LO with two or more versions
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set test_revision_id [db_string get_revision_id {
		select min(ims_item_id),org_id from ims_cp_items group by sort_order,org_id having count(ims_item_id) > 1;
	    }]
	    set test_item_id [db_string get_item_id {
		select item_id from cr_revisions where revision_id = :test_revision_id
	    }]
	    set test_count [db_string get_count {
		select count(revision_id) from cr_revisions where item_id = :test_item_id
	    }]
	    set test_revision_id_2 [db_string get_revision_id_2 {
		select max(revision_id) from cr_revisions where item_id = :test_item_id
	    }]
            set version_number_1 [lors_central::get_version_num -revision_id $test_revision_id]
            aa_equals "Min revision_id return version number equal to 1" $version_number_1 "1"

            set version_number_2 [lors_central::get_version_num -revision_id $test_revision_id_2]
            aa_equals "Max revision_id return version number equal to revisions count" $version_number_2 $test_count
	}
} 


aa_register_case lors_central_change_one_lo_version_check {
    Check if changes one LO version (ver_num) on ims_cp_items_map for one community_id and one man_id
    ** Requirements:
    1. One dotlrn class 
    2. One lors course associated to the class
    3. One LO with two versions inside the course associated to the class

} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set test_item_id [db_string get_item_id {
		select min(ims_item_id), org_id from ims_cp_items group by sort_order, org_id having count(ims_item_id) > 1;
	    }]
	    set test_item_id_2 [db_string get_item_id {
		select max(ims_item_id), org_id from ims_cp_items group by sort_order, org_id having count(ims_item_id) > 1;
	    }]
            set test_org_id [db_string get_org_id {
		select org_id 
		from ims_cp_items 
		where ims_item_id = :test_item_id
	    }]
            set test_man_id [db_string get_man_id {
                select man_id 
                from ims_cp_organizations 
                where org_id = :test_org_id 
            }]
	    set test_com_id [db_string get_com_id {
                select min(community_id)
                from ims_cp_items_map
                where org_id = :test_org_id and
		man_id = :test_man_id
             }]

	    set test_com_id_2 [db_string get_com_id {
                select max(community_id)
                from ims_cp_items_map
                where org_id = :test_org_id and
		man_id = :test_man_id
             }]
	    
	    set ver_num_1 [lors_central::get_version_num -revision_id $test_item_id]
	    set ver_num_2 [lors_central::get_version_num -revision_id $test_item_id_2]
	    lors_central::change_one_lo_version -ver_num $ver_num_1 -man_id $test_man_id \
		-community_id $test_com_id -ims_item_id $test_item_id

	    set check_item [db_string get_item {
		select ims_item_id
		from ims_cp_items_map
		where community_id = :test_com_id and
		org_id = :test_org_id and 
		man_id = :test_man_id and 
		ims_item_id in ( select revision_id from cr_revisions where item_id = 
				 ( select item_id from cr_revisions where revision_id = :test_item_id ))
	    }]
	    aa_equals "Change to first version_number ($test_item_id)" $check_item $test_item_id
	    lors_central::change_one_lo_version -ver_num $ver_num_2 -man_id $test_man_id \
		-community_id $test_com_id -ims_item_id $test_item_id
	    set check_item [db_string get_item {
		select ims_item_id
		from ims_cp_items_map
		where community_id = :test_com_id and
		org_id = :test_org_id and 
		man_id = :test_man_id and 
		ims_item_id in ( select revision_id from cr_revisions where item_id = 
				 ( select item_id from cr_revisions where revision_id = :test_item_id ))
	    }]
	    aa_equals "Change to last version_number ($test_item_id_2)" $check_item $test_item_id_2

 	    lors_central::change_one_lo_version -ver_num $ver_num_2 -man_id $test_man_id \
		-community_id $test_com_id_2 -ims_item_id $test_item_id
	    set check_item [db_string get_item {
		select ims_item_id
		from ims_cp_items_map
		where community_id = :test_com_id_2 and
		org_id = :test_org_id and 
		man_id = :test_man_id and 
		ims_item_id in ( select revision_id from cr_revisions where item_id = 
				 ( select item_id from cr_revisions where revision_id = :test_item_id ))
	    }]
	    aa_equals "Change to last version_number ($test_item_id_2) on different community" $check_item $test_item_id_2

	    lors_central::change_one_lo_version -ver_num "0" -man_id $test_man_id \
		-community_id $test_com_id_2 -ims_item_id $test_item_id_2

	    set check_item [db_string get_hide_p {
		select hide_p
		from ims_cp_items_map
		where community_id = :test_com_id_2 and
		ims_item_id = :test_item_id_2
	    }]
	    aa_equals "Hide on one community" $check_item "t"
	}
} 

aa_register_case lors_central_change_version_check {
    Check if changes one course version (ver_num of man_id) on ims_cp_manifest_class and also maps each item in 
    ims_cp_items_map to the new version
    ** Requirements:
    1. One dotlrn class 
    2. One lors course associated to one or more classes with 2 or more versions

} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
            set man_id [db_string get_man_id {
                select min(man_id)
                from ims_cp_manifest_class
            }]
	    set item_id [lors_central::get_item_id -revision_id $man_id]
            set man_id1 [db_string get_man_id_2 {
                select min(revision_id) 
		from cr_revisions
		where item_id = :item_id
            }]
            set man_id2 [db_string get_man_id_2 {
                select max(revision_id) 
		from cr_revisions
		where item_id = :item_id
            }]
            set ver_num1 [lors_central::get_version_num -revision_id $man_id1]
	    set ver_num2 [lors_central::get_version_num -revision_id $man_id2]
	    set com_id [db_string get_com_id {
                select min(community_id)
                from ims_cp_manifest_class
		where man_id = :man_id
            }]
	    lors_central::change_version -item_id $item_id -ver_num $ver_num1 -community_id $com_id

	    set success_p [db_string check_ims_cp_manifest_class {
		select count(man_id) 
		from ims_cp_manifest_class 
		where man_id = :man_id1 and community_id = :com_id
	    } -default 0]
	    aa_equals "Version $ver_num1 associated to community $com_id" $success_p 1

	    lors_central::change_version -item_id $item_id -ver_num $ver_num2 -community_id $com_id
	    set success_p [db_string check_ims_cp_manifest_class {
		select count(man_id) 
		from ims_cp_manifest_class 
		where man_id = :man_id2 and community_id = :com_id
	    } -default 0]
	    aa_equals "Version $ver_num2 associated to community $com_id" $success_p 1

	}
}

aa_register_case lors_central_change_version_all_courses_check {
    Checks if all communties associated to any version of one course get the same man_id on ims_cp_manifest_class
    ** Requirements:
    1. Two dotlrn classes
    2. One course with two versions associated to the classes


} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set man_id ""
	    db_foreach get_man_ids {
		select man_id as test_man_id
		from ims_cp_manifest_class
	    } {
		if { [lors_central::get_revision_count -revision_id $test_man_id] > 1 } {
		    set man_id $test_man_id
		}
	    }
	    if { [empty_string_p $man_id] } {
		ad_return_complaint 1 "There are no course with two versions associated to dotlrn classes to make this test"
		ad_script_abort
	    }
	    set item_id [lors_central::get_item_id -revision_id $man_id]
	    set man_id1 [db_string get_man_id {
		select min(revision_id) from cr_revisions where item_id = :item_id
	    }]
	    set man_id2 [db_string get_man_id2 {
		select max(revision_id) from cr_revisions where item_id = :item_id
	    }]
	    set classes_count [db_string get_count {
		select count(man_id) from ims_cp_manifest_class
		where man_id in (select revision_id from cr_revisions where item_id = :item_id)
	    }]
	    
	    lors_central::change_version_all_courses -man_id $man_id1 -item_id $item_id
	    set classes_count1 [db_string get_count {
		select count(man_id) from ims_cp_manifest_class
		where man_id in (select revision_id from cr_revisions where item_id = :item_id)
	    }]

	    aa_equals "All classes watching the same versions $man_id1" $classes_count1 $classes_count

	    lors_central::change_version_all_courses -man_id $man_id2 -item_id $item_id
	    set classes_count2 [db_string get_count {
		select count(man_id) from ims_cp_manifest_class
		where man_id in (select revision_id from cr_revisions where item_id = :item_id)
	    }]

	    aa_equals "All classes watching the same versions $man_id2" $classes_count2 $classes_count

	}
}


aa_register_case lors_central_count_versions_check {
    Checks if returns the right number of revisions for one revision_id or item_id
    ** Requirements:
    1. One or more cr_items (with 1 or more revisions)
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set rev_list [db_list_of_lists get_revisions {
		select min(revision_id) 
		from cr_revisions group by item_id 
		having count(revision_id) > 1 }]
	    set revision_id [lindex $rev_list 0]
	    set item_id [lors_central::get_item_id -revision_id $revision_id]
	    set rev_count [db_string get_count { 
		select count(revision_id) 
		from cr_revisions
		where item_id = :item_id
	    }]
	    set proc_count [lors_central::get_revision_count -revision_id $revision_id]
	    aa_equals "Calling proc with revision_id $rev_count = $proc_count" $rev_count $proc_count
	    set proc_count [lors_central::get_revision_count -item_id $item_id]
	    aa_equals "Calling proc with item_id $rev_count = $proc_count" $rev_count $proc_count
	}
}

aa_register_case lors_central_drop_relation_check {
    Checks if deletes the ralation between one man_id and one community_id on ims_cp_manifest_class
    ** Requirements:
    1. One or more classes associated to one course
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set com_id [db_string get_com_id {
		select min(community_id) 
		from ims_cp_manifest_class
	    }]
	    set man_id [db_string get_man_id {
		select min(man_id) 
		from ims_cp_manifest_class
		where community_id = :com_id
	    }]
	    set item_id [lors_central::get_item_id -revision_id $man_id]
	    lors_central::drop_relation -item_id $item_id -community_id $com_id
	    set test [db_string check_relation {
		select count(man_id)
		from ims_cp_manifest_class
		where community_id = :com_id
		and man_id in ( select revision_id from cr_revisions where item_id = :item_id )
	    }]
	    aa_equals "Deleting everything from ims_cp_manifest_class" $test "0"
	}
}

aa_register_case lors_central_get_class_name_check {
    Checks if the dotlrn class name is the same
    ** Requirements:
    1. One dotlrn class
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set com_id [db_string get_community { 
		select min(community_id)
                from dotlrn_communities_all
	    }]
	    set name [db_string get_name {
		select pretty_name
		from dotlrn_class_instances_full
		where community_id  = :com_id
	    }]
	    set proc_name [lors_central::get_class_name -community_id $com_id]
	    aa_equals "Returns the same name $name = $proc_name" $name $proc_name
	}
}

aa_register_case lors_central_get_folder_name_check {
    Checks if the folder name is correct
    ** Requirements:
    1. One LO course
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set folder_id [db_string get_folder_id { 
		select max(folder_id)
                from cr_folders
	    }]
	    set name [db_string get_name {
		select label
		from cr_folders
		where folder_id  = :folder_id
	    }]
	    set proc_name [lors_central::get_folder_name -folder_id $folder_id]
	    aa_equals "Returns the same name $name = $proc_name" $name $proc_name
	}
}


aa_register_case lors_central_get_item_id_check {
    Checks if the item_id is the correct
    ** Requirements:
    1. One cr_revision
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set rev_id [db_string get_rev_id { 
		select max(revision_id)
                from cr_revisions
	    }]
	    set item_id [db_string get_name {
		select item_id
		from cr_revisions
		where revision_id  = :rev_id
	    }]
	    set proc_item_id [lors_central::get_item_id -revision_id $rev_id]
	    aa_equals "Returns the same item_id $item_id = $proc_item_id" $item_id $proc_item_id
	}
}

aa_register_case lors_central_get_item_id_check {
    Checks if the item_id is the correct
    ** Requirements:
    1. One cr_revision
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set rev_id [db_string get_rev_id { 
		select max(revision_id)
                from cr_revisions
	    }]
	    set item_id [db_string get_name {
		select item_id
		from cr_revisions
		where revision_id  = :rev_id
	    }]
	    set proc_item_id [lors_central::get_item_id -revision_id $rev_id]
	    aa_equals "Returns the same item_id $item_id = $proc_item_id" $item_id $proc_item_id
	}
}


aa_register_case lors_central_get_parent_id_check {
    Checks if the parent_id is the correct
    ** Requirements:
    1. One cr_revision
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set item_id [db_string get_item_id { 
		select max(item_id)
                from cr_items
		where parent_id is not null
	    }]
	    set parent_id [db_string get_parent_id { 
		select parent_id
                from cr_items
		where item_id = :item_id
	    }]
	    set proc_parent_id [lors_central::get_parent_id -item_id $item_id]
	    aa_equals "Returns the same item_id $parent_id = $proc_parent_id" $parent_id $proc_parent_id
	}
}

aa_register_case lors_central_relation_between_check {
    Checks if the relation_between proc is correct
    ** Requirements:
    1. One cr_revision
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set man_id [db_string get_man_id { 
		select max(man_id)
                from ims_cp_manifest_class
	    }]
	    set com_id [db_string get_com_id { 
		select min(community_id)
                from ims_cp_manifest_class
		where man_id = :man_id
	    }]
	    set item_id [lors_central::get_item_id -revision_id $man_id]
	    set rel_p [db_string get_rel {
		select 1 from ims_cp_manifest_class
		where community_id = :com_id and man_id in
		( select revision_id from cr_revisions where item_id = :item_id )
	    }]
	    set proc_rel_p [lors_central::relation_between -item_id $item_id -community_id $com_id]
	    aa_equals "Relation between proc" $rel_p $proc_rel_p
	}
}

aa_register_case lors_central_set_sort_order_check {
    Checks if the item_id sort_order is the correct
    ** Requirements:
    1. One LO
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set ims_item_id [db_string get_ims_item_id { 
		select max(ims_item_id)
                from ims_cp_items
	    }]
	    lors_central::set_sort_order -ims_item_id $ims_item_id -sort_order 2
	    set proc_sort [db_string get_sort { 
		select sort_order 
		from ims_cp_items 
		where ims_item_id = :ims_item_id} -default 0]
	    aa_equals "Sort order proc set the right sort" $proc_sort "2"

	    set proc_sort [lors_central::set_sort_order -ims_item_id $ims_item_id]
	    set sort_p [db_string get_sort { 
		select 1 
		from ims_cp_items 
		where sort_order is not null 
		and ims_item_id = :ims_item_id } -default 0] 
	    aa_true "Sort order proc set the right sort (when not sendind the sort_order number)" $sort_p
	}
}

aa_register_case lors_central_check_item_name_check {
    Checks if returns a new name for a given item_name
    ** Requirements:
    1. One Course
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set rev_id [db_string get_rev_id {
		select max(ims_item_id)
		from ims_cp_items
	    }]
	    set item_id [lors_central::get_item_id -revision_id $rev_id]
	    set parent_id [lors_central::get_parent_id -item_id $item_id]
	    set name [db_string get_nanme {
		select name
		from cr_items
		where item_id = :item_id
	    }]
	    set proc_name [lors_central::check_item_name -parent_id $parent_id -name $name]
	    if { [string equal $name $proc_name] } {
		set success_p 0
	    } else {
		set success_p 1
	    }
	    aa_true "Name exist, gives a new name" $success_p
	    set name ${name}h
	    set proc_name [lors_central::check_item_name -parent_id $parent_id -name $name]
	    if { [string equal $name $proc_name] } {
		set success_p 1
	    } else {
		set success_p 0
	    }
	    aa_true "Name doesn't exist, gives the same name" $success_p
	}
}

aa_register_case lors_central_check_privilege {
    Checks lors_central::check_privilige proc
    ** Requirements:
    1. One Course
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set item_id [db_string get_item_id {
		select max(object_id)
		from acs_permissions
		where privilege = 'admin'
	    }]
	    set user_id [db_string get_user_id {
		select min(grantee_id)
		from acs_permissions
		where privilege = 'admin'
		and object_id = :item_id
	    }]
	    set proc_result [lors_central::check_privilege -user_id $user_id -item_id $item_id]
	    aa_true "Check privilege proc when user has privilege" $proc_result
	    set proc_result [lors_central::check_privilege -user_id 0 -item_id $item_id]
	    aa_true "Check privilege proc when user has no privilege" [string equal $proc_result 0]
	}
}

aa_register_case lors_central_item_editable_info {
    Check if sending an editable item returns the correct information
    ** Requirements:
    1. One editable LO and one that isn't
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set rev_id [db_string get_item_id {
		select max(revision_id)
		from cr_revisions
		where mime_type = 'text/html' and
		revision_id in (select live_revision from cr_items)
	    }]
	    set item_id [lors_central::get_item_id -revision_id $rev_id]
	    set proc_result [lors_central::item_editable_info -item_id $item_id]
	    aa_true "Sending one editable item" [lindex $proc_result 3]
	    set rev_id [db_string get_item_id {
		select max(revision_id)
		from cr_revisions
		where mime_type = 'image/gif' and
		revision_id in (select live_revision from cr_items)
	    }]
	    set item_id [lors_central::get_item_id -revision_id $rev_id]
	    set proc_result [lors_central::item_editable_info -item_id $item_id]
	    aa_true "Sending one non editable item" [string equal [lindex $proc_result 3] 0]
	}
}


aa_register_case lors_central_item_editable_p {
    Check if sending an editable item returns the correct information
    ** Requirements:
    1. One editable LO and one that isn't
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set rev_id [db_string get_item_id {
		select max(revision_id)
		from cr_revisions
		where mime_type = 'text/html' and
		revision_id in (select live_revision from cr_items)
	    }]
	    set item_id [lors_central::get_item_id -revision_id $rev_id]
	    set proc_result [lors_central::item_editable_p -item_id $item_id]
	    aa_true "Sending one editable item" $proc_result
	    set rev_id [db_string get_item_id {
		select max(revision_id)
		from cr_revisions
		where mime_type = 'image/gif' and
		revision_id in (select live_revision from cr_items)
	    }]
	    set item_id [lors_central::get_item_id -revision_id $rev_id]
	    set proc_result [lors_central::item_editable_p -item_id $item_id]
	    aa_true "Sending one non editable item" [string equal $proc_result 0]
	}
}

aa_register_case lors_central_package_install {
    Check if the package creates the right folders and types
    ** Requires
    1. lors-central package alreay installed
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set success_p [db_string check_folder { 
		select 1 
		from  cr_folders
		where label = 'LORSM Root Folder'} -default 0]
	    aa_true "Folders created"  $success_p
	    set success_p [db_string check_folder { 
		select 1 
		from  cr_folders
		where label = 'LORSM Manifest Folder'} -default 0]
	    aa_true "Folders created"  $success_p
	    set success_p [db_string check_folder { 
		select 1 
		from  cr_folders
		where label = 'LORSM Organizations Folder'} -default 0]
	    aa_true "Folders created"  $success_p
	    set success_p [db_string check_folder { 
		select 1 
		from  cr_folders
		where label = 'LORSM Items Folder'} -default 0]
	    aa_true "Folders created"  $success_p
	    set success_p [db_string check_folder { 
		select 1 
		from  cr_folders
		where label = 'LORSM Resources Folder'} -default 0]
	    aa_true "Folders created"  $success_p
	}
}

aa_register_case lors_central_imscp_manifest_add {
    Checks if a new manifest_id is created
    ** Requires
    1. Once course
} {
    aa_run_with_teardown \
       -rollback \
	-test_code  {
	    set man_id [db_string get_man_id {select max(man_id) from ims_cp_manifests}]
	    db_1row get_info { select * from ims_cp_manifests where man_id = :man_id }
	    set man_folder_id [db_string get_folder_id {
                select folder_id
                from  cr_folders
                where label = 'LORSM Manifest Folder'} -default 0]
	    
	    
	    set new_man_id [lors_central::imscp::manifest_add \
				-identifier $identifier\
				-course_name "test_check" \
				-version "" \
				-orgs_default $orgs_default\
				-hasmetadata  $hasmetadata\
				-parent_man_id $parent_man_id\
				-isscorm $isscorm\
				-folder_id $folder_id\
				-package_id "" \
				-community_id "" \
				-user_id "" \
				-creation_ip "" \
				-version_id "" \
				-man_folder_id $man_folder_id]

	    set success_p [db_string get_check { select 1 from ims_cp_manifests where man_id = :new_man_id } -default 0]
	
	    aa_true "New man_id created"  $success_p
	}
}
