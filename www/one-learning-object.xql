<?xml version="1.0"?>
<queryset>

    <fullquery name="get_dotlrn_classes">
        <querytext>
            select 
                  dc.class_instance_id as com_id, 
                  dc.department_name, 
                  dc.term_name, 
                  dc.class_name, 
                  dc.pretty_name
	    from 
                  dotlrn_class_instances_full dc
            where 
                  dc.class_instance_id in
                  (
                  select community_id from ims_cp_items_map where man_id = :man_id
                  ) 
                  and
                  dc.class_instance_id in
                  (
                  select
                         icmc.community_id
                  from
                         ims_cp_manifest_class icmc
                  where 
                         icmc.man_id in
                         (
                         select 
                                revision_id 
                         from 
                                cr_revisions 
                         where 
                                item_id = :man_item_id
                         )
                  )
		  $orderby_clause
        </querytext>
    </fullquery>


    <fullquery name="get_versions">
        <querytext>
        select 
               r.item_title,
               r.title as item_name, 
               r.revision_id as ims_item_id,
               r.publish_date as last_modified, 
               ao.creation_user as user_id,
	       ir.res_id,
	       io.man_id
        from 
               ims_cp_itemsx r, acs_objects ao,
               ims_cp_items_to_resources ir,
               ims_cp_organizations io
               
        where 
	       r.org_id=io.org_id
           and r.item_id = :item_id
           and r.revision_id = ao.object_id
	   and ir.ims_item_id = r.revision_id   
        order by 
               revision_id asc
        </querytext>
    </fullquery>

    <fullquery name="get_res_id">
        <querytext>
        select
                res_id
        from 
                ims_cp_items_to_resources
        where 
                ims_item_id = :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_file_id">
        <querytext>
        select
                file_id
        from
                ims_cp_files
        where
                res_id = :res_id and
                pathtofile = :href
        </querytext>
    </fullquery>

    <fullquery name="get_res_file_id">
        <querytext>
        select
                f.file_id
        frome
                ims_cp_files f, ims_cp_resources r
        where
                r.res_id = :res_id and
	        f.res_id = r.res_id 
                f.pathtofile = r.href
        </querytext>
    </fullquery>

    <fullquery name="get_mime_type">
        <querytext>
        select 
                mime_type
        from 
                cr_revisions
        where 
                revision_id = :file_id
        </querytext>
    </fullquery>

    <fullquery name="get_hide_p">
        <querytext>
        select 
                hide_p
        from 
                ims_cp_items_map
        where 
                ims_item_id = :ims_item
                and community_id = :com_id
        </querytext>
    </fullquery>

    <fullquery name="get_org_id">
        <querytext>
        select 
                org_id 
        from 
                ims_cp_items 
        where 
                ims_item_id=:ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_live_revision">
        <querytext>
        select 
                live_revision
        from 
                cr_items
        where 
                item_id= :item_id
        </querytext>
    </fullquery>

    <fullquery name="get_name">
        <querytext>
        select 
                item_title
        from 
                ims_cp_items
        where 
                ims_item_id= :last_version
        </querytext>
    </fullquery>

    <fullquery name="get_isshared">
        <querytext>
        select 
                isshared
        from 
                ims_cp_items
        where 
                ims_item_id= :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_prev_mime_type">
        <querytext>
        select 
                mime_type
        from 
                cr_revisions
        where 
                revision_id = (select live_revision from cr_items where item_id = :file_prev_id)
        </querytext>
    </fullquery>

    <fullquery name="get_ims_item_id">
        <querytext>
        select 
                ims_item_id
        from 
                ims_cp_items_map
        where 
                man_id =:man_id and
                community_id = :com_id and 
                ims_item_id in ( select revision_id 
                                 from cr_revisions 
                                 where item_id = ( select item_id 
                                                   from cr_revisions 
                                                   where revision_id = :ims_item_id
                                                  )
                               )
        </querytext>
    </fullquery>

</queryset>