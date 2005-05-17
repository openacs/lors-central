ad_page_contract {
    Changes the version of the LO that one user will see on each class
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    man_id:integer,notnull
    name:notnull
    ims_item_id:integer,notnull
    objects_id:multiple
    objects_value:multiple
}

# Checking swa privilege over lors-central
lors_central::is_swa

# object_id:     A list of communities ids
# object_value:  The version number to set the revision

set i 0
foreach object_id $objects_id {
    set object_value [lindex $objects_value $i]
    lors_central::change_one_lo_version -ver_num $object_value -community_id $object_id \
        -man_id $man_id -ims_item_id $ims_item_id
    incr i
}


ad_returnredirect "one-learning-object?ims_item_id=$ims_item_id&man_id=$man_id&name=$name"

