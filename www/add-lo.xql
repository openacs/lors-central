<?xml version="1.0"?>
<queryset>

<fullquery name="get_max_sort_order">
  <querytext>
      select
             max (sort_order)
      from
             ims_cp_items
      where
             org_id = :org_id
  </querytext>
</fullquery>

<fullquery name="get_folder_id">
  <querytext>
      select
             item_id
      from
             cr_items
      where
             name = :course_name and
             parent_id = :root_folder
  </querytext>
</fullquery>

<fullquery name="get_res_identifier">
  <querytext>
      select
             identifier
      from
             ims_cp_resources
      where
             res_id = :clipboard_object_id
  </querytext>
</fullquery>

<fullquery name="get_res_href">
  <querytext>
      select
             href
      from
             ims_cp_resources
      where
             res_id = :clipboard_object_id
  </querytext>
</fullquery>

<fullquery name="get_item_title">
  <querytext>
      select
             item_title
      from
             ims_cp_items
      where
             ims_item_id = ( select
				min (ims_item_id)
			 from
				ims_cp_items_to_resources
		  	 where
				res_id = :clipboard_object_id )
  </querytext>
</fullquery>

<fullquery name="get_item_identifier">
  <querytext>
      select
             identifier
      from
             ims_cp_items
      where
             ims_item_id = ( select
				ims_item_id
			 from
				ims_cp_items_to_resources
		  	 where
				res_id = :clipboard_object_id )
  </querytext>
</fullquery>

<fullquery name="get_items_folder_id">
  <querytext>
      select
             item_id
      from
             cr_items
      where
             name = :course_name and
             parent_id = :root_ims_folder
  </querytext>
</fullquery>

<fullquery name="copy_files">
  <querytext>
	insert into ims_cp_files ( 	
		 	           select 
                                           file_id, 
					   :new_res_rev_id, 
					   pathtofile, 
					   filename, 
					   hasmetadata 
				   from 
                                           ims_cp_files 
				   where 
					   res_id = :clipboard_object_id
				  )
  </querytext>
</fullquery>

<fullquery name="get_items_to_reorder">
  <querytext>
      select
             sort_order as order, ims_item_id as reorder_item_id
      from
             ims_cp_items
      where
             org_id = :org_id 
             and sort_order >= :sort_order
  </querytext>
</fullquery>

<fullquery name="reorder_items">
  <querytext>
      update
             ims_cp_items
      set
             sort_order = :new_sort
      where
             ims_item_id = :reorder_item_id
  </querytext>
</fullquery>

</queryset>
