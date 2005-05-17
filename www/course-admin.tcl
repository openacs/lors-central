# packages/lors-central/www/index.tcl

ad_page_contract {
    Learning Object Repository Management Index page

} {
   man_id:integer,notnull
}

# Checking swa privilege over lors-central
lors_central::is_swa


set title "[_ lorsm.lt_Manage_Courses_in_Rep]"
set context [list "[_ lorsm.Manage_Courses]"]


set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
# set community_id [dotlrn_community::get_community_id]


# set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id [ad_conn user_id]  \
		 -community_id $community_id ]

# set admin_p [dotlrn::user_can_admin_community_p  \
		 -user_id $user_id  \
		 -community_id $community_id ]

# Permissions
# dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id

set actions [list]

lappend actions  "[_ lorsm.Add_Course]" [export_vars -base "course-add"] "[_ lorsm.lt_Add_a_IMSSCORM_Compli]"
lappend actions  "[_ lorsm.lt_Search_Learning_Objec]" [export_vars -base "/search"] "[_ lorsm.lt_Search_for_Learninng_]"
lappend actions  "[_ lorsm.Available_Courses]" [export_vars -base "shared/"] "[_ lorsm.lt_View_Available_Course]"
 

template::list::create \
    -name d_courses \
    -multirow d_courses \
    -html {width 50%} \
    -actions $actions \
    -key man_id \
    -no_data "[_ lorsm.No_Courses]" \
    -elements {
        course_name {
            label "[_ lorsm.Available_Courses]"
            display_col course_name
            link_url_eval {delivery/?[export_vars man_id]}
            link_html {title "[_ lorsm.Access_Course]"}

        }
        class_name {
            label "[_ lors-central.class_name]"
	}
        hasmetadata {
            label "[_ lorsm.Metadata_1]"
            link_url_eval {md/?[export_vars ims_md_id]}
            link_html {title "[_ lorsm.See_metadata]" }
	    html { align center }
        }
        isscorm {
            label "[_ lorsm.SCORM]"
	    html { align center }
        }
        isenabled {
            label "[_ lorsm.Status_1]"
	    html { align center }
        }
        istrackable {
            label "[_ lorsm.Tracking]"
            link_url_eval {tracking/?[export_vars {man_id lorsm_instance_id community_id}]}
            link_html {title "[_ lorsm.lt_Track_Students_Progre]" class button}
	    html { align center }
        }
        creation_user {
            label "[_ lorsm.Owner]"
            display_eval {[person::name -person_id $creation_user]}
            link_url_eval {[acs_community_member_url -user_id $creation_user]}
        }
        creation_date {
            label "[_ lorsm.Creation_Date]"
            display_eval {[lc_time_fmt $creation_date "%x %X"]}
        }
        export {
            label "[_ lorsm.Export]"
	    display_eval {\[zip\]}
            link_url_eval {[export_vars -base export folder_id]}
            link_html {title "[_ lorsm.lt_Export_as_IMS_Content]"}
	    html { align center }
        }
        admin {
            label "[_ lorsm.Admin_Course]"
	    display_eval {Admin}
            link_url_eval {[export_vars -base course-structure {man_id lorsm_instance_id}]}
            link_html {title "[_ lorsm.Admin_Course]" class button}
	    html { align center }
        }
    }


db_multirow -extend { ims_md_id class_name } d_courses select_d_courses {
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           cp.version,
           cpmc.lorsm_instance_id,
           cpmc.community_id,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as hasmetadata,
           case 
              when isscorm = 't' then 'Yes'
              else 'No'
           end as isscorm,
           cp.fs_package_id,
           cp.folder_id,
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id,
           case
              when cpmc.isenabled = 't' then 'Enabled'
             else 'Disabled'
           end as isenabled,
           case
              when cpmc.istrackable = 't' then 'Yes'
             else 'No'
           end as istrackable
    from
           ims_cp_manifests cp, acs_objects acs, ims_cp_manifest_class cpmc
    where 
           cp.man_id = acs.object_id
    and
           cp.man_id = :man_id
    and    
           cp.man_id = cpmc.man_id
    order by acs.creation_date desc
} {
    set ims_md_id $man_id
    set class_name [lors_central::get_class_name -community_id $community_id]
}
 
