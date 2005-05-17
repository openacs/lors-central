<?xml version="1.0"?>
<queryset>

<fullquery name="manifest">
  <querytext>
    select 
           cp.man_id,
           cp.course_name,
           cp.identifier,
           text 'Yes' as hello,
           case
              when hasmetadata = 't' then 'Yes'
              else 'No'
           end as man_metadata,
           case 
              when isscorm = 't' then 'Yes'
              else 'No'
           end as isscorm,
           cp.folder_id,
	   cp.isshared,
	   acs.creation_user,
	   acs.creation_date,
	   acs.context_id
--         cpmc.isenabled,
--         cpmc.lorsm_instance_id,
--         cpmc.istrackable
    from
           ims_cp_manifests cp, acs_objects acs
    where 
           cp.man_id = acs.object_id
	   and  cp.man_id = :man_id
--         and  cp.man_id = cpmc.man_id
--         and  cpmc.lorsm_instance_id = :package_id
           and  cp.parent_man_id = 0
  </querytext>
</fullquery>

<fullquery name="get_folder_id">
  <querytext>
      select 
             item_id 
      from 
             cr_items 
      where 
             name = :instance and 
             parent_id = :root_folder
  </querytext>
</fullquery>

<fullquery name="organizations">
  <querytext>
    select 
       org.org_id,
       org.org_title as org_title,
       org.hasmetadata,
       tree_level(o.tree_sortkey) as indent
    from
       ims_cp_organizations org, acs_objects o
    where
       org.org_id = o.object_id
     and
       man_id = :man_id
    order by
       org_id
  </querytext>
</fullquery>

<fullquery name="items_count">
   <querytext>
       select count(ims_item_id) as total_items
       from ims_cp_items
       where org_id = :org_id and
       ims_item_id in ( select live_revision from cr_items where content_type = 'ims_item_object')
   </querytext>
</fullquery>

<fullquery name="ad_table_contents_query">
  <querytext>
        SELECT
		o.object_id,
 		repeat('&nbsp;', (tree_level(cr.tree_sortkey) - :indent)* 3) as indent,
		i.ims_item_id as item_id,
                i.sort_order as sort_order,
                i.item_title as item_title,
                i.hasmetadata,
                i.parent_item,
                i.org_id,
                i.sort_order,
                case
                    when i.isshared = 'f' then (
						'false'
						) 
	            else 'true'
                end as isshared,
                case 
		    when i.identifierref <> '' then (
						     SELECT
						      res.href 
						     FROM
						      ims_cp_items_to_resources i2r, 
						      ims_cp_resources res 
						     WHERE
						       i2r.res_id = res.res_id
						      AND
						       i2r.ims_item_id = i.ims_item_id 
                                                     ) 
                  else ''
                end as identifierref,
                case 
		    when i.identifierref <> '' then (
						     SELECT
						      res.type
						     FROM
						      ims_cp_items_to_resources i2r, 
						      ims_cp_resources res 
						     WHERE
						       i2r.res_id = res.res_id
						      AND
						       i2r.ims_item_id = i.ims_item_id 
                                                    )
                  else ''
                end as type,
                m.fs_package_id,
	        m.folder_id,
	        m.course_name
        FROM 
		acs_objects o, ims_cp_items i, ims_cp_manifests m, cr_items cr
	WHERE 
		o.object_type = 'ims_item_object'
           AND
		i.org_id = :org_id
	   AND
		o.object_id = i.ims_item_id
           AND
                i.ims_item_id = (
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
                                                         revision_id = i.ims_item_id
                                                  )
                               )
           AND
                m.man_id = :man_id
           AND
                cr.item_id = (select item_id from cr_revisions where revision_id = i.ims_item_id)
        ORDER BY 
                i.sort_order, cr.tree_sortkey, o.object_id
  </querytext>
</fullquery>

<fullquery name="get_associations_num">
  <querytext>
      select 
             count(community_id) 
      from 
             ims_cp_manifest_class 
      where 
             man_id = :man_id
  </querytext>
</fullquery>

</queryset>