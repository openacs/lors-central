ad_page_contract {
    Displays al files associated to this version of one LO
    @author Miguel Marin (miguelmmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    man_id:notnull
    ims_item_id:notnull
    {org_id ""}
    {name ""}
}

# Checking privilege over lors-central
lors_central::check_permissions

if { [empty_string_p $name] } {
    set name [db_string get_name { } -default "..."]
}
if { [empty_string_p $org_id] } {
    set name [db_string get_name { } -default "..."]
}


set page_title "[_ lors-central.lo_files]"
set context "[list [list "one-learning-object?ims_item_id=$ims_item_id&man_id=$man_id&name=$name" \
                   [_ lors-central.One_learning]] [_ lors-central.lo_files]]"

