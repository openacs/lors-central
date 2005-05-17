# packages/lorsm/www/edit-content.tcl

ad_page_contract {
    
    Online content editor for LORSm

    Uses htmlarea to edit html/txt file-storage
    content

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-07-06
    @arch-tag: 6f57a7d1-7032-44e4-b333-6a7fb74ae30b
    @cvs-id $Id$
} {
    folder_id:integer
    fs_package_id:integer
    identifierref
    return_url
} -properties {
} -validate {
} -errors {
}

set user_id [ad_conn user_id]

# Checking swa privilege over lors-central
lors_central::is_swa

set folder [db_string select_folder_key {select key from fs_folders where folder_id = :folder_id}]
set fs_root_folder [db_string sql {select file_storage__get_root_folder(:fs_package_id)}]
set identifierref [lorsm::fix_url -url $identifierref]
set pather $folder/$identifierref

# in some case, the resource is defined with a / that conflicts with
# our existing / creating a double //. Therefore we use a regsub to
# get rid of it
regsub -all {//} $pather {/} pather


set file_id [db_string sql {select content_item__get_id(:pather, :fs_root_folder, 'f')}]

# check for permissions
# By default, only the creator has admin access to content

permission::require_write_permission -object_id $file_id -creation_user $user_id 

#ns_write "[_ lorsm.lt_folder_foldern_pather]"
#ad_script_abort

ad_returnredirect [export_vars -base [apm_package_url_from_id $fs_package_id]file-content-edit {file_id return_url}]

