ad_library {

    Tcl API for lors-central store and manipulation

    @author Miguel Marin (miguelmarin@viaro.net) 
    @author Viaro Networks www.viaro.net
}

namespace eval lors_central {}

ad_proc -private lors_central::owner {
    -user_id:required
    -object_id:required
} {
    Returns 1 if user_id is the creator of the object_id, 0 otherwise
} {
    return [db_string get_creation_user { } -default 0]
}

ad_proc -private lors_central::get_ims_item_id_or_res_id {
    {-ims_item_id ""}
    {-res_id "" }
} {
    Returns ims_item_id if you provide res_id, or returns res_id if you provide ims_item_id
    You must provide either res_id or ims_item_id
} {
    if { ![empty_string_p $ims_item_id] } {
	return [db_string get_res_id { }]
    } else {
	return [db_string get_ims_item_id { }]
    } 
}

ad_proc -private lors_central::check_permissions {
    {-object_id ""}
    {-check_inst ""}
} {
    Checks several privileges for user_id, default to logged user over the system.

    @object_id   Send this if you want to check if user_id has permissions over this object_id.
    @check_inst  Set it to "t" if you want to check if the user_id that watch's this page is an dotlrn
                 instructor.
} {
    if { ![info exists user_id] } {
	set user_id [ad_conn user_id]
    }
    set package_id [ad_conn package_id]

    # Get the number specified in the parameter, this parameter tell if 
    # only the swa can manage lors-central or any one else
    set sec_level [parameter::get -parameter "ManageLorsCentralP"]

    if { $sec_level } {
	if { ![acs_user::site_wide_admin_p] } {
	    ad_return_complaint 1 "<b>[_ lors-central.we_are_sorry]</b>"
	    ad_script_abort
	} else {
	    return
	}
    } else {
	if { ![empty_string_p $check_inst] } {
	    if { ![lors_central::check_inst -user_id $user_id] } { 
		ad_return_complaint 1 "<b>[_ lors-central.we_are_sorry]</b>"
		ad_script_abort
	    }
	} 
	if { ![empty_string_p $object_id] } {
	    permission::require_permission -party_id $user_id -object_id $object_id -privilege "admin"
	}
    }
    return
}

ad_proc -private lors_central::check_inst {
    -user_id:required
    {-community_id ""}
} {
    Checks if user id has instructor or admin role in @community_id@ or any community_id, returns 1 if it does,
    0 otherwise
} {
    if { [acs_user::site_wide_admin_p] } {
	return 1
	ad_script_abort
    }
    if { ![empty_string_p $community_id] } {
	set extra_query "and community_id = $community_id"
    } else {
	set extra_query ""
    }
    set count [db_string check_inst { } -default 0]
    if { $count > 0 } {
	return 1
    } else {
	return 0
    }
}

ad_proc -private lors_central::set_sort_order {
    {-sort_order ""}
    -ims_item_id:required
} {
    Updates the ims_cp_items sort_order field with @sort_order@, if not present then
    takes the sort_order assigned to one ims_cp_item to this ims_cp_item
    -sort_order    The sort_order number to put to the ims_cp_item field
    -ims_item_id   The ims_item_id
} {
    if { [empty_string_p $sort_order] } {
        set sort_order [db_string get_sort_order { }]
    }
    db_dml set_sort_order { }
}


ad_proc -private lors_central::change_one_lo_version {
    -ver_num:required
    -man_id:required
    -community_id:required
    -ims_item_id:required
} {
    Changes one LO version (ver_num) to display on one dotlrn class (community_id) for one course (man_id)
} {
    set item_id [lors_central::get_item_id -revision_id $ims_item_id]
    if { ![string equal $ver_num 0] } {
	set new_ims_item_id [lors_central::get_rev_id_from_version_num -ver_num $ver_num -item_id $item_id]
	db_dml update_item_map { 
	    update ims_cp_items_map
	    set ims_item_id = :new_ims_item_id, hide_p = 'f'
	    where man_id = :man_id and community_id = :community_id
	    and ims_item_id in ( select revision_id from cr_revisions where item_id = :item_id )
	}
    } else {
	db_dml hide_learning_object { 
	    update ims_cp_items_map
	    set hide_p  = 't'
	    where man_id = :man_id and community_id = :community_id
	    and ims_item_id = :ims_item_id
	}
    }
}

ad_proc -private lors_central::folder_id_from_man_parent { 
    -parent_id:required
    -man_id:required
} {
    Returns the folder_id of the folder with man_id = @man_id@ and parent_id = @parent_id@
} {
    set folder_name [lors_central::get_course_name -man_id $man_id]
    return [db_string get_folder_id { } -default ""]
}


ad_proc -private lors_central::get_root_folder_id { } {
    Returns the folder_id of the folder with the name "LORSM Root Folder"
} {
    return [db_string get_folder_id_from_name { } ]
}

ad_proc -private lors_central::get_root_organizations_folder_id { } {
    Returns the folder_id of the folder with the name "LORSM Organizations Folder"
} {
    return [db_string get_folder_id_from_name { } ]
}


ad_proc -private lors_central::get_root_resources_folder_id { } {
    Returns the folder_id of the folder with the name "LORSM Resources Folder"
} {
    return [db_string get_folder_id_from_name { } ]
}

ad_proc -private lors_central::get_root_manifest_folder_id { } {
    Returns the folder_id of the folder with the name "LORSM Manifest Folder"
} {
    return [db_string get_folder_id_from_name { } ]
}


ad_proc -private lors_central::get_root_items_folder_id { } {
    Returns the folder_id of the folder with the name "LORSM Items Folder"
} {
    return [db_string get_folder_id_from_name { } ]
}


ad_proc -private lors_central::get_folder_name { 
    -folder_id:required 
} {
    Returns the folder name with folder_id = @folder_id@
} {
    return [db_string get_folder_name_from_id { } ]
}


ad_proc -private lors_central::get_parent_id { 
    -item_id:required 
} {
    Returns the parent_id id of @item_id@
} {
    return [db_string get_parent_id { } ]
}


ad_proc -private lors_central::get_item_title { 
    -item_id:required 
} {
    Returns the item title of @item_id@
} {
    return [db_string get_title { } ]
}


ad_proc -private lors_central::get_revision_count { 
    {-item_id "" } 
    {-revision_id "" }
} {
    Returns the revision count of @item_id@, you must suplly either item_id or revision_id
} {
    if { [empty_string_p $item_id] } {
	if { [empty_string_p $revision_id] } {
            ad_return_complaint 1 "<b>You must supply either item_id or revision_id</b>"
            ad_script_abort 
	} else {
	    set item_id [lors_central::get_item_id -revision_id $revision_id]
	}
    } 
    return [db_string get_count { } ]
}


ad_proc -private lors_central::check_item_name { 
    -parent_id:required 
    -name:required
} {
    Returns a new name for @name@ and @parent_id@ if necessary
} {
    set item_name [db_string check_name { } -default ""]
    if { ![empty_string_p $item_name] } {
        set count [db_string count_items { } -default 0]
        set name "(${count})$name"
    }
    return $name
}

ad_proc -private lors_central::get_item_res_id {
    -ims_item_id:required
} {
    returns the resource id associtaed with this item
} {
    return [db_string get_res_id {} -default ""]
}
ad_proc -private lors_central::get_content_revision_id { 
    -ims_item_id:required 
} {
    Returns the revision_id that holds the content of one ims_item_id
} {
    # Get the resource id
    set res_id [lors_central::get_item_res_id -ims_item_id $ims_item_id]
    set href [lors_central::get_res_href -res_id $res_id]
    # Get the file_id
    return [db_string get_file_id { } -default 0]
}

ad_proc -private lors_central::get_item_url { 
    -ims_item_id:required 
    -man_id:required
} {
    Returns the URL associated to one ims_item_id and man_id
} {
    # We get the folder of one course where the files are stored
    set root_folder [lors_central::get_root_folder_id]
    set name [lors_central::get_course_name -man_id $man_id]
    set folder [db_string get_folder { }]

    # We get the resource href to get the subfolder inside folder
    set href [lors_central::get_href -ims_item_id $ims_item_id]
    set path_list [split $href "/"]
    set char [string range $href 0 0]
    if { [string equal $char "/"] } {
	set subfolder_name [lindex $path_list 1]
        set url_name [lindex $path_list 2]
    } else {
        set subfolder_name [lindex $path_list 0]
        set url_name [lindex $path_list 1]
    }

    set sub_folder_id [db_string get_subfolder_id { } -default ""]
    if { ![empty_string_p $sub_folder_id] } {
	# The subfolder is in this course get the file
	set file_id [db_string get_file_id { }]
    } else {
	# The url is on another folder of another course so we will get it using the 
	# res_id associated to this ims_item_id and repeating the above process
	set man_id [db_string get_other_man_id { }]
	set name [lors_central::get_course_name -man_id $man_id]
	set folder [db_string get_folder { }]
	set sub_folder_id [db_string get_subfolder_id {	} -default ""]
	set file_id [db_string get_file_id { }]
    }
    return $file_id
}


ad_proc -private lors_central::get_href { 
    -ims_item_id:required 
} {
    Returns the href of the res_id associated to ims_item_id
} {
    # Get the resource id
    set res_id [lors_central::get_item_res_id -ims_item_id $ims_item_id]
    return [lors_central::get_res_href -res_id $res_id]
}

ad_proc -private lors_central::get_res_href {
    -res_id:required
} {
    Returns the href of the resource
} {
    return [db_string get_res_href {} -default ""]
}
ad_proc -private lors_central::get_res_file_id {
    -res_id:required
} {
    Get file_id that is associated to this resource with the same href
} {
    return [db_string get_file_id {} -default ""]
}

ad_proc -private lors_central::get_item_name { 
    -ims_item_id:required 
} {
    Returns the item_name of the ims_item_id
} {
    return [db_string get_name { }]
}


ad_proc -private lors_central::relation_between { 
    {-item_id ""}
    -community_id:required
    {-man_id ""}
} {
    Returns the 1 if there is an association between a dotlrn class or community 
    and the item_id, 0 otherwise, you should provide either man_id or item_id
    @man_id@         The manifest id of the course
    @item_id@        The item_id that has all manifests as revisions
    @community_id@   The class_id or community_id of dotlrn
} {
    if { ![empty_string_p $man_id] } {
	set item_id [lors_central::get_item_id -revision_id $man_id]
    }
    return [db_string get_relation { } -default 0]
}


ad_proc -private lors_central::add_relation { 
    -item_id:required
    -community_id:required
} {
    Add a new row to the ims_cp_manifest_class to associate one community_id (class or community)
    with a man_id
    @item_id@        Item id that has man_id as revisions
    @community_id@   The community_id of the dotlrn class or community
} {
    set lorsm_instance_id [lors_central::get_package_instance_id -community_id $community_id]
    set man_id [content::item::get_live_revision -item_id $item_id]
    set exist_association [db_string exist_assoc { } -default "0" ]
    if { [string equal $exist_association "0"] } {
        set exist_man_id [db_string exist_man_id { } -default "0"]
        if { [string equal $exist_man_id "0"] } {
            # Insert in the ims_cp_manifest_class
	    db_dml insert_info { }
	} else {
            # Update the ims_cp_manifest_class
            db_dml update_info { }
        }
    } else {
        # Insert in the ims_cp_manifest_class
        if { ![db_string get_rel { } -default 0] } {
	    db_dml insert_info { }
	}
    }
}


ad_proc -private lors_central::drop_relation { 
    -item_id:required
    -community_id:required
} {
    Delete a row from the ims_cp_manifest_classes to drop one association of one community_id (class or community)
    with a man_id
    @item_id@        Item id
    @community_id@   The community_id of the dotlrn class or community
} {
    db_dml delete_relation { }
}


ad_proc -private lors_central::get_item_id { 
    -revision_id:required 
} {
    Returns the item_id of one @revision_id@
    @revision_id@   Revision ID
} {
    return [db_string get_item_id { } -default 0]
}


ad_proc -private lors_central::count_versions { 
    {-man_id ""}
    {-item_id ""}
} {
    Returns the number of versions that @man_id@ has, You must supply either a man_id or an item_id
    @man_id@   Manifest ID
} {
    if { [empty_string_p $item_id]} {
        set item_id [lors_central::get_item_id -revision_id $man_id]
    }
    return [db_string count_versions { } -default 0]
}


ad_proc -private lors_central::get_version_num { 
    -revision_id:required 
} {
    Get a list of all revisions associated to one @revision_id@ in asc order, and returns the position of the @revision_id@
    in that list plus 1

    @revision_id@   Revision ID
    returns    position in list + 1
} {
    set item_id [lors_central::get_item_id -revision_id $revision_id]
    set versions [list]
    set versions [db_list_of_lists get_all_versions { }]
    return [expr [lsearch -exact $versions $revision_id] + 1]
}


ad_proc -private lors_central::get_rev_id_from_version_num { 
    -ver_num:required 
    -item_id:required
} {
    Returns revision_id for given version number @ver_num@
  
    @ver_nun@   Version Number
    returns     revision_id
} {
    set versions [list]
    set versions [db_list_of_lists get_all_versions { }]
    return [lindex $versions [expr $ver_num - 1]]
}


ad_proc -private lors_central::change_version {
    -item_id:required
    -ver_num:required
    -community_id:required
} {

} {
    set man_id [lors_central::get_rev_id_from_version_num -ver_num $ver_num -item_id $item_id]
    db_dml delete_items_map {
        delete from ims_cp_items_map
        where man_id = :man_id
    }
    db_dml update_version { }
    set org_list [db_list_of_lists get_organizations { }]
    foreach org_id $org_list {
	set items_list [db_list_of_lists get_ims_items { }]
        foreach ims_item_id $items_list {
            db_dml insert_items { }
        }
    }
}


ad_proc -private lors_central::get_man_id { 
    -community_id:required 
    -item_id:required
} { 
    Returns the manifest id for one community_id and one item_id
} {
    return [db_string get_man_id { }]
}


ad_proc -private lors_central::get_package_instance_id { 
    -community_id:required 
} {
    Gets the package_id of the lorsm instance related to the evaluation portlet for this community
} {
    set pkg_id [db_string get_package_id { } -default 0]
    if { [string equal $pkg_id "0"] } {
        ad_return_complaint 1 "<b>You need to have lorsm-portlet in your class before associate this course</b>"
        ad_script_abort
    } else {
        return $pkg_id
    }
}


ad_proc -private lors_central::get_course_name { 
    -man_id:required 
} {
    Gets the Course Name of  man_id
} {
    return [db_string get_course_name { } -default ""]
}


ad_proc -private lors_central::get_username { 
    -user_id:required 
} {
    Return the User Name of @user_id@
} {
    return [db_string  get_user_name_from_id {} -default ""]
}


ad_proc -private lors_central::get_class_name { 
    -community_id:required 
} {
    Return the dotLRN class name of @community_id@
} {
    return [db_string get_name { }]
}


ad_proc -private lors_central::get_live_classes { 
    -man_id:required 
} {
    Return the Number of classes that are using this man_id
} {
    return [db_string get_num_classes { } -default 0]
}


ad_proc -private lors_central::check_privilege { 
    -item_id:required 
    -user_id:required
} {
    Return 1 if the user_id has admin privilege over item_id, 0 otherwise
    @item_id@   The item_id to check admin privilege
    @user_id@   The user_id that holds the admin privilege
} {
    if { ![acs_user::site_wide_admin_p -user_id $user_id ]} {
	set permission_p [db_string check_permission { } -default 0] 
    } else {
        set permission_p 1
    }
    return $permission_p
}


ad_proc -private lors_central::change_version_all_courses {
    -man_id:required
    -item_id:required
} {
    Update the ims_cp_manifest_class so all classes associated to this man_id use the same course
    @man_id@  The manifest id to associate to all classes
    @item_id@ The item_id of the man_id

} {
    db_foreach get_all_communities {        
	select
	icmc.community_id as com_id,
	icmc.lorsm_instance_id as lors_ins_id,
	icmc.isenabled as ie,
	icmc.istrackable as it
	from
	ims_cp_manifest_class icmc
	where
	icmc.man_id in ( select revision_id
			 from cr_revisions
			 where item_id = :item_id )
    } {
        # We update the rows with the new revision_id ( man_id ) so every class that use this course
        # will have the same course version.
        db_dml update_course {          
	    update ims_cp_manifest_class
	    set
	    man_id = :man_id,
	    lorsm_instance_id = :lors_ins_id,
	    isenabled = :ie,
	    istrackable = :it
	    where
	    community_id = :com_id and 
	    man_id in ( select revision_id
                           from cr_revisions
			where item_id = :item_id
			)
	}
    }
}


ad_proc -public lors_central::get_object_info {
    -file_id:required
    -revision_id
} {
    returns an array containing the  object info
} {
    
    set user_id [ad_conn user_id]
    set root_folder_id [lors_central::get_root_folder_id]
    if {![exists_and_not_null revision_id]} {
        set revision_id $file_id
    }
    
    set file_item_id [lors_central::get_item_id -revision_id $file_id]
    db_1row file_info {} -column_array file_object_info
    
    set content [db_exec_plsql get_content {}]
    
    if {[string equal $file_object_info(storage_type) file]} {
        set filename [cr_fs_path $file_object_info(storage_area_key)]
        append filename $content
        set fd [open $filename]
        set content [read $fd]
        close $fd
    }
    
    set file_object_info(content) $content
    return [array get file_object_info]
}

ad_proc -public lors_central::item_editable_info {
    -item_id:required
} {
    Returns an array containing elements editable_p, mime_type, file_extension
    if an  item is editable through the browser, editable_p is set to 1
    @error 
} {
    # ideally, this would get values from parameters
    # hardcoding it for now
    set editable_mime_types [list "text/html" "text/plain"]
    
    # this should work even if no revision is live
    # changing to use _best_ revision
    item::get_mime_info [item::get_best_revision $item_id]
    
    if {[lsearch -exact $editable_mime_types [string tolower $mime_info(mime_type)]] != -1} {
        set mime_info(editable_p) 1
    } else {
        set mime_info(editable_p) 0
    }
    return [array get mime_info]
}


ad_proc -public lors_central::item_editable_p {
    -item_id:required
} {
    returns 1 if item is editable via browser
    
} {
    array set item_editable_info [lors_central::item_editable_info -item_id $item_id]
    
    return $item_editable_info(editable_p)
}

ad_proc -public lors_central::add_file {
    -res_id
    {-file_content ""}
    -mime_type
    {-tmp_filename ""}
    -filename
    -title 
    -man_id 
    {-user_id ""}
} {
    @param file_content
    @param tmp_filename
} {
    if {![exists_and_not_null user_id] && [ad_conn -connected_p] }  {
	set user_id [ad_conn user_id]
    }
    db_transaction {
	# We get the resource_id to get the href of the item that is the default
        # since this is the default file the ims_item has

        set res_href [lors_central::get_res_href -res_id $res_id]
	
        # We are going to create a new cr_revision (file) for the new file
        # We get the revision_id that holds the content on the CR, this is the
        # live_revision of one file_id

        set res_root_folder_id [lors_central::get_root_resources_folder_id]
        set res_folder_id [lors_central::folder_id_from_man_parent -man_id $man_id -parent_id $res_root_folder_id]

        set file_upload [lors_central::check_item_name -parent_id $res_folder_id -name $filename]
        set title [lors_central::check_item_name -parent_id $res_folder_id -name $title]

	# add a new resource revision

	set new_res_id [lors_central::add_resource_revision \
			    -res_id $res_id \
			    -name $title \
			    -user_id $user_id \
			    -man_id $man_id]

        set new_file_item_id [content::item::new -name $title -creation_user $user_id -parent_id $res_folder_id]
	

	# FIXME allow lors admins to set live immediately
	set new_file_revision_id [ lors_central::add_file_revision \
				       -res_id $new_res_id \
				       -name $file_upload \
				       -file_content $file_content \
				       -tmp_filename $tmp_filename \
				       -title $title \
				       -mime_type $mime_type \
				       -item_id $new_file_item_id \
				       -user_id $user_id]

	lors_central::resource_carry_forward_files -old_res_id $res_id -new_res_id $new_res_id
	lors_central::res_update_items \
	    -old_res_id $res_id \
	    -new_res_id $new_res_id \
	    -user_id [ad_conn user_id]

    }
    return $new_res_id
}

ad_proc -public lors_central::add_resource_revision {
    -res_id
    -name
    -user_id
    -man_id
} {
    add a revision to an ims_cp_resource 
} {
	set new_res_item_id [lors_central::get_item_id -revision_id $res_id]
	
	set new_res_rev_id [content::revision::new -item_id $new_res_item_id -title $name \
				-creation_user $user_id -is_live "t"]

	# Now we have to update the new row in the ims_cp_resources using this new resource (new_res_id)
	# we need a new href

	set href [lors_central::get_res_href -res_id $res_id]
	set split_href [split $href "/"]
	# We remove the last part
	set split_href [lrange $split_href 0 [expr [llength $split_href] - 2 ]]
	set new_href ""
	foreach element $split_href {
	    append new_href "$element/"
	}
	append new_href "$name"

	db_dml update_new_res {
	    update
	    ims_cp_resources
	    set
	    man_id = :man_id,
	    identifier = :name,
	    type = 'webcontent',
	    href = :href,
	    hasmetadata = 'f'
	    where
	    res_id = :new_res_rev_id
	}
    return $new_res_rev_id
}

ad_proc -public lors_central::resource_carry_forward_files {
    -old_res_id
    -new_res_id
    -exclude 
} {
    carry forward file mapping from old res to new resource
} {
    set exclude_clause ""
    if {[exists_and_not_null exclude]} {
	set exclude_clause " and file_id not in ([template::util::tcl_to_sql_list $exclude]) "
    }
	db_dml carry_forward_files "
	    insert into ims_cp_files ( 
				      select 
				      file_id, 
				      :new_res_id,
				      pathtofile,
				      filename,
				      hasmetadata 
				      from 
				      ims_cp_files 
				      where 
				      res_id = :old_res_id $exclude_clause)
	"
}
    
ad_proc -public lors_central::add_file_revision {
    -res_id
    -name
    -file_content
    -tmp_filename
    -title
    -mime_type
    -item_id
    -man_id
    {-user_id ""}
    {-description ""}
} {
    
} {
    
    set new_file_id [content::revision::new -item_id $item_id -title $title -creation_user $user_id \
			 -mime_type $mime_type -is_live "f" -description $description]
    
    # Now we store the content in the CR
    if {[exists_and_not_null tmp_filename]} {
	set cr_file [cr_create_content_file $item_id $new_file_id $tmp_filename]
    } else {
	set cr_file [cr_create_content_file_from_string $item_id $new_file_id $file_content]
    }
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
    set new_href [file join [file dirname [lors_central::get_res_href -res_id $res_id]] $title]
    # Now that we have the new item store in the CR, we have to make
    # some insert in some tables to adjust to the new cr_item.
    # First we have to reflect the new file in the resources table, so we have to make
    # a new XXXXcr_item andXXXX revision for the resource and insert it on the ims_cp_resources table
    # We need to create a new row in the ims_cp_files to associate the new resource to the new file
    db_dml insert_new_file {
	insert into ims_cp_files (file_id, res_id, pathtofile, filename, hasmetadata)
	values (:new_file_id, :res_id, :new_href, :title, 'f')
    }
    return $new_file_id
}


ad_proc -public lors_central::res_update_items {
    -old_res_id
    -new_res_id
    {-user_id ""}
} {
    When a resource gets a new revision update associated items
} {
    db_transaction {
	# we need to create new versions of each ims_cp_item that is mapped to this resource
	foreach ims_item_id [db_list get_ims_items "select ims_item_id from ims_cp_items_to_resources where res_id=:old_res_id"] {
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
	    set parent_item [db_string get_parent_item { }]
	    db_dml update_ims_cp_items {
		update ims_cp_items
		set
		org_id = :org_id,
		identifier = :item_name,
		identifierref = :item_title,
		item_title = :item_title,
		parent_item = :parent_item
		where ims_item_id = :new_ims_rev_id

	    }
	    # Now this new revision_id is the one that holds the content of the new resource
	    # We have to make a row in ims_cp_items_to_resources table
	    db_dml insert_new_item_to_res {
		insert into ims_cp_items_to_resources (ims_item_id, res_id )
		values (:new_ims_rev_id, :new_res_id)
	    }
	    # We are going to set the sort_order field
	    lors_central::set_sort_order -ims_item_id $new_ims_rev_id
	}
    }   

}

ad_proc -private lors_central::do_notification {
    -object_id:required
} {
    Send a notification to all users subscribed to @object_id@
    @object_id@   The object_id that holds the notification
} {
    notification::new \
	-type_id [notification::type::get_type_id -short_name "one_lo_notif" ] \
	-object_id $object_id \
	-notif_subject "Changes made to this resource" \
	-notif_text "Some changes have been made to one resource" \
}

ad_proc -public lors_central::get_folder_id {
    -name:required
} {
    return [db_string get_root_folder { }]
}

ad_proc -public lors_central::get_items_indent {
   -org_id:required
} {
    Returns a list of the form \{ims_item_id indent\} from one org_id
} {

    # We need all the count of all items (just live revisions)
    set items_count [db_string get_items_count { }]

    # Get the root items
    set count 0
    db_foreach get_root_items { } {
        lappend items_list [list $ims_item_id 1]
        set items_array($ims_item_id) 1
        incr count
    }


    while { $count < $items_count } {
        foreach item $items_list {
            set item_id [lindex $item 0]
            set indent [expr [lindex $item 1] + 1]
            db_foreach get_items { } {
                if { ![info exists items_array($ims_item_id)] } {
                    lappend items_list [list $ims_item_id $indent]
                    set items_array($ims_item_id) $indent
                    incr count
                }
            }
        }
    }
    return $items_list
}

ad_proc -public lors_central::get_root_folder_id { } { } {
    return [db_string get_root_folder { }]
}
