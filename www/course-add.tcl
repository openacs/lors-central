ad_page_contract {
    Upload and imports an IMS Content Package file
    Initial form data

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 March 2003
    @cvs-id $Id$

} {
    man_id:optional
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

# Checking privilege over lors-central
lors_central::check_permissions

if { ![info exists man_id] } { 
   set man_id ""
}

# Permissions
# dotlrn::require_user_admin_community -user_id $user_id -community_id $community_id


# Gets file-storage root folder_id
# eventually, we should provide an option so it can be imported in
# different subfolders
# set fs_package_id [site_node_apm_integration::get_child_package_id \
		       -package_id [dotlrn_community::get_package_id $community_id] \
		       -package_key "file-storage"\
		      ]

#set fs_package_id [apm_package_id_from_key "file-storage"] -- if used
# with OpenACS 

# Gets root folder and root folder name 
#set folder_id [fs::get_root_folder -package_id $fs_package_id]
#set folder_name [fs::get_object_name -object_id $folder_id]

set folder_id [lors_central::get_root_folder_id]
set folder_name [lors_central::get_folder_name -folder_id $folder_id]

# Gets whether the file-storage instance is a indb_p or file system
# (StoreFilesInDatabaseP) one not that we use it now -since we are
# currently putting everything on the file system, but eventually we
# will have the option to put it on the db. 

#set indb_p [parameter::get -parameter "StoreFilesInDatabaseP" -package_id $fs_package_id]
set indb_p 1

# Gets URL for file-storage package 
# set fs_url [apm_package_url_from_id $fs_package_id]

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
# check for admin permission on folder
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

# set course id
set course_id 1

# set context
set context [list "[_ lorsm.lt_Upload_IMS_Content_Pa]"]

template::form create course_upload -action course-add-2 -html {enctype multipart/form-data}

template::element create course_upload course_id  -label "[_ lorsm.course_id]" -datatype integer -widget hidden

template::element create course_upload indb_p -label "[_ lorsm.indb_p]" -datatype integer -widget hidden

#template::element create course_upload fs_package_id -label "[_ lorsm.fs_package_id]" -datatype integer -widget hidden

# template::element create course_upload folder_id -label "[_ lorsm.folder_id]" -datatype integer -widget hidden

template::element create course_upload upload_file -label "[_ lorsm.lt_Choose_the_course_zip]" -help_text "[_ lorsm.lt_Use_the_Browse_button]" -datatype text -widget file

# To support course versions
template::element create course_upload man_id -datatype integer -widget hidden

template::element set_properties course_upload course_id -value $course_id
# template::element set_properties course_upload folder_id -value $folder_id
template::element set_properties course_upload indb_p -value $indb_p
# template::element set_properties course_upload fs_package_id -value $fs_package_id
template::element set_properties course_upload man_id -value $man_id


ad_return_template


