# lors-central specific clipboard
if {![info exists displayed_object_id]} {
    set displayed_object_id ""
}

# The type var indicates if the items we want to show are files
# or resources
if { ![empty_string_p $type] } {
    if { [string equal $type "file"] } {
	set extra_query "and t.pretty_name = 'Basic Item'" 
	template::list::create \
	    -name file_items \
	    -multirow items \
	    -key object_id \
	    -bulk_actions {
		"\#lors-central.add_to_resource\#" new-clipboard-files "\#lors-central.add_to_resource\#"
	    } \
	    -bulk_action_method post \
	    -bulk_action_export_vars {
		man_id
		ims_item_id
		name
	    } \
	    -row_pretty_plural "\#lors-central.clip_files\#" \
	    -elements {
		object_id {
		    label "\#lors-central.item_files\#:"
		    display_template {
			<a href="/o/@items.object_id@">@items.item_title@</a>
		    }
		}
		object_name {
		    label "\#lors-central.filename\#:"
		    display_template {
			@items.object_name@
		    }
		}
		object_type {
		    label "\#lors-central.type\#:"
		    display_template {
			@items.object_type@
		    }
		}
		mime_type {
		    label "\#lors-central.mime_type\#:"
		    display_template {
			<i>@items.pretty_mime_type@</i>
		    }
		}
		clipped {
		    label "\#lors-central.clipped\#:"
		    display_template {
			@items.clipped@ 			
		    }
		}
	    }
	
    } else {
	set extra_query "and t.pretty_name = 'IMS Resource Object'" 
    }
} else {
    set extra_query ""
}

set user_id [ad_conn user_id]
set lors_central_package_id [ad_conn package_id]

# find if there is a lors-central clipboard
set clipboard_id [db_string get_cb_id { } -default ""]
if { [empty_string_p $clipboard_id] } {
    # Create the clipboard_id 
    set clipboard_id [clipboard::new -owner_id $user_id -title "Lors Central" \
			  -package_id $lors_central_package_id -creation_user_id $user_id]

}
clipboard::clipboards $user_id clipboards
clipboard::clipped $displayed_object_id $user_id this_item_clipped


# TODO: Yuck! should fix this query.  maybe stick it in an object_type view which restricts to clipable things.
db_multirow -extend {clipped object_name} items get_items { } {
    set clipped [util::age_pretty -timestamp_ansi $clipped_ansi -sysdate_ansi [clock_to_ansi [clock seconds]]]
    set object_name [db_string get_object_name { } -default ""]
}

set url "/"

ad_return_template