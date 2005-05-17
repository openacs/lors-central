ad_library {

    Tcl API for lors-central content export 

    @author Miguel Marin (miguelmarin@viaro.net) 
    @author Viaro Networks www.viaro.net
}

namespace eval lors_central::export {}

ad_proc -private lors_central::export::get_items_xml {
    -org_id:required
} {
    
} {
    set items_count [db_string get_items_count { }]
    set items_list [list]
    set control_list [list]
    db_foreach get_parent_items { } {
	lappend items_list "$ims_item_id 1"
	lappend control_list $ims_item_id
    }
    set i 0
    while { $i < $items_count } {
	set i 0
	set aux_list $items_list
	foreach item $aux_list {
	    incr i
	    set parent_item [lindex $item 0]
	    set parent_level [lindex $item 1]
	    db_foreach get_items { } {
		if { [string equal [lsearch $control_list $ims_item_id] "-1"] } {
		    set items_list [linsert $items_list $i "$ims_item_id [expr $parent_level + 1]"]
		    lappend control_list $ims_item_id
		    incr i
		}
	    }
	}
    }
    return "$items_list"
}


ad_proc -private lors_central::export::publish_object_to_file_system {
    -object_id:required
    {-path ""}
    {-user_id ""}
    {-file_name ""}
} {
    if {[empty_string_p $path]} {
	set path [ns_tmpnam]
   }
    db_1row select_object_info {             
	select fs_objects.*
	from fs_objects
	where fs_objects.object_id = :object_id 
    }
 
    # We get rid of spaces since they are annoying
    regsub -all { } $name {_} name

    if {[string equal folder $type]} {
	set result [lors_central::export::publish_folder_to_file_system -folder_id $object_id -path $path -folder_name $name -user_id $user_id]
    } elseif {[string equal url $type]} {
	set result [lors_central::export::publish_url_to_file_system -object_id $object_id -path $path -file_name $file_name]
    } else {
	set result [lors_central::export::publish_versioned_object_to_file_system -object_id $object_id -path $path -file_name $file_name]
    }
    
    return $result
}

ad_proc -public lors_central::export::publish_folder_to_file_system {
    {-folder_id:required}
    {-path ""}
    {-folder_name ""}
    {-user_id ""}
} {
    publish the contents of a file storage folder to the file system
} {
    if {[empty_string_p $path]} {
	set path [ns_tmpnam]
    }

    if {[empty_string_p $folder_name]} {
	set folder_name [get_object_name -object_id $folder_id]
    }
    set folder_name [remove_special_file_system_characters -string $folder_name]

    set dir [file join ${path} ${folder_name}]
    file mkdir $dir

    foreach object [get_folder_contents -folder_id $folder_id -user_id $user_id] {
	lors_central::export::publish_object_to_file_system \
	    -object_id [ns_set get $object object_id] \
	    -path $dir \
	    -file_name [remove_special_file_system_characters -string [ns_set get $object name]] \
	    -user_id $user_id
    }

    return $dir
}

ad_proc -public lors_central::export::publish_url_to_file_system {
    {-object_id:required}
    {-path ""}
    {-file_name ""}
} {
    publish a url object to the file system as a Windows shortcut
    (which at least KDE also knows how to handle)
} {
    if {[empty_string_p $path]} {
	set path [ns_tmpnam]
	file mkdir $path
    }

    db_1row select_object_metadata {}

    if {[empty_string_p $file_name]} {
	set file_name $label
    }
    set file_name "${file_name}.url"
    set file_name [remove_special_file_system_characters -string $file_name]

    set fp [open [file join ${path} ${file_name}] w]
    puts $fp {[InternetShortcut]}
    puts $fp URL=$url
    close $fp

    return [file join ${path} ${file_name}]
}

ad_proc -public lors_central::export::publish_versioned_object_to_file_system {
    {-object_id:required}
    {-path ""}
    {-file_name ""}
} {
    publish an object to the file system
} {
    if {[empty_string_p $path]} {
	set path [ns_tmpnam]
	file mkdir $path
    }

    db_1row select_object_metadata {}

    if {[empty_string_p $file_name]} {
        if {![info exists upload_file_name]} {
		set file_name "unnamedfile"
    	} else {
	set file_name $file_upload_name
	}
    }
    set file_name [remove_special_file_system_characters -string $file_name]

    switch $storage_type {
	lob {

	    # FIXME: db_blob_get_file is failing when i use bind variables

	    # DRB: you're out of luck - the driver doesn't support them and while it should
	    # be fixed it will be a long time before we'll want to require an updated
	    # driver.  I'm substituting the Tcl variable value directly in the query due to
	    # this.  It's safe because we've pulled the value ourselves from the database,
	    # don't need to worry about SQL smuggling etc.

	    db_blob_get_file select_object_content {} -file [file join ${path} ${file_name}]
	}
	text {
	    set content [db_string select_object_content {}]

	    set fp [open [file join ${path} ${file_name}] w]
	    puts $fp $content
	    close $fp
	}
	file {
	    set cr_path [cr_fs_path $storage_area_key]
	    set cr_file_name [db_string select_file_name {}]

	    file copy -- "${cr_path}${cr_file_name}" [file join ${path} ${file_name}]
	}
    }

    return [file join ${path} ${file_name}]
}

ad_proc -public lors_central::export::remove_special_file_system_characters {
    {-string:required}
} {
    remove unsafe file system characters. useful if you want to use $string
    as the name of an object to write to disk.
} {
    regsub -all {[<>:\"|/@\#%&+\\]} $string {_} string
    return [string trim $string]
}

ad_proc -public lors_central::export::get_folder_contents {
    {-folder_id ""}
    {-user_id ""}
    {-n_past_days "99999"}
} {
    Retrieve the contents of the specified folder in the form of a list
    of ns_sets, one for each row returned. The keys for each row are as
    follows:

    object_id, name, live_revision, type,
    last_modified, new_p, content_size, file_upload_name
    write_p, delete_p, admin_p, 

    @param folder_id The folder for which to retrieve contents
    @param user_id The viewer of the contents (to make sure they have
					       permission)
    @param n_past_days Mark files that are newer than the past N days as new
} {
    if {[empty_string_p $folder_id]} {
	set folder_id [get_root_folder -package_id [ad_conn package_id]]
    }

    if {[empty_string_p $user_id]} {
	set user_id [acs_magic_object the_public]
    }

    set list_of_ns_sets [db_list_of_ns_sets select_folder_contents {}]

    foreach set $list_of_ns_sets {
	# in plain Tcl:
	# set last_modified_ansi [lc_time_system_to_conn $last_modified_ansi]
	ns_set put $set last_modified_ansi [lc_time_system_to_conn [ns_set get $set last_modifed_ansi]] 

	# in plain Tcl:
	# set last_modified [lc_time_fmt $last_modified_ansi "%x %X"]
	ns_set put $set last_modified [lc_time_fmt [ns_set get $set last_modified_ansi] "%x %X"]

	# set content_size_pretty [lc_numeric $content_size]
	ns_set put $set content_size_pretty [lc_numeric [ns_set get $set content_size]]
    }

    return $list_of_ns_sets
}

ad_proc -public lors_central::export::get_folder_contents_count {
    {-folder_id ""}
    {-user_id ""}
} {
    Retrieve the count of contents of the specified folder.

    @param folder_id The folder for which to retrieve contents
    @param user_id The viewer of the contents (to make sure they have
					       permission)
} {
    if {[empty_string_p $folder_id]} {
	set folder_id [get_root_folder -package_id [ad_conn package_id]]
    }

    if {[empty_string_p $user_id]} {
	set user_id [acs_magic_object the_public]
    }

    return [db_string select_folder_contents_count {}]
}
