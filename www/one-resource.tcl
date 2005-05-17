ad_page_contract {
    Show one ims_cp_resource object 
    (learning object)
} {
    res_id:integer,notnull
}

set user_id [ad_conn user_id]

# TODO should we allow those with READ permission to look?
permission::require_permission \
    -object_id $res_id \
    -party_id $user_id \
    -privilege "admin"

set ims_item_id [lors_central::get_ims_item_id_or_res_id -res_id $res_id]
set man_id [db_string get_man_id { }]

set displayed_object_id $res_id
set page_title "All Resouces"
set context [list [list "one-learning-object?man_id=$man_id&ims_item_id=$ims_item_id" \
		       [_ lors-central.One_learning]] "All Resources"]

set res_item_id [lors_central::get_item_id -revision_id $res_id]

db_multirow -extend {type} revisions get_res { } {
    set last_modified [lc_time_fmt $last_modified "%x %X"]
    
    if {[string equal "" $file_id]} {
	set type "URL"
    }
}

template::list::create \
    -name revisions \
    -multirow revisions \
    -elements {
	title {label "Revision Title" display_template {<span <if @revisions.selected@ eq 1>class="list-selected">&raquo;&nbsp;</if><else>></else>@revisions.title@</span>} link_url_eval {[export_vars -base one-resource {res_id}]}}
	last_modified {label "Modified On" display_template {<span <if @revisions.selected@ eq 1>class="list-selected"</if>>@revisions.last_modified@</span>}}
	type {label "Type"}
    }

# Find lors-central courses that use this resource 

db_multirow courses courses { }

template::list::create \
    -name courses \
    -multirow courses \
    -elements {
	course_name {label "Course Name" link_url_eval {[export_vars -base one-learning-object {ims_item_id man_id org_id}]}}
    }

ad_return_template
