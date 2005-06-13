ad_page_contract {
    Changes versions of courses according to the number set on "Set to" 

} {
    item_id:integer,notnull
    objects_count:multiple
    objects_id:multiple
    objects_value:multiple
} -validate {
    equal_length_lists -requires {objects_id:notnull objects_value:notnull } {
        if { ![string equal [llength $objects_id] [llength $objects_value]]} {
           ad_complain "You must supply all values for <b>Set to</b>"
	}
    }
}

# Checking privilege over lors-central
lors_central::check_permissions

# Validation of Range
set i 0

foreach object $objects_value {
    if { $object < 1 || [lindex $objects_count $i] < $object } {
        ad_return_complaint 1 "You must enter the right version number for <b>Set to</b>"
	ad_script_abort 
    }
    incr i
}


set i 0
foreach object_id $objects_id {
    set object_value [lindex $objects_value $i]
    lors_central::change_version -ver_num $object_value -community_id $object_id -item_id $item_id
    incr i
}

ad_returnredirect "one-course-associations?item_id=$item_id"