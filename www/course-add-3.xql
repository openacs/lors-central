<?xml version="1.0"?>
<queryset>

    <fullquery name="get_all_communities">
        <querytext>
           select  
                  icmc.community_id as com_id, 
                  icmc.lorsm_instance_id as lors_ins_id,
                  icmc.class_key as cl_key,
                  icmc.isenabled as ie,
                  icmc.istrackable as it
           from 
                  ims_cp_manifest_class icmc
           where 
                  icmc.man_id in ( select revision_id 
                                   from cr_revisions 
                                   where item_id = :version_id )
        </querytext>
    </fullquery>

    <fullquery name="update_course">
        <querytext>
            update ims_cp_manifest_class 
            set 
                  man_id = :man_id,
                  lorsm_instance_id = :lors_ins_id, 
                  class_key = :cl_key, 
                  isenabled = :ie, 
                  istrackable = :it
            where
                  community_id = :com_id
        </querytext>
    </fullquery>

    <fullquery name="delete_temporary_row">
        <querytext>
            delete from ims_cp_manifest_class 
            where
                  community_id is null and
                  class_key is null and
	          man_id = :man_id
        </querytext>
    </fullquery>

</queryset>