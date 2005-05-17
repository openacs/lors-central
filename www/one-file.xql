<?xml version="1.0"?>
<queryset>

    <fullquery name="get_name">
        <querytext>
        select 
                item_title
        from 
                ims_cp_items
        where 
                ims_item_id= :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_org_id">
        <querytext>
        select 
                org_id
        from 
                ims_cp_items
        where 
                ims_item_id= :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_file_info">
        <querytext>
        select distinct file_id as fileid, filename
	from ims_cp_files 
	where file_id in ( select revision_id 
			   from cr_revisions
			   where item_id = :file_item_id )
        </querytext>
    </fullquery>


  <fullquery name="get_prev_mime_type">
        <querytext>
        select
                mime_type
        from
                cr_revisions
        where
                revision_id = :file_id
        </querytext>
    </fullquery>

  <fullquery name="get_mime_type">
        <querytext>
        select
                mime_type
        from
                cr_revisions
        where
                revision_id = :fileid
        </querytext>
    </fullquery>

    <fullquery name="get_course_info">
        <querytext>
	select 
		distinct
                m.man_id,
	        m.course_name
	from 
		ims_cp_files f,
	        ims_cp_resources r,
	        ims_cp_manifests m
	where 
		f.file_id = :file_id
	        and f.res_id=r.res_id
                and r.man_id=m.man_id
        </querytext>
    </fullquery>


</queryset>