ad_page_contract {
   Reorders all the items according to sort_order
} {
   item_id:integer,notnull
   dir:notnull
   org_id:notnull
   sort_order:notnull
} 

# Checking privilege over lors-central
lors_central::check_permissions

set ims_item_id $item_id
set item_sort [db_string get_item_sort { }]
set man_id [db_string get_man_id { }]
set parent_item [db_string get_parent_item { }]
set global_list [db_list_of_lists get_global_group { }]
set max_sort_order [db_string get_max_sort { }]

if { [string equal $dir "up"] } {
    set up_items [list [list $ims_item_id $item_sort]]

    # First we need to get all the items that are going up 
    # (all the revisions and all the childrens if any)
    # We get all items with the same parent_item as ims_item_id has
    set same_parent [db_list_of_lists get_items_parent { }]
    
    # We get all the items for the parent_item
    
    # To get all the childrens we will get the sort_order of the next
    # ims_item_id of with the same parent and get all the ims_item_id's 
    # between the ims_item_id to reorder and the next ims_item_id
    set i 0
    foreach item $same_parent {
	if { [string equal [lindex $item 0] $ims_item_id] } {
	    set next_sort_pos [expr $i + 1]
            set back_sort_pos [expr $i - 1]
	}
        incr i
    }
    set next_sort [lindex [lindex $same_parent $next_sort_pos] 1]
    if { [empty_string_p $next_sort] } {

        # This item is the last one so we need to get the sort order of the next parent
        set next_item [lindex $global_list [expr [lsearch $global_list $parent_item] + 1]]
        if { [empty_string_p $next_item] } {
            # This is the last one of the course
	    set next_sort [expr $max_sort_order + 1]
	} else {
	    set next_sort [db_string get_next_sort { }]
	}
    }
    set up_childs [db_list_of_lists get_up_childs { }]
    foreach item $up_childs {
	lappend up_items $item
    }
    set tot_items_up [llength $up_items]
    
    # Finish with up, now we are going to so the same for the items that
    # are going down

    set back_sort [lindex [lindex $same_parent $back_sort_pos] 1]
    set down_items [list [lindex $same_parent $back_sort_pos]]
    set down_childs [db_list_of_lists get_down_childs { }]
    foreach item $down_childs {
	lappend down_items $item
    }
    set tot_items_down [llength $down_items]
 
    # Now that we now how many items will go up and how many will go down 
    # we make the updates on the tables

    foreach item $up_items {
        set ims_item_id [lindex $item 0]
        set sort [expr [lindex $item 1] - $tot_items_down]
	lors_central::set_sort_order -ims_item_id $ims_item_id -sort_order $sort
    }
    foreach item $down_items {
        set ims_item_id [lindex $item 0]
        set sort [expr [lindex $item 1] + $tot_items_up]
	lors_central::set_sort_order -ims_item_id $ims_item_id -sort_order $sort
    }
} else {
    # We are going to do the same as above but with some variants
    set down_items [list [list $ims_item_id $item_sort]]

    # We get all items with the same parent_item as ims_item_id has
    set same_parent [db_list_of_lists get_items_parent { }]
    
    # To get all the childrens we will get the sort_order of the next
    # ims_item_id of with the same parent and get all the ims_item_id's 
    # between the ims_item_id to reorder and the next ims_item_id
    set i 0
    foreach item $same_parent {
	if { [string equal [lindex $item 0] $ims_item_id] } {
	    set next_sort_pos [expr $i + 1]
            set back_sort_pos [expr $i + 2]
	}
        incr i
    }
    set next_sort [lindex [lindex $same_parent $next_sort_pos] 1]
    set down_childs [db_list_of_lists get_down_childs_2 { }]
    foreach item $down_childs {
	lappend down_items $item
    }
    set tot_items_down [llength $down_items]

    
    # Finish with down, now we are going to so the same for the items that
    # are going up

    set back_sort [lindex [lindex $same_parent $back_sort_pos] 1]
    if { [empty_string_p $back_sort] } {
        # This is the last one of same parent
        set next_item [lindex $global_list [expr [lsearch $global_list $parent_item] + 1]]
        if { [empty_string_p $next_item] } {
            # This is the last one of the course
	    set back_sort [expr $max_sort_order + 1]
	} else {
	    set back_sort [db_string get_next_sort { }]
	}
    }
    set up_items [list [lindex $same_parent $next_sort_pos]]
    set up_childs [db_list_of_lists get_up_childs_2 { }]
    foreach item $up_childs {
	lappend up_items $item
    }
    set tot_items_up [llength $up_items]

    # Now that we now how many items will go up and how many will go down 
    # we make the updates on the tables

    foreach item $up_items {
        set ims_item_id [lindex $item 0]
        set sort [expr [lindex $item 1] - $tot_items_down]
	lors_central::set_sort_order -ims_item_id $ims_item_id -sort_order $sort
    }
    foreach item $down_items {
        set ims_item_id [lindex $item 0]
        set sort [expr [lindex $item 1] + $tot_items_up]
	lors_central::set_sort_order -ims_item_id $ims_item_id -sort_order $sort
    }
}

ad_returnredirect "one-course?man_id=$man_id"