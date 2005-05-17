<?xml version="1.0"?>

<queryset>

  <fullquery name="get_cb_id">      
    <querytext>
	select object_id 
	from acs_objects 
	where package_id = :package_id and object_type='clipboard'	
    </querytext>
  </fullquery>

  <fullquery name="get_files">      
    <querytext>
	select 
	       	'Edit' as edit, 
	       	r.res_id, 
	       	r.file_id, 
	       	r.item_id, 
               	r.revision_id,
		r.filename, 
		r.pathtofile,
		r.title, 
		r.mime_type,
		r.label as mime_type_pretty
	from 
		ims_cp_items_to_resources itr left join
		( select 
			 f.res_id, 
			 f.file_id, 
			 ci.item_id, 
			 cr.revision_id,
		 	 f.filename, 
                         f.pathtofile,
			 cr.title,
                         cr.mime_type,
			 cm.label
		  from
			 ims_cp_files f,
			 cr_items ci,
			 cr_revisions cr,
			 cr_mime_types cm
		  where 
			 ci.item_id = ( select item_id from cr_revisions where revision_id = f.file_id)
			 and cr.revision_id = ci.live_revision
			 and cr.mime_type = cm.mime_type ) r
		on r.res_id = itr.res_id
		where itr.ims_item_id = :ims_item_id
    </querytext>
  </fullquery>

  <fullquery name="get_files2">      	
    <querytext>
	select 
		i.file_id,
		i.res_id, 
		i.pathtofile, 
		i.filename, 
		i.hasmetadata, 
		cr.title,
		crm.label as mime_type_pretty,
                case when i.pathtofile = 
	             (select href from ims_cp_resources where res_id=:res_id) 
                     then 1 else 0 end as main_file_p	        
	from 
		ims_cp_files i, 
		cr_mime_types crm,
		cr_revisions cr
		where i.res_id = :res_id
		and crm.mime_type = ( select mime_type 
				      from cr_revisions 
			 	      where revision_id = i.file_id)
		and cr.revision_id = i.file_id

    </querytext>
  </fullquery>

  <fullquery name="get_file_item_id">      
    <querytext>
	select item_id 
	from cr_revisions 
	where revision_id = :file_id	
    </querytext>
  </fullquery>

  <fullquery name="get_revision_count">      
    <querytext>
	select count(revision_id) 
	from cr_revisions
	where item_id = :file_item_id
    </querytext>
  </fullquery>


</queryset>
