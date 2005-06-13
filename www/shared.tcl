ad_page_contract {
    Changes one ims_items isshared field
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    man_id:notnull
    ims_item_id:notnull
    {name ""}
    shared:notnull
    org_id:notnull
}

# Checking privilege over lors-central
lors_central::check_permissions

if { $shared } {
    set isshared f
} else {
    set isshared t
}

db_dml update_isshared {
    update ims_cp_items
    set isshared = :isshared
    where ims_item_id = :ims_item_id
    and org_id = :org_id
}

ad_returnredirect "one-learning-object?man_id=$man_id&name=$name&ims_item_id=$ims_item_id"