ad_page_contract {
    User Interafe to show all files that one course has
    @author Miguel Marin (migulmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    folder_id:integer,optional
}

# Checking privilege over lors-central
lors_central::check_permissions

if { ![info exists folder_id] } {
    # Get lorsm root folder_id
    set folder_id [lors_central::get_root_folder_id]
} else {
    # Get parent folder_id and label
    db_1row get_parent_id_label {select name, parent_id from cr_items where content_type = 'content_folder'
                                            and item_id = :folder_id
    }
    set back_button "<a class=button href=\"?folder_id=$parent_id\">Back to $name</a>"
    if { [string equal $parent_id "-100"] } {
        set parent_root_p 0
    } else {
        set parent_root_p 1
    }
}


template::list::create \
    -name folder_elements \
    -multirow get_elements \
    -bulk_action_method post \
    -bulk_action_export_vars { } \
    -row_pretty_plural "elements to show" \
    -elements {
        name {
            label "Name"
            display_template {
		<if @get_elements.is_folder@>
                    <a href="?folder_id=@get_elements.item_id@"><img border=0 src="images/folder.gif"></a>
                    &nbsp;&nbsp;@get_elements.name@
                </if>
                <else>
                    <a href="download?file_id=@get_elements.item_id@"><img border=0 src="images/file.gif"></a>
                    &nbsp;&nbsp;@get_elements.name@
                </else>

	    }
	}
        size {
            label "Size"
	    display_template {
                <if @get_elements.is_folder@>
		    @get_elements.size@ items
                </if>
                <else>
                    @get_elements.length@
                </else>
	    }
	} 
        type {
            label "Type" 
	    display_template {
                <if @get_elements.is_folder@>
		    Folder 
                </if>
                <else>
                    @get_elements.mime_type@
                </else>
	    }  
	}
        last_modified {
            label "Last Modified" 
	    display_template {
                    @get_elements.last_modified@
	    }  
	}
    }

db_multirow -extend  { is_folder size mime_type last_modified length }  get_elements get_folder_elements {
    select * from cr_items where parent_id = :folder_id
} {
    set is_folder [db_string is_folder { select 1 from cr_folders where folder_id = :item_id } -default "0"]
    set size [db_string get_size { select count(item_id) from cr_items where parent_id = :item_id } -default "0"]
    db_0or1row get_extra_information { select content_length as length, mime_type, publish_date as last_modified 
                                       from cr_revisions where revision_id = :live_revision }

    set last_modified_ansi [lc_time_system_to_conn $last_modified]

    set last_modified [lc_time_fmt $last_modified_ansi "%x %X"]

    if { ![string equal $is_folder 1]} {
        if {$length < 1024} {
            set length "[lc_numeric $length ] bytes"
        } else {
            set length "[lc_numeric [expr $length / 1024 ]] Kb"
        }

    }

}
