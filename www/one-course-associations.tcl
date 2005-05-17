ad_page_contract {
    Displays all the information about one course (man_id)
    
    @author         Miguel Marin (miguelmarin@viaro.net)
    @author         Viaro Networks www.viaro.net
    @creation-date  2005-03-17
} {
    man_id:integer,optional
    item_id:integer,optional
    {orderby "class,asc"}
}




# Get the item_id that the manifest_id has associated
if { ![info exist item_id] } {
    set item_id [lors_central::get_item_id -revision_id $man_id]
}

set title "[_ lors-central.one_course_assoc]"
set context "[list [list "one-course?item_id=$item_id" [_ lors-central.one_course]] [_ lors-central.one_course_assoc]]"

###############################      Versions Template      #################################################

set last_version [db_string get_live_revision "select live_revision from cr_items where item_id = :item_id"]
db_multirow -extend { assoc_count ver_num date author live_classes } course_versions get_versions { } {
    set ver_num [lors_central::get_version_num -revision_id $man_id]
    set date [lindex $last_modified 0]
    append date " [lindex [split [lindex $last_modified 1] "."] 0]"
    set author [lors_central::get_username -user_id $user_id]
    set live_classes [lors_central::get_live_classes -man_id $man_id]
    set assoc_count [db_string get_assoc_count { } -default 0]
}

template::list::create \
    -name course_versions \
    -multirow course_versions \
    -key course_name \
    -bulk_action_method post \
    -has_checkboxes \
    -bulk_action_export_vars {
    } \
    -row_pretty_plural "[_ lors-central.course_versions]" \
    -elements {
        version_number {
	    label "[_ lors-central.version_number]"
            display_template {
            <if $last_version eq @course_versions.man_id@>
              <center><b>@course_versions.ver_num@</b></center>
            </if>
            <else>
              <center>@course_versions.ver_num@</center> 
            </else>
	    }
	}
	course_name {
            label "[_ lors-central.course_name]"
            display_template {
            <if $last_version eq @course_versions.man_id@>
                <b>@course_versions.course_name@</b>
            </if>
            <else>
                   @course_versions.course_name@
            </else>
	    }
	} 
        author {
            label "[_ lors-central.author]"	    
            display_template {
                <a href="/shared/community-member?user_id=@course_versions.user_id@">@course_versions.author@</a>
	    }	    
	}
        last_modified {
            label "[_ lors-central.last_modified]"	    
            display_template {
                @course_versions.date@
	    }	    
	}
        live_classes {
            label "[_ lors-central.live_classes]"	    
            display_template {
		<if @course_versions.live_classes@ gt 0>
                      <center>   
                      <a href="course-live-in?man_id=@course_versions.man_id@">@course_versions.live_classes@</a>
                      </center>
                </if>
                <else>
                      <center>@course_versions.live_classes@</center>
                </else>
	    }	    
	}
	make_live {
            display_template {
		<if @course_versions.assoc_count@ gt 0>
		    <a href="course-version-change?man_id=@course_versions.man_id@">[_ lors-central.make_live]</a>
		</if>
	    }
	} 
    }

###################################      Associations Template      #################################################

template::list::create \
    -name dotlrn_classes \
    -multirow cl_list \
    -key com_id \
    -has_checkboxes \
    -bulk_actions { #lors-central.update_versions# "change-one-version" #lors-central.update_course_ver# }\
    -bulk_action_method post \
    -bulk_action_export_vars {
        item_id 
    } \
    -row_pretty_plural "[_ lors-central.dotlrn_classes]" \
    -elements {
	class  {
	    label "[_ lors-central.class_name]"
	    display_template {
		@cl_list.pretty_name@&nbsp;&nbsp;
                <a href="one-course-views?man_id=@cl_list.manifest_id@&community_id=@cl_list.com_id@">
                [_ lors-central.views]
                </a> 
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
	set_to  {
	    label "[_ lors-central.set_to]"
	    display_template {
                <input type=hidden name="objects_id" value=@cl_list.com_id@>
                <input type=hidden name="objects_count" value=@cl_list.ver_count@>
                <select name="objects_value">
  		    @cl_list.options;noquote@
                </select>
	    }
	}
	tracking  {
	    label "[_ lors-central.tracking]"
	    display_template {
                <center>
		<a href="tracker?man_id=@cl_list.manifest_id@&community_id=@cl_list.com_id@">
                <if @cl_list.tracking@>
		[_ lors-central.enabled]
                </if>
                <else>
		[_ lors-central.disabled]
                </else>
                </a>
                </center>
	    }
	}
    } -filters { 
	man_id {} 
    } -orderby { 
	class  {
	    orderby_asc {pretty_name asc}
            orderby_desc {pretty_name desc}
	}
	subject  {
	    orderby_asc {class_name asc}
            orderby_desc {class_name desc}
	}
	term_name  {
	    orderby_asc {term_name asc}
            orderby_desc {term_name desc}
	}

    }
    
set orderby_clause [template::list::orderby_clause -orderby -name "dotlrn_classes"]

db_multirow -extend { ver_num  ver_count manifest_id options tracking } cl_list get_dotlrn_classes { } {
    set manifest_id [lors_central::get_man_id -community_id $com_id -item_id $item_id]
    set ver_count [lors_central::count_versions -man_id $manifest_id]
    set ver_num [lors_central::get_version_num -revision_id $manifest_id]
    set tracking [db_string get_tracking { }]
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


