ad_page_contract {
    Display a list of dotlrn classes where the course is in use
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
   man_id:integer,optional
}

# Checking swa privilege over lors-central
lors_central::is_swa

set title "[_ lors-central.Classes_using]"
set context [list [list "one-course-associations?man_id=$man_id" [_ lors-central.one_course_assoc]] \
                  [_ lors-central.Classes_using]]

# Get the item_id of man_id
set item_id [lors_central::get_item_id -revision_id $man_id]

db_multirow -extend { ver_num  ver_count manifest_id options } cl_list get_dotlrn_classes { } {
    set manifest_id [lors_central::get_man_id -community_id $com_id -item_id $item_id]
    set ver_count [lors_central::count_versions -man_id $manifest_id]
    set ver_num [lors_central::get_version_num -revision_id $manifest_id]
    # Create the options for the select menu
    set options ""
    for { set i 1 } { $i < [expr $ver_count + 1] } { incr i } {
	if { [string equal $i $ver_num] } {
            append options "<option value=$i selected>$i</options>"
	} else {
            append options "<option value=$i>$i</options>"
	}
    }
}


template::list::create \
    -name dotlrn_classes \
    -multirow cl_list \
    -key com_id \
    -has_checkboxes \
    -row_pretty_plural "[_ lors-central.dotlrn_classes]" \
    -elements {
	class  {
	    label "[_ lors-central.class_name]"
	    display_template {
		@cl_list.pretty_name@
	    }
	}
	subject  {
	    label "[_ lors-central.subject_name]"
	    display_template {
		    @cl_list.class_name@
	    }
	}
	term_name  {
	    label "[_ lors-central.term_name]"
	    display_template {
		    @cl_list.term_name@
	    }
	}
	current  {
	    label "[_ lors-central.current]"
	    display_template {
		@cl_list.ver_num@ [_ lors-central.of] @cl_list.ver_count@
	    }
	}
    }

