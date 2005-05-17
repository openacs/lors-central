ad_page_contract {
    Drop associations of item_id's with dotlrn's classes or communities

    @author          Miguel Marin (miguelmarin@viaro.net) 
    @author          Viaro Networks www.viaro.net
} {
    item_id:notnull
    object_id:multiple
    { return_url "" }
}

# Checking swa privilege over lors-central
lors_central::is_swa


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
    ad_returnredirect "course-dotlrn-assoc?item_id=$item_id"
} else {
    ad_returnredirect $return_url
}

