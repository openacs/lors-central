ad_page_contract {
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
    Page to grant permissions to a user over one course
} {
    keyword:optional    
}

# Check lors-central privileges
lors_central::check_permissions -check_inst t

set page_title [_ lors-central.grant_permissions]
set context [list [list "." [_ lors-central.lors_admin]]  $page_title]


# To search courses
if { [info exists keyword] } {
    if { [string equal $keyword [_ lors-central.please_type]] } {
        set extra_query ""
    } else {
	set items "(0"
        set keyword "%$keyword%"
	db_foreach get_items_like { } {
            append items ",$item_id"
	}
        append items ")"
        set extra_query "and cr.item_id in $items"
    }
} else {
   set extra_query ""
}

# If user is not site wide we just show the courses where he/she has admin privilege over
if { ![acs_user::site_wide_admin_p] } {
    append extra_query " and p.object_id = acs.object_id and p.privilege = 'admin' and p.grantee_id = :user_id"
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set actions ""

template::list::create \
    -name get_courses \
    -multirow get_courses \
    -html {width 50%} \
    -actions $actions \
    -has_checkboxes \
    -key item_id \
    -no_data "[_ lorsm.No_Courses]" \
    -elements {
        course_name {
            label "[_ lorsm.Available_Courses]"
            display_col course_name
            link_url_eval {[export_vars -base "../one-course" { item_id } ]}
        }
        versions {
            label "[_ lors-central.versions]"
            display_template {
                 <center>
                 <a href="../course-versions?item_id=@get_courses.item_id@&index_p=1">@get_courses.versions@</a>
                 </center>
	    }
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
	grant_permissions {
	    label "[_ lors-central.grant_permissions]"
	    display_template {
                <center>
		<a href="grant-user-list?man_id=@get_courses.item_id@&creation_user=@get_courses.creation_user@">[_ lors-central.grant_rev]</a>
		</center>
	    }
	}
    }

# Get the root folder where the manifests will be stored uploading from lors-central
set manifest_root [lors_central::get_root_manifest_folder_id]

# Get all folders inside manifest_root, to check that man_id is in one of this folders
set folders "("
db_foreach get_subfolders { } {
    append folders "${item_id},"
}

append folders "0)"

db_multirow -extend { course_name versions } get_courses select_courses  { } {
    set course_name [db_string get_item_name "select name from cr_items where item_id = :item_id"]
    set versions [lors_central::count_versions -item_id $item_id]
} 
