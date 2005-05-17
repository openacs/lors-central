<?xml version="1.0"?>
<queryset>

<fullquery name="lors_central::export::get_items_xml.get_items_count">
  <querytext>
	select 
		count(ims_item_id) 
	from 
		ims_cp_items 
	where 
		org_id = :org_id
		and ims_item_id = (
               			  select
                                         live_revision
	                          from
         	                         cr_items
                 	          where
                          	         item_id = (
                                                   select
                                                          item_id
                                                   from
                                                          cr_revisions
                                                   where
                                                          revision_id = ims_item_id
                                                   )
                                   )
  </querytext>
</fullquery>

<fullquery name="lors_central::export::get_items_xml.get_parent_items">
  <querytext>
	select 
		ims_item_id 
	from 
		ims_cp_items 
	where 
		parent_item = :org_id 
		and org_id = :org_id
		order by sort_order
  </querytext>
</fullquery>

<fullquery name="lors_central::export::get_items_xml.get_items">
  <querytext>
	select 
		ims_item_id, sort_order
	from 
		ims_cp_items
	where 
		parent_item = :parent_item
		and org_id = :org_id
		and ims_item_id = (
               			  select
                                         live_revision
	                          from
         	                         cr_items
                 	          where
                          	         item_id = (
                                                   select
                                                          item_id
                                                   from
                                                          cr_revisions
                                                   where
                                                          revision_id = ims_item_id
                                                   )
                                   )
		order by sort_order
  </querytext>
</fullquery>

    <fullquery name="lors_central::export::get_folder_contents_count.select_folder_contents_count">
        <querytext>
            select count(*)
            from fs_objects
            where parent_id = :folder_id
        </querytext>
    </fullquery>

    <fullquery name="lors_central::export::get_folder_contents.select_folder_contents">
        <querytext>

           select cr_items.item_id as object_id,
             cr_items.name
           from cr_items
           where cr_items.parent_id = :folder_id
            and exists (select 1
                        from acs_object_party_privilege_map m
                        where m.object_id = cr_items.item_id
                          and m.party_id = :user_id
                          and m.privilege = 'read')

        </querytext>
    </fullquery>

    <fullquery name="lors_central::export::publish_versioned_object_to_file_system.select_object_metadata">
        <querytext>
            select fs_objects.*,
                   cr_items.storage_type,
                   cr_items.storage_area_key,
                   cr_revisions.title
            from fs_objects,
                 cr_items,
                 cr_revisions
            where fs_objects.object_id = :object_id
            and fs_objects.object_id = cr_items.item_id
            and fs_objects.live_revision = cr_revisions.revision_id
        </querytext>
    </fullquery>



</queryset>