ad_page_contract {
    Drop associations of item_id's with dotlrn's classes or communities

    @author          Miguel Marin (miguelmarin@viaro.net) 
    @author          Viaro Networks www.viaro.net
} {
    item_id:notnull
    object_id:multiple
    { return_url "" }
}

# Display progress bar
ad_progress_bar_begin \
    -title "[_ lors-central.associate_to]" \
    -message_1 "[_ lors-central.associate_to]" \
    -message_2 "[_ lorsm.lt_We_will_continue_auto]"


# Checking privilege over lors-central
lors_central::check_permissions


set man_list [db_list_of_lists get_man_ids { }]
foreach community_id $object_id {
    lors_central::drop_relation -item_id $item_id -community_id $community_id
    foreach man_id $man_list {
        set org_list [db_list_of_lists get_organizations { }]
        foreach org_id $org_list {
	    db_dml delete_items { }
        }
    }
}

if { [empty_string_p $return_url] } {
    ad_progress_bar_end -url "course-dotlrn-assoc?item_id=$item_id"
} else {
    ad_progress_bar_end -url $return_url
}

