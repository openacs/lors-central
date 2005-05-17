<?xml version="1.0"?>
<queryset>

    <fullquery name="get_name">
        <querytext>
        select 
                item_title
        from 
                ims_cp_items
        where 
                ims_item_id= :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_org_id">
        <querytext>
        select 
                org_id
        from 
                ims_cp_items
        where 
                ims_item_id= :ims_item_id
        </querytext>
    </fullquery>

</queryset>