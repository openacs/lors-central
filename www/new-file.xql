<?xml version="1.0"?>
<queryset>

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

    <fullquery name="check_file">
        <querytext>
        select
		1
        from
		ims_cp_files
        where	
		file_id = :clipboard_object_id 
		and res_id = :ims_res_id
        </querytext>
    </fullquery>

    <fullquery name="get_href">
        <querytext>
        select
                href as res_href
        from
                ims_cp_resources
        where
                res_id = :ims_res_id
        </querytext>
    </fullquery>

    <fullquery name="get_parent_item">
        <querytext>
        select
                parent_item
        from
                ims_cp_items
        where
                ims_item_id = :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_filename">
        <querytext>
        select
                distinct filename
        from
                ims_cp_files
        where
                file_id = :new_file_id 
        </querytext>
    </fullquery>

    <fullquery name="get_pathtofile">
        <querytext>
        select
                distinct pathtofile
        from
                ims_cp_files
        where
                file_id = :new_file_id
        </querytext>
    </fullquery>


    <fullquery name="get_old_res_id">
        <querytext>
        select
		res_id
        from
		ims_cp_items_to_resources
        where
		ims_item_id = :ims_item_id
        </querytext>
    </fullquery>

    <fullquery name="get_parent_item">
        <querytext>
        select
                parent_item
        from
                ims_cp_items
        where
                ims_item_id = :ims_item_id
        </querytext>
    </fullquery>

</queryset>
