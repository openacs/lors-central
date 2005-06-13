ad_page_contract {
    Change the live version to the recieved file_id
    
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    man_id:notnull
    ims_item_id:notnull
    file_id:notnull
    org_id:notnull
    {name "" }
}

# Checking privilege over lors-central
lors_central::check_permissions

set file_item_id [lors_central::get_item_id -revision_id $file_id]

db_dml update_live_revision {
    update cr_items
    set live_revision = :file_id
    where item_id = :file_item_id
}

ad_returnredirect "one-file?man_id=$man_id&ims_item_id=$ims_item_id&file_id=$file_id&name=$name&org_id=$org_id"