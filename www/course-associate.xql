<?xml version="1.0"?>
<queryset>

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

  <fullquery name="lorsm_applet_p">
    <querytext>
      select 1
      from dotlrn_community_applets,
      dotlrn_applets
      where dotlrn_community_applets.community_id = :community_id
      and dotlrn_community_applets.active_p = 't'
      and dotlrn_community_applets.applet_id = dotlrn_applets.applet_id
      and dotlrn_applets.active_p = 't'
      and dotlrn_applets.applet_key = 'dotlrn_lorsm'
    </querytext>
  </fullquery>

<fullquery name="get_ims_items">
  <querytext>
      select 
         ims_item_id
      from
         ims_cp_items
      where
         org_id = :org_id
         and
         ims_item_id = (
                        select live_revision
                        from cr_items
                        where item_id = (
                                        select item_id
                                        from cr_revisions
                                        where revision_id = ims_item_id
                                        )
                        )
  </querytext>
</fullquery>


<fullquery name="insert_items">
  <querytext>
       insert into ims_cp_items_map
          (man_id,org_id,community_id,ims_item_id)
       values
          (:man_id,:org_id,:community_id,:ims_item_id)
  </querytext>
</fullquery>

</queryset>