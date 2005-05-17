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
                                item_id = :item_id
                         )
                  )
		  $orderby_clause
        </querytext>
    </fullquery>


    <fullquery name="get_versions">
        <querytext>
        select 
               r.title as course_name, 
               r.revision_id as man_id,
               r.publish_date as last_modified,
               ao.creation_user as user_id
        from 
               cr_revisions r, acs_objects ao
        where 
               :item_id = r.item_id and
               r.revision_id = ao.object_id
        order by 
               revision_id asc
        </querytext>
    </fullquery>

    <fullquery name="get_tracking">
        <querytext>
        select 
          istrackable
        from 
          ims_cp_manifest_class
        where 
           community_id = :com_id
           and man_id = :manifest_id
        </querytext>
    </fullquery>


    <fullquery name="get_assoc_count">
        <querytext>
            select 
                  count(dc.class_instance_id)
	    from 
                  dotlrn_class_instances_full dc
            where
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
                                item_id = :item_id
                         )
                  )
        </querytext>
    </fullquery>

</queryset>