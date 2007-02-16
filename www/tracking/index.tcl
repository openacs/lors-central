# packages/lorsm/www/tracking/index.tcl

ad_page_contract {
    
    Student Tracking Index Page
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-25
    @arch-tag a5b230ee-0fa7-4e48-be1b-eeae323291e7
    @cvs-id $Id$
} {
    man_id:integer,notnull
    { lorsm_instance_id "" }
    { community_id "" }
    {item_id 0}
    group:optional
} -properties {
} -validate {
} -errors {
}

# set package_id [ad_conn package_id]
# set community_id [dotlrn_community::get_community_id]

if { ![empty_string_p $lorsm_instance_id] } {
    set package_id $lorsm_instance_id
}
if { ![empty_string_p $community_id] } {
    set community_id $community_id
}

# set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id [ad_conn user_id]  \
		 -community_id $community_id ]

# Permissions
# dotlrn::require_user_admin_community -user_id [ad_conn user_id] -community_id $community_id

set title "[_ lorsm.Student_Tracking]"
set context [list "[_ lorsm.Tracking_1]"]

if {![exists_and_not_null group]} {
    set group 1
}

if {$group == 1} {

    template::list::create \
	-name student_track \
	-multirow student_track \
	-actions [list "[_ lorsm.Summarize]" [export_vars -base ".?group=0" {man_id item_id lorsm_instance_id community_id}] "[_ lorsm.lt_Summarize_all_student]"] \
	-key man_id \
	-html {width 50%} \
	-no_data "[_ lorsm.No_Students]" \
	-elements {
	    student_name {
		label "[_ lorsm.Student_Name]"
		display_eval {[person::name -person_id $student_name]}
		link_url_eval {[acs_community_member_url -user_id $student_name]}
		link_html {title "[_ lorsm.Students_profile]"}
	    }
	    start_time {
		label "[_ lorsm.Start_Course]"
		display_eval {[lc_time_fmt $start_time "%x %T"]}
		html { align center }
	    }
	    end_time {
		label "[_ lorsm.Exit_Course]"
		display_eval {[lc_time_fmt $end_time "%x %T"]}
		html { align center }
	    }
	    time_spend {
		label "[_ lorsm.Time_Spent]"
		display_eval {[lorsm::dates_calc -start_date [string range $start_time 0 18] -end_date [string range $end_time 0 18]]}
		html { align center }
	    }
	}

    db_multirow -extend { ims_md_id } student_track select_students {
	select 
	user_id as student_name,
	start_time,
	end_time
	from
	lorsm_student_track
	where 
	community_id = :community_id
	and
	course_id    = :man_id
        and
           end_time NOTNULL
	order by  
	start_time desc
    } {
	set ims_md_id $man_id
    }
    
    template::list::create \
        -name object_views \
        -multirow object_views \
        -elements {
            title {
                label "[_ lorsm.Title_1]"
            }
            viewer_name {
                label "[_ lorsm.Viewed_By]"
            }
            views {
                label "[_ lorsm.Total_Views]"
            }
            last_viewed {
                label "[_ lorsm.Last_Viewed_On]"
	        display_eval {[lc_time_fmt $last_viewed "%x %X"]}
            }
        }

    if {$item_id} {
	set extra_where " and v.object_id in ( select revision_id from cr_revisions where item_id = (
                                               select item_id from cr_revisions where revision_id = :item_id))"
    } else {
	set extra_where ""
    }

    db_multirow -extend {viewer_name} object_views objects_views "
        select v.*,
               i.item_title as title
        from views v,
             ims_cp_items i,
             ims_cp_organizations o
        where
             i.ims_item_id = v.object_id
        and
             i.org_id = o.org_id
	and
             o.man_id = :man_id
        $extra_where
    " {
        set viewer_name [acs_user::get_element -user_id $viewer_id -element name]
    }

} else {
    # group display

    template::list::create \
	-name student_track \
	-multirow student_track \
	-key man_id \
	-actions [list "[_ lorsm.Expand]" [export_vars -base ".?group=1" {man_id item_id lorsm_instance_id community_id}] "Expand all students"] \
	-html {width 50%} \
	-no_data "[_ lorsm.No_Students]" \
	-elements {
	    student_name {
		label "Student Name"
		display_eval {[person::name -person_id $student_name]}
		link_url_eval {[acs_community_member_url -user_id $student_name]}
		link_html {title "Student's profile"}
	    }
	    counter {
		label "[_ lorsm.Times_Viewed]"
		html { align center }
	    }
	    time_spent {
		label "[_ lorsm.Time_Spent]"
		html { align center }
	    }
	}

    db_multirow -extend { ims_md_id } student_track select_students {
	select 
	user_id as student_name,
	count(*) as counter,
	sum(end_time - start_time) as time_spent
	from
	lorsm_student_track
	where 
	community_id = :community_id
	and
	   course_id    = :man_id
	and 
	   end_time  NOTNULL
	group by user_id

    } {
	set ims_md_id $man_id
    }

    template::list::create \
        -name object_views \
        -multirow object_views \
        -elements {
            title {
                label "[_ lorsm.Title_1]"
            }
            views {
                label "[_ lorsm.Total_Views]"
            }
            unique_views {
                label "[_ lorsm.Unique_Views]"
            }
            last_viewed {
                label "[_ lorsm.Last_Viewed_On]"
            }
        }
    
    if {$item_id} {
	set extra_where " and v.object_id = :item_id"
    } else {
	set extra_where ""
    }

    db_multirow object_views objects_views "
        select v.*,
               i.item_title as title
        from view_aggregates v,
             ims_cp_items i,
             ims_cp_organizations o
        where
             i.ims_item_id = v.object_id
        and
             i.org_id = o.org_id
	and
             o.man_id = :man_id
        $extra_where
    "

}
