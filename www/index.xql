<?xml version="1.0"?>
<queryset>

<fullquery name="get_subfolders">
   <querytext>
	select
		item_id
	from	
		cr_items
	where	
		parent_id = :manifest_root
   </querytext>
</fullquery>

<fullquery name="select_courses">
  <querytext>
      select distinct 
             cr.item_id,
             acs.creation_user,
             acs.creation_date
      from 
             cr_revisions cr, acs_objects acs, cr_items ci
      where 
            acs.object_id = cr.item_id and
	    ci.item_id = cr.item_id and
	    ci.parent_id in $folders and
            cr.revision_id in 
            (
            select man_id from ims_cp_manifests
            )
            $extra_query
  </querytext>
</fullquery>

<fullquery name="get_items_like">
  <querytext>
      select 
             item_id 
      from 
             cr_items 
      where  
             lower(name) like lower(:keyword)
  </querytext>
</fullquery>

</queryset>