<?xml version="1.0"?>
<queryset>

<fullquery name="get_other_resources">
  <querytext>
	select 
		distinct res_id 
	from 
		ims_cp_items_to_resources 
	where 
		res_id in ( 
			  select 
				res_id 
			  from 
				ims_cp_items_to_resources 
			  where 
				ims_item_id in (
						select 
							ims_item_id 
						from 
							ims_cp_items 
						where 
							org_id in $orgs_list
						)
			  ) 
		and res_id not in ( 
				  select 
					res_id 
				  from 
					ims_cp_resources 
				  where 
					man_id = :course_man_id
				  )
  </querytext>
</fullquery>


<fullquery name="get_metadata_info">
  <querytext>
	select 
		md.schema, 
		md.schemaversion, 
		mdgt.title_l, 
		mdgt.title_s, 
		mdgd.descrip_l, 
		mdgd.descrip_s 
	from 
		ims_md md, 
		ims_md_general_title mdgt, 
		ims_md_general_desc mdgd 
	where 
		md.ims_md_id = mdgd.ims_md_id and
		mdgd.ims_md_id = mdgt.ims_md_id and
		md.ims_md_id = :man_id
  </querytext>
</fullquery>


<fullquery name="get_man_info">
  <querytext>
	select
		*
	from
		ims_cp_manifests
	where
		man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="get_organizations">
  <querytext>
	select
		*
	from
		ims_cp_organizations
	where
		man_id = :man_id
	order by org_id
  </querytext>
</fullquery>

<fullquery name="get_resources">
  <querytext>
	select
		r.*
	from 
	   	ims_cp_resources r,
	   	ims_cp_items_to_resources ir
        where 
	   	r.res_id = ir.res_id
	   	and ir.ims_item_id in ( 
					select 
						ims_item_id 
				        from 
						ims_cp_items 
				   	where 
						org_id = :org_id
				       )
	order by res_id
  </querytext>
</fullquery>

<fullquery name="get_resource_files">
  <querytext>
	select
	        file_id,
	        filename
	from
	        ims_cp_files
	where
	        res_id = :res
  </querytext>
</fullquery>

<fullquery name="get_files">
  <querytext>
	select
		*
	from 
		ims_cp_files
	where 
		res_id = :res_id
	order by file_id
  </querytext>
</fullquery>

<fullquery name="get_item_info">
  <querytext>
	select 
		i.identifier, 
		i.identifierref, 
		i.item_title,
		ir.res_id as item_res_id
	from 
		ims_cp_items i, ims_cp_items_to_resources ir
	where 
		i.ims_item_id = ir.ims_item_id and
		i.ims_item_id = :ims_item_id
		
  </querytext>
</fullquery>

<fullquery name="get_href">
  <querytext>
	select 
		href 
	from 
		ims_cp_resources 
	where 
		res_id = :res
  </querytext>
</fullquery>

<fullquery name="get_file">
  <querytext>
	select 
		file_id 
	from 
		ims_cp_files 
	where 
		res_id = :res
  </querytext>
</fullquery>

<fullquery name="get_filename">
  <querytext>
	select 
		filename 
	from 
		ims_cp_files 
	where 
		file_id = :file_id
  </querytext>
</fullquery>

<fullquery name="get_man_id">
  <querytext>
	select 
		man_id
	from 
		ims_cp_resources
	where 
		res_id = :res
  </querytext>
</fullquery>

</queryset>