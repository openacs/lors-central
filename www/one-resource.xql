<?xml version="1.0"?>
<queryset>

<fullquery name="courses">
   <querytext>
	select 
		io.org_id, 
		ii.ims_item_id,
		im.man_id, 
		im.course_name 
	from 
		ims_cp_manifests im, 
		ims_cp_items ii , 
		ims_cp_items_to_resources ir, 
		ims_cp_organizations io, 
		cr_revisions cr, 
		cr_items ci
	where
		im.man_id = io.man_id and
		ii.org_id = io.org_id and
		ii.ims_item_id = ir.ims_item_id and
		ir.res_id = cr.revision_id and
		cr.item_id = ( 
				select 
					item_id 
				from 
					cr_revisions 
				where 
					revision_id = :res_id
			     ) and
		ci.live_revision = ii.ims_item_id
   </querytext>
</fullquery>


<fullquery name="get_man_id">
   <querytext>
	select 
		man_id 
	from 
		ims_cp_resources 
	where 
		res_id = :res_id
   </querytext>
</fullquery>


<fullquery name="get_res">
   <querytext>
	select 
		r.*, 
		f.file_id, 
		case 
		   when r.revision_id =:res_id then 1 
		   else 0 
  		end as selected 
	from 
		ims_cp_resourcesx r left join ims_cp_files f on f.res_id = r.res_id and 
  		f.pathtofile = r.href 
 	where 
		item_id = (
			select 
				item_id 
			from 
				cr_revisions 
			where 
				revision_id = :res_id
			) 
	order by ( case when revision_id = :res_id then 1 else 0 end), creation_date desc
   </querytext>
</fullquery>

</queryset>