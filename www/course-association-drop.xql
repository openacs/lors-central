<?xml version="1.0"?>
<queryset>

<fullquery name="get_man_ids">
  <querytext>
      select 
         revision_id
      from
         cr_revisions
      where
         item_id = :item_id
  </querytext>
</fullquery>


<fullquery name="get_organizations">
  <querytext>
      select 
         org_id
      from
         ims_cp_organizations
      where
         man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="delete_items">
  <querytext>
       delete from ims_cp_items_map
       where 
             man_id = :man_id and
             org_id = :org_id and
             community_id = :community_id
  </querytext>
</fullquery>

</queryset>