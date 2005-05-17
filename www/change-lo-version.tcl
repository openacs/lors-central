ad_page_contract {
    Change the live revision to revision_id   
                      
    @author          Miguel Marin (miguelmarin@viaro.net)
    @author          Viaro Networks www.viaro.net
    @creation_date   28-03-2005
} {
    ims_item_id:integer,notnull
    item_id:integer,notnull
    name:optional
    man_id:notnull
    live_hide_p:notnull
}

# Checking swa privilege over lors-central
lors_central::is_swa

if { ![info exist name] } {
    set name [db_string get_name { select item_title from ims_cp_items where ims_item_id = :ims_item_id }]
} 

if { [string equal $live_hide_p "live"] } {
    db_dml make_live_item {
	update ims_cp_items_map
	set ims_item_id = :ims_item_id, hide_p = 'f'
	where man_id = :man_id and
	ims_item_id in ( select revision_id from cr_revisions where item_id = :item_id)
    }
} else {
    db_dml hide_item {
	update ims_cp_items_map
	set hide_p = 't'
	where man_id = :man_id and
	ims_item_id in ( select revision_id from cr_revisions where item_id = :item_id)
    }
}

ad_returnredirect "one-learning-object?ims_item_id=$ims_item_id&man_id=$man_id&name=$name"