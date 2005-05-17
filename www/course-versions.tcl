ad_page_contract {
   author Miguel Marin (miguelmarin@viaro.net)
   author Viaro Networks www.viaro.net
} {
    man_id:integer,optional
    item_id:integer,optional
    {index_p 0}
}

set user_id [ad_conn user_id]

# Checking swa privilege over lors-central
lors_central::is_swa


if { ![info exist item_id ] } {
    set item_id [lors_central::get_item_id -revision_id $man_id]
    set context [list [list "one-course?man_id=$man_id" \
                      [_ lors-central.one_course]] [_ lorsm.lt_one_course_versions]]
} else {
    if { $index_p } {
	set context [list [_ lorsm.lt_one_course_versions]]
    } else {
    set context [list [list "one-course?item_id=$item_id" [_ lors-central.one_course]] \
                      [_ lorsm.lt_one_course_versions]]
    }
}

################################################
# Check for admin permissions over the course

if { ![acs_user::site_wide_admin_p -user_id $user_id ]} {
    set permission_p [db_string check_permission "select 1 from acs_permissions where object_id = :item_id
                            and grantee_id = :user_id and privilege = 'admin'" -default 0]
} else {
   set permission_p 1
}

set last_version [db_string get_live_revision "select live_revision from cr_items where item_id = :item_id"]

db_multirow -extend { ver_num } course_versions get_versions { } {
    set ver_num [lors_central::get_version_num -revision_id $man_id]
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
              <center><b>@course_versions.ver_num@</b></center>
	    }
	}
	course_name {
            label "[_ lors-central.course_name]"
            display_template {
                <a href="one-course?man_id=@course_versions.man_id@">@course_versions.course_name@</a>
	    }
	} 
	man_id {
            label "[_ lors-central.man_id]"
            display_template {
                @course_versions.man_id@
	    }
	} 
	latest_version {
            display_template {
                <if $last_version eq @course_versions.man_id@>
                  <img border=0 src="images/live.gif">
                </if>
                <else>
                  <a href="course-version-change?man_id=@course_versions.man_id@"></a>
                  <!-- img border=0 src="images/golive.gif" -->
                </else>
	    }
	} 
    }



