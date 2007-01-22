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
            left join
                   dotlrn_instructor_rels_full drf
            on     drf.community_id = dc.class_instance_id
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
	           $extra_query_class
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
            left join
                   dotlrn_instructor_rels_full drf
            on     drf.community_id = dc.class_instance_id
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
	  	   $extra_query_class
	    order by department_name, term_name, class_name, pretty_name
        </querytext>
    </fullquery>

    <fullquery name="get_dotlrn_coms">
        <querytext>
            select 
	           distinct
                   dc.community_id as com_id, 
                   dc.pretty_name, 
                   dc.url
	    from 
                   dotlrn_communities_full dc
            left join dotlrn_member_rels_full dm
            on dm.community_id = dc.community_id
            where           
                   dc.community_id not in 
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
	           and ( dc.community_type = 'dotlrn_club' or  dc.community_type = 'dotlrn_community') 
                   $extra_query_community
	    order by pretty_name
        </querytext>
    </fullquery>

    <fullquery name="get_dotlrn_coms_drop">
        <querytext>
            select distinct
                   dc.community_id as com_id, 
                   dc.pretty_name, 
                   dc.url
	    from 
                   dotlrn_communities_full dc
            left join dotlrn_member_rels_full dm
            on dm.community_id = dc.community_id
            where                   
                   dc.community_id in 
                   (
                   select
                          icmc.community_id 
                   from
                          ims_cp_manifest_class icmc
                   where
                          man_id in 
                          (
                          select revision_id 
                          from cr_revisions 
                          where item_id = :item_id
                          )
                   )
	           and ( dc.community_type = 'dotlrn_club' or  dc.community_type = 'dotlrn_community') 
	           $extra_query_community
	    order by pretty_name
        </querytext>
    </fullquery>

</queryset>