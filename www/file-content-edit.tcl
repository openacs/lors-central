# packages/file-storage/www/file-content-edit.tcl

ad_page_contract {
    
    Edit contents of a file
    
    @author Deds Castillo (deds@i-manila.com.ph)
    @creation-date 2004-07-03
    @arch-tag: 05a2f0b7-6780-4385-bb62-37d959c315cd
    @cvs-id $Id$
} {
    file_id:notnull
    res_id:notnull
    man_id:notnull
    {return_url ""}
} -properties {
    title:onevalue
    context:onevalue
} -validate {
} -errors {
}


# We set here the nsv_variables to send to index.vuh to display de images
# inside the area, we only need the ims_item_id

set ims_item_id [lors_central::get_ims_item_id_or_res_id -res_id $res_id]
if {[nsv_exists delivery_vars [ad_conn session_id]]} {
    nsv_unset delivery_vars [ad_conn session_id]
}
nsv_set delivery_vars [ad_conn session_id] [list]
nsv_lappend delivery_vars [ad_conn session_id] $ims_item_id


# Checking privilege over lors-central
lors_central::check_permissions

# check they have read permission on this file

ad_require_permission $file_id read

#set templating datasources

set user_id [ad_conn user_id]
set title "Edit File Contents"


set file_item_id [lors_central::get_item_id -revision_id $file_id]
set webdav_url [fs::webdav_url -item_id $file_item_id]


