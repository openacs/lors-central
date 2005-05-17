<?xml version="1.0"?>
<queryset>

    <fullquery name="get_dotlrn_classes">
        <querytext>
            select 
                   dc.class_instance_id as com_id, 
                   dc.department_name, 
                   dc.term_name, 
                   dc.class_name, 
                   dc.pretty_name, 
                   dc.url
	    from 
                   dotlrn_class_instances_full dc
            where           
                   dc.class_instance_id not in 
                   (
                   select
                          icmc.community_id 
                   from
                          ims_cp_manifest_class icmc
                   where
                          icmc.community_id is not null and
                          man_id in 
                          (
                          select revision_id 
                          from cr_revisions 
                          where item_id = :item_id
                          )
                   )
	    order by department_name, term_name, class_name, pretty_name
        </querytext>
    </fullquery>

    <fullquery name="get_dotlrn_classes_drop">
        <querytext>
            select 
                   dc.class_instance_id as com_id, 
                   dc.department_name, 
                   dc.term_name, 
                   dc.class_name, 
                   dc.pretty_name, 
                   dc.url
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
                          select revision_id 
                          from cr_revisions 
                          where item_id = :item_id
                          )
                   )
	    order by department_name, 
                     term_name, 
                     class_name, 
                     pretty_name
        </querytext>
    </fullquery>

</queryset>