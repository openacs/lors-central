<?xml version="1.0"?>
<queryset>

<fullquery name="get_man_id">
  <querytext>
    select 
            man_id
    from 
            ims_cp_organizations
    where 
            org_id = :org_id
  </querytext>
</fullquery>

<fullquery name="get_item_sort">
  <querytext>
    select 
            sort_order
    from 
            ims_cp_items
    where 
            ims_item_id = :ims_item_id
  </querytext>
</fullquery>


<fullquery name="get_items_parent">
  <querytext>
    select 
            ims_item_id, sort_order
    from
	    ims_cp_items
    where
            parent_item = :parent_item
            order by sort_order asc
  </querytext>
</fullquery>

<fullquery name="get_parent_item">
  <querytext>
    select 
            parent_item
    from
	    ims_cp_items
    where
            ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="get_global_group">
  <querytext>
    select 
            ims_item_id
    from
	    ims_cp_items
    where
            parent_item = ( select
                                    parent_item
                            from    
                                    ims_cp_items
                            where
                                    ims_item_id = :parent_item )
    order by sort_order asc
  </querytext>
</fullquery>

<fullquery name="get_up_childs">
  <querytext>
    select 
            ims_item_id, sort_order
    from 
            ims_cp_items
    where 
            sort_order > :item_sort and sort_order < :next_sort
            and org_id = :org_id
    order by sort_order
  </querytext>
</fullquery>

<fullquery name="get_next_sort">
  <querytext>
    select 
            sort_order
    from 
            ims_cp_items
    where 
            ims_item_id = :next_item
            and org_id = :org_id
    order by sort_order
  </querytext>
</fullquery>

<fullquery name="get_max_sort">
  <querytext>
    select 
            max(sort_order)
    from 
            ims_cp_items
    where 
	    org_id = :org_id
  </querytext>
</fullquery>


<fullquery name="get_down_childs">
  <querytext>
    select 
            ims_item_id, sort_order
    from 
            ims_cp_items
    where 
            sort_order < :item_sort and sort_order > :back_sort
            and org_id = :org_id
    order by sort_order
  </querytext>
</fullquery>

<fullquery name="get_down_childs_2">
  <querytext>
    select 
            ims_item_id, sort_order
    from 
            ims_cp_items
    where 
            sort_order > :item_sort and sort_order < :next_sort
            and org_id = :org_id
    order by sort_order
  </querytext>
</fullquery>

<fullquery name="get_up_childs_2">
  <querytext>
    select 
            ims_item_id, sort_order
    from 
            ims_cp_items
    where 
            sort_order > :next_sort and sort_order < :back_sort
            and org_id = :org_id
    order by sort_order
  </querytext>
</fullquery>

</queryset>

