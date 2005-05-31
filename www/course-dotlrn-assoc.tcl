ad_page_contract {
   @author Miguel Marin (migeulmarin@viaro.net)
   @author Viaro Networks www.viaro.net
  
   This page associate this course to one class or community of dotlrn
} {
    man_id:integer,optional
    item_id:integer,optional
}

# Checking privilege over lors-central
lors_central::check_permissions

set title [_ lors-central.associate_to]

# Get the item_id that the manifest_id has associated
if { ![info exist item_id] } {
    set item_id [lors_central::get_item_id -revision_id $man_id]
    set context [list [list "one-course-associations?man_id=$man_id" [_ lors-central.one_course_assoc]] \
                      [_ lors-central.associate_to]]
} else {
    set context [list [list "one-course-associations?item_id=$item_id" [_ lors-central.one_course_assoc]] \
                      [_ lors-central.associate_to]]
}

set user_id [ad_conn user_id]


##################################### TO ASSOCIATE ##########################################################

db_multirow -extend { rel type } classes_list get_dotlrn_classes { } {
    set rel [lors_central::relation_between -item_id $item_id -community_id $com_id]
    set type dotlrn_class_instance
}

template::list::create \
    -name dotlrn_classes \
    -multirow classes_list \
    -key community_id \
    -has_checkboxes\
    -bulk_actions {
                   "\#lors-central.associate\#" "course-associate" "\#lors-central.associate_to_class\#" \
    } \
    -bulk_action_method post \
    -bulk_action_export_vars {
	item_id
        type
    }\
    -row_pretty_plural "[_ lors-central.dotlrn_classes]" \
    -elements {
	check_box {
	    class "list-narrow"
	    label "<input type=\"checkbox\" name=\"_dummy\" onclick=\"acs_ListCheckAll('dotlrn_classes', this.checked)\" \
                   title=\"\#lors-central.label_title\#\">"
	    display_template {
		    <input type="checkbox" name="object_id" value="@classes_list.com_id@" \
		    id="dotlrn_classes,@classes_list.com_id@" \
		    title="\#lors-central.title\#">
	    }
	}
	class  {
	    label "[_ lors-central.class_name]"
	    display_template {
		<a href="@classes_list.url@">@classes_list.pretty_name@</a> 
	    }
	}
	dep_name {
	    label "[_ lors-central.dep_name]"
	    display_template {
		@classes_list.department_name@
	    }
	}
	term_name  {
	    label "[_ lors-central.term_name]"
	    display_template {
		    @classes_list.term_name@
	    }
	}
	subject  {
	    label "[_ lors-central.subject_name]"
	    display_template {
		    @classes_list.class_name@
	    }
	}
	associate {
	    display_template {
		<if @classes_list.rel@ not eq 0>
		    #lors-central.associated#
		</if>
	    }
	}
    }


############################## TO DROP ASSOCIATION ######################################

db_multirow -extend { rel } drop_classes_list get_dotlrn_classes_drop { } {
    set rel [lors_central::relation_between -item_id $item_id -community_id $com_id]
}

template::list::create \
    -name drop_dotlrn_classes \
    -multirow drop_classes_list \
    -key community_id \
    -has_checkboxes\
    -bulk_actions {
                   "\#lors-central.drop\#" "course-association-drop" "\#lors-central.drop_association\#" \
    } \
    -bulk_action_method post \
    -bulk_action_export_vars {
	item_id
    }\
    -row_pretty_plural "[_ lors-central.dotlrn_classes]" \
    -elements {
	check_box {
	 class "list-narrow"
	 label "<input type=\"checkbox\" name=\"_dummy\" onclick=\"acs_ListCheckAll('drop_dotlrn_classes', this.checked)\" \
                   title=\"\#lors-central.label_title\#\">"
	    display_template {
		    <input type="checkbox" name="object_id" value="@drop_classes_list.com_id@" \
		    id="drop_dotlrn_classes,@drop_classes_list.com_id@" \
		    title="\#lors-central.title\#">
	    }
	}
	class  {
	    label "[_ lors-central.class_name]"
	    display_template {
		<a href="@drop_classes_list.url@">@drop_classes_list.pretty_name@</a> 
	    }
	}
	dep_name {
	    label "[_ lors-central.dep_name]"
	    display_template {
		@drop_classes_list.department_name@
	    }
	}
	term_name  {
	    label "[_ lors-central.term_name]"
	    display_template {
		    @drop_classes_list.term_name@
	    }
	}
	subject  {
	    label "[_ lors-central.subject_name]"
	    display_template {
		    @drop_classes_list.class_name@
	    }
	}
	associate {
	    display_template {
		<if @drop_classes_list.rel@ not eq 0>
		    #lors-central.associated#
		</if>
	    }
	}
    }


##################################### COMMUNITIES ###########################################################
##################################### TO ASSOCIATE ##########################################################

db_multirow -extend { rel type } coms_list get_dotlrn_coms { } {
    set rel [lors_central::relation_between -item_id $item_id -community_id $com_id]
    set type dotlrn_club
}

template::list::create \
    -name coms_list \
    -multirow coms_list \
    -key community_id \
    -has_checkboxes\
    -bulk_actions {
                   "\#lors-central.associate\#" "course-associate" "\#lors-central.associate_to_class\#" \
    } \
    -bulk_action_method post \
    -bulk_action_export_vars {
	item_id
        type
    }\
    -row_pretty_plural "[_ lors-central.dotlrn_communities]" \
    -elements {
	check_box {
	    class "list-narrow"
	    label "<input type=\"checkbox\" name=\"_dummy\" onclick=\"acs_ListCheckAll('coms_list', this.checked)\" \
                   title=\"\#lors-central.label_title\#\">"
	    display_template {
		    <input type="checkbox" name="object_id" value="@coms_list.com_id@" \
		    id="coms_list,@coms_list.com_id@" \
		    title="\#lors-central.title\#">
	    }
	}
	class  {
	    label "[_ lors-central.community_name]"
	    display_template {
		<a href="@coms_list.url@">@coms_list.pretty_name@</a> 
	    }
	}
	associate {
	    display_template {
		<if @coms_list.rel@ not eq 0>
		    #lors-central.associated#
		</if>
	    }
	}
    }


############################## TO DROP ASSOCIATION ######################################

db_multirow -extend { rel type } coms_list_drop get_dotlrn_coms_drop { } {
    set rel [lors_central::relation_between -item_id $item_id -community_id $com_id]
}

template::list::create \
    -name coms_list_drop \
    -multirow coms_list_drop \
    -key community_id \
    -has_checkboxes\
    -bulk_actions {
                   "\#lors-central.drop\#" "course-association-drop" "\#lors-central.drop_association\#" \
    } \
    -bulk_action_method post \
    -bulk_action_export_vars {
	item_id
        type
    }\
    -row_pretty_plural "[_ lors-central.dotlrn_classes]" \
    -elements {
	check_box {
	    class "list-narrow"
	    label "<input type=\"checkbox\" name=\"_dummy\" onclick=\"acs_ListCheckAll('coms_list_drop', this.checked)\" \
                   title=\"\#lors-central.label_title\#\">"
	    display_template {
		    <input type="checkbox" name="object_id" value="@coms_list_drop.com_id@" \
		    id="coms_list_drop,@coms_list_drop.com_id@" \
		    title="\#lors-central.title\#">
	    }
	}
	class  {
	    label "[_ lors-central.community_name]"
	    display_template {
		<a href="@coms_list_drop.url@">@coms_list_drop.pretty_name@</a> 
	    }
	}
	associate {
	    display_template {
		<if @coms_list_drop.rel@ not eq 0>
		    #lors-central.associated#
		</if>
	    }
	}
    }
