<?xml version="1.0"?>
<queryset>

    <fullquery name="get_mime_type">
        <querytext>
        select 
                mime_type
        from 
                cr_revisions
        where 
                revision_id = :version_id
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

    <fullquery name="get_pathtofile">
        <querytext>
	select 
		pathtofile as file_href 
	from 
		ims_cp_files 
	where 
		file_id = :file_id
		and res_id = :res_id
        </querytext>
    </fullquery>

    <fullquery name="get_filename">
        <querytext>
	select 
		filename as file_name 
	from 
		ims_cp_files 
	where 
		file_id = :file_id	
		and res_id = :res_id
        </querytext>
    </fullquery>

    <fullquery name="get_href">
        <querytext>
	select 
		href as res_href 
	from 
		ims_cp_resources 
	where 
		res_id = :res_id
        </querytext>
    </fullquery>

</queryset>