ad_page_contract {
    @author         Miguel Marin (miguelmarin@viaro.net)
    @author         Viaro Networks www.viaro.net
} {
    man_id:integer,optional
    community_id:integer,notnull
}

# Checking privilege over lors-central
lors_central::check_permissions

# Get the item_id that the manifest_id has associated
if { ![info exists item_id] } {
    set item_id [lors_central::get_item_id -revision_id $man_id]
}

set title "[_ lors-central.one_course_views]"
set context "[list [list "one-course-associations?man_id=$man_id" [_ lors-central.one_course_assoc]] [_ lors-central.one_course_views]]"

###############################      Versions Template      #################################################

set last_version [db_string get_live_revision "select live_revision from cr_items where item_id = :item_id"]
db_multirow -extend { ver_num date author live_classes } course_versions get_versions { } {
    set ver_num [lors_central::get_version_num -revision_id $man_id]
    set date [lindex $last_modified 0]
    append date " [lindex [split [lindex $last_modified 1] "."] 0]"
    set author [lors_central::get_username -user_id $user_id]
    set live_classes [lors_central::get_live_classes -man_id $man_id]
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
		<center>   
		@course_versions.live_classes@
		</center>
	    }	    
	}
        views {
            label "[_ lors-central.views_in]"
            display_template {
		<center>
		<a href="tracking/?man_id=@course_versions.man_id@&commmunity_id=$community_id">
		[_ lors-central.views]
		</a>
                </center>
	    }
	}
    }

