ad_page_contract {
    Associates a item_id with dotlrn's class_instance_id or community

    @author          Miguel Marin (miguelmarin@viaro.net) 
    @author          Viaro Networks www.viaro.net
} {
    item_id:notnull
    type:notnull
    object_id:multiple
    { return_url "" }
}

# Checking privilege over lors-central
lors_central::check_permissions

# Display progress bar
ad_progress_bar_begin \
    -title "[_ lors-central.associate_to]" \
    -message_1 "[_ lors-central.associate_to]" \
    -message_2 "[_ lorsm.lt_We_will_continue_auto]"


set man_id [content::item::get_live_revision -item_id $item_id]

foreach community_id $object_id {
    # Here we associate the course with every community_id that was checked
    lors_central::add_relation -item_id $item_id -community_id $community_id -class_key $type

    # Now we have to make insert in the ims_cp_items_map in orther to tell which version 
    # of which course will be shown to an especific dotlrn class.
    set org_list [db_list_of_lists get_organizations { }]
    foreach org_id $org_list {
        # We need to insert every single ims_item_id to ims_cp_items_map (only the live_revision)
        set items_list [db_list_of_lists  get_ims_items { }]
        foreach ims_item_id $items_list {
            db_dml insert_items { }
        }
    }
 }



if { [empty_string_p $return_url] } {
    ad_progress_bar_end -url "course-dotlrn-assoc?item_id=$item_id"
} else {
    ad_progress_bar_end -url $return_url
}

