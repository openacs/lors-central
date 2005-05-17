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
                         icmc.man_id = :man_id
                  )
	    order by 
                  dc.department_name, dc.term_name, dc.class_name, dc.pretty_name
        </querytext>
    </fullquery>

</queryset>