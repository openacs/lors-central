<?xml version="1.0"?>
<queryset>


<fullquery name="lors_central::get_ims_item_id_or_res_id.get_res_id">
  <querytext>
       select
              	res_id
       from
              	ims_cp_items_to_resources
       where
		ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_ims_item_id_or_res_id.get_ims_item_id">
  <querytext>
       select
              	ims_item_id
       from
              	ims_cp_items_to_resources
       where
		res_id = :res_id
  </querytext>
</fullquery>


<fullquery name="lors_central::get_item_url.get_folder">
  <querytext>
       select
              item_id
       from
              cr_items
       where
              name = :name and
              parent_id = :root_folder
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_url.get_subfolder_id">
  <querytext>
        select 
               item_id
        from 
               cr_items
        where
               parent_id = :folder and
               name = :subfolder_name
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_url.get_file_id">
  <querytext>
	    select 
	       item_id
	    from 
               cr_items
	    where 
               name = :url_name and
               parent_id = :sub_folder_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_url.get_other_man_id">
  <querytext>
	select 
		r.man_id
	from 
		ims_cp_resources r, ims_cp_items_to_resources ir
	where 
		ir.res_id = r.res_id and
		ir.ims_item_id = :ims_item_id
  </querytext>
</fullquery>
<fullquery name="lors_central::get_item_url.">
  <querytext>

  </querytext>
</fullquery>
<fullquery name="lors_central::get_item_url.">
  <querytext>

  </querytext>
</fullquery>
<fullquery name="lors_central::get_item_url.">
  <querytext>

  </querytext>
</fullquery>

<fullquery name="lors_central::set_sort_order.set_sort_order">
  <querytext>
     update 
             ims_cp_items
     set
             sort_order = :sort_order
     where
	     ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::set_sort_order.get_sort_order">
  <querytext>
     select 
             distinct sort_order
     from
             ims_cp_items
     where
	     ims_item_id in (
                            select revision_id 
                            from cr_revisions 
                            where item_id = (
                                            select item_id 
                                            from cr_revisions
                                            where revision_id = :ims_item_id
                                            )
                             )
             and sort_order is not null
  </querytext>
</fullquery>

<fullquery name="lors_central::change_version.get_organizations">
  <querytext>
     select 
             org_id
     from
             ims_cp_organizations
     where
	     man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="lors_central::change_version.get_ims_items">
  <querytext>
     select 
             ims_item_id
     from
             ims_cp_items
     where
	     org_id = :org_id
             and ims_item_id in ( select live_revision
                                  from cr_items
                                )
  </querytext>
</fullquery>

<fullquery name="lors_central::change_version.insert_items">
  <querytext>
     insert into ims_cp_items_map
     (man_id,org_id,community_id,ims_item_id)
     values
     (:man_id,:org_id,:community_id,:ims_item_id)
  </querytext>
</fullquery>

<fullquery name="lors_central::change_one_lo_version.update_ims_cp_items_map">
  <querytext>
        update 
                ims_cp_items_map
        set 
                ims_item_id = :new_ims_item_id
   	where 
                man_id = :man_id and 
                community_id = :community_id and 
                ims_item_id in ( 
                                 select revision_id 
                                 from cr_revisions 
                                 where item_id = :item_id )
  </querytext>
</fullquery>


<fullquery name="lors_central::folder_id_from_man_parent.get_folder_id">
  <querytext>
        select 
               item_id 
        from 
               cr_items
        where 
               parent_id = :parent_id and
               name = :folder_name
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_title.get_title">
  <querytext>
        select 
               name 
        from 
               cr_items
        where 
               item_id = :item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::check_item_name.check_name">
  <querytext>
        select 
               name 
        from 
               cr_items
        where 
               parent_id = :parent_id and
               name = :name
  </querytext>
</fullquery>

<fullquery name="lors_central::check_item_name.count_items">
  <querytext>
        select 
               count(item_id)
        from 
               cr_items
        where 
               parent_id = :parent_id
  </querytext>
</fullquery>


<fullquery name="lors_central::get_revision_count.get_count">
  <querytext>
        select count(revision_id)
        from 
               cr_revisions
        where 
               item_id = :item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_root_folder_id.get_folder_id_from_name">
  <querytext>
        select 
               folder_id 
        from 
               cr_folders
        where 
               label = 'LORSM Root Folder'
  </querytext>
</fullquery>

<fullquery name="lors_central::get_root_resources_folder_id.get_folder_id_from_name">
  <querytext>
        select 
               folder_id 
        from 
               cr_folders
        where 
               label = 'LORSM Resources Folder'
  </querytext>
</fullquery>

<fullquery name="lors_central::get_root_manifest_folder_id.get_folder_id_from_name">
  <querytext>
        select 
               folder_id 
        from 
               cr_folders
        where 
               label = 'LORSM Manifest Folder'
  </querytext>
</fullquery>

<fullquery name="lors_central::get_root_items_folder_id.get_folder_id_from_name">
  <querytext>
        select 
               folder_id 
        from 
               cr_folders
        where 
               label = 'LORSM Items Folder'
  </querytext>
</fullquery>

<fullquery name="lors_central::get_parent_id.get_parent_id">
  <querytext>
        select 
               parent_id 
        from 
               cr_items
        where 
               item_id  = :item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_class_name.get_name">
  <querytext>
        select 
               pretty_name 
        from 
               dotlrn_class_instances_full
        where 
               community_id  = :community_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_res_id.get_res_id">
  <querytext>
       select
              res_id 
       from  
              ims_cp_items_to_resources 
       where 
              ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_href.get_res_id">
  <querytext>
       select
              res_id 
       from  
              ims_cp_items_to_resources 
       where 
              ims_item_id = :ims_item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_res_href.get_res_href">
  <querytext>
       select
              href
       from  
              ims_cp_resources 
       where 
              res_id = :res_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_res_file_id.get_file_id">
  <querytext>
	select
		file_id
	from
		ims_cp_files f,
		ims_cp_resources r
	where
		r.res_id=:res_id
	and
		f.res_id=r.res_id
	and	
		f.pathtofile=r.href
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_name.get_name">
  <querytext>
       select 
              name 
       from 
              cr_items 
       where 
              item_id = (
                        select item_id 
                        from cr_revisions 
                        where revision_id = :ims_item_id
                        )
  </querytext>
</fullquery>

<fullquery name="lors_central::get_content_revision_id.get_file_id">
  <querytext>
       select
              file_id 
       from  
              ims_cp_files
       where 
              res_id = :res_id and
              pathtofile = :href
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_url.get_folder">
  <querytext>
       select
              item_id 
       from  
              cr_items
       where 
              name = :name and
              parent_id = :root_folder
  </querytext>
</fullquery>


<fullquery name="lors_central::get_course_name.get_course_name">
  <querytext>
       select 
              course_name 
       from 
              ims_cp_manifests 
       where 
              man_id =:man_id
  </querytext>
</fullquery>


<fullquery name="lors_central::get_folder_name.get_folder_name_from_id">
  <querytext>
        select 
               label 
        from 
               cr_folders
        where 
               folder_id = :folder_id
  </querytext>
</fullquery>

<fullquery name="lors_central::relation_between.get_relation">
  <querytext>
        select 
               1 
        from 
               ims_cp_manifest_class
        where 
               community_id = :community_id 
        and
               man_id in ( select revision_id from cr_revisions where item_id = :item_id )
  </querytext>
</fullquery>

<fullquery name="lors_central::add_relation.exist_assoc">
  <querytext>
	select 
               count(community_id) 
        from 
               ims_cp_manifest_class 
        where 
               man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="lors_central::add_relation.exist_man_id">
  <querytext>
	select 
               1
        from 
               ims_cp_manifest_class 
        where 
               man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="lors_central::drop_relation.delete_relation">
  <querytext>
	delete from
               ims_cp_manifest_class 
        where 
               community_id = :community_id and 
               man_id in
               (
               select revision_id
               from cr_revisions
               where item_id = :item_id
               )
  </querytext>
</fullquery>

<fullquery name="lors_central::add_relation.get_rel">
  <querytext>
	select 
	       1 
	from 
               ims_cp_manifest_class 
     	where 
               community_id = :community_id and 
	       man_id =:man_id
  </querytext>
</fullquery>

<fullquery name="lors_central::add_relation.update_info">
  <querytext>
      update 
             ims_cp_manifest_class 
      set 
             lorsm_instance_id = :lorsm_instance_id,
             community_id = :community_id, 
             class_key = :class_key
      where 
             man_id = :man_id
  </querytext>
</fullquery>

<fullquery name="lors_central::add_relation.insert_info">
  <querytext>
      insert into ims_cp_manifest_class 
      (man_id, lorsm_instance_id, community_id, class_key, isenabled, istrackable)
      values
      (:man_id, :lorsm_instance_id, :community_id, :class_key, 't', 'f')
  </querytext>
</fullquery>

<fullquery name="lors_central::get_item_id.get_item_id">
  <querytext>
        select 
               item_id 
        from 
               cr_revisions
        where  
               revision_id = :revision_id
   </querytext>
</fullquery>

<fullquery name="lors_central::count_versions.count_versions">
  <querytext>
        select 
               count(revision_id)
        from   
               cr_revisions
        where 
               item_id = :item_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_version_num.get_all_versions">
  <querytext>
        select 
               revision_id
        from   
               cr_revisions
        where 
               item_id = :item_id
        order by revision_id asc
  </querytext>
</fullquery>

<fullquery name="lors_central::get_man_id.get_man_id">
  <querytext>
        select 
               distinct man_id
        from   
               ims_cp_manifest_class
        where 
               community_id = :community_id and
               man_id in 
               (
               select revision_id
               from cr_revisions
               where item_id = :item_id
               )
  </querytext>
</fullquery>

<fullquery name="lors_central::get_rev_id_from_version_num.get_all_versions">
  <querytext>
        select 
               revision_id
        from   
               cr_revisions
        where 
               item_id = :item_id
        order by revision_id asc
  </querytext>
</fullquery>


<fullquery name="lors_central::change_version.update_version">
  <querytext>
      update 
             ims_cp_manifest_class 
      set 
             man_id = :man_id
      where 
             community_id = :community_id and
             man_id in ( select revision_id 
                         from cr_revisions 
                         where item_id = :item_id
             )
  </querytext>
</fullquery>

<fullquery name="lors_central::get_package_instance_id.get_package_id">
  <querytext>
        select 
               dca.package_id
        from 
               dotlrn_community_applets dca,apm_packages ap
        where 
              community_id=:community_id and 
              ap.package_id=dca.package_id and 
              ap.package_key='lorsm'
  </querytext>
</fullquery>

<fullquery name="lors_central::get_username.get_user_name_from_id">
  <querytext>
       select
             first_names || ' ' ||  last_name
       from 
             cc_users
       where
             user_id = :user_id
  </querytext>
</fullquery>


<fullquery name="lors_central::get_live_classes.get_num_classes">
  <querytext>
       select
             count(man_id)
       from 
             ims_cp_manifest_class
       where
             man_id = :man_id 
       and
             community_id is not null
  </querytext>
</fullquery>

<fullquery name="lors_central::check_privilege.check_permission">
  <querytext>
      select 
              1 
      from 
              acs_permissions 
      where 
              object_id = :item_id and 
              grantee_id = :user_id and 
              privilege = 'admin'
  </querytext>
</fullquery>

<fullquery name="lors_central::change_versions_all_courses.get_all_communities">
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
                                where item_id = :item_id )
    </querytext>
</fullquery>

<fullquery name="lors_central::change_versions_all_courses.update_course">
    <querytext>
         update ims_cp_manifest_class
         set
               man_id = :man_id,
               lorsm_instance_id = :lors_ins_id,
               class_key = :cl_key,
               isenabled = :ie,
               istrackable = :it
         where
               community_id = :com_id and 
               man_id in 
               ( 
               select revision_id
               from cr_revisions
               where item_id = :item_id
               )

     </querytext>
</fullquery>

<fullquery name="lors_central::get_object_info.file_info">      
  <querytext>
    select person__name(o.creation_user) as owner,
           i.name as title,
           r.title as name,
           r.description as version_notes,
           acs_permission__permission_p(:file_id,:user_id,'write') as write_p,
           acs_permission__permission_p(:file_id,:user_id,'delete') as delete_p,
           acs_permission__permission_p(:file_id,:user_id,'admin') as admin_p,
           content_item__get_path(o.object_id, :root_folder_id) as file_url,
           i.live_revision,
           i.storage_type,
           i.storage_area_key,
           r.mime_type
      from acs_objects o, cr_revisions r, cr_items i
      where o.object_id = :file_item_id
       and i.item_id   = o.object_id
       and r.revision_id = :revision_id
  </querytext>
</fullquery>

<fullquery name="lors_central::get_object_info.get_content">      
  <querytext>
    select content_revision__get_content(:revision_id)
  </querytext>
</fullquery>

<fullquery name="lors_central::add_file.get_res_id">
   <querytext>
        select
		res_id
        from
		ims_cp_items_to_resources
        where	
		ims_item_id = :ims_item_id
    </querytext>
</fullquery>

<fullquery name="lors_central::add_file.check_file">
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

<fullquery name="lors_central::add_file.get_filename">
    <querytext>
        select
                distinct filename
        from
                ims_cp_files
        where
                file_id = :new_file_id 
    </querytext>
</fullquery>

<fullquery name="lors_central::add_file.get_pathtofile">
    <querytext>
        select
                distinct pathtofile
        from
                ims_cp_files
        where
                file_id = :new_file_id
    </querytext>
</fullquery>


<fullquery name="lors_central::add_file.get_old_res_id">
    <querytext>
        select
		res_id
        from
		ims_cp_items_to_resources
        where
		ims_item_id = :ims_item_id
    </querytext>
</fullquery>

<fullquery name="lors_central::res_update_items.get_parent_item">
    <querytext>
        select
                parent_item
        from
                ims_cp_items
        where
                ims_item_id = :ims_item_id
    </querytext>
</fullquery>
	
<fullquery name="lors_central::get_root_folder_id.get_root_folder">
    <querytext>
    	select 
		folder_id 
	from 
		cr_folders 
	where 
		label = 'LORSM Root Folder'
    </querytext>	
</fullquery>

<fullquery name="lors_central::get_items_indent.get_items">
    <querytext>
	select 
		ims_item_id 
	from 
		ims_cp_items 
	where 
		parent_item = :item_id and 
		org_id = :org_id
    </querytext>	
</fullquery>

<fullquery name="lors_central::get_items_indent.get_root_items">
    <querytext>
	select 
		ims_item_id 
	from 
		ims_cp_items 
	where 
		parent_item = :org_id and 
		org_id = :org_id
    </querytext>	
</fullquery>

<fullquery name="lors_central::get_items_indent.get_items_count">
    <querytext>
	select 
		count(ims_item_id)
        from 
		ims_cp_items 
	where 
		ims_item_id in ( 
				select 
					live_revision
                           	from 
					cr_items 
				where 
					content_type = 'ims_item_object'
				) and
	        org_id = :org_id
    </querytext>	
</fullquery>

<fullquery name="lors_central::get_folder_id.get_root_folder">
    <querytext>
    	select 
		folder_id 
	from 
		cr_folders 
	where 
		label = :name
    </querytext>	
</fullquery>

</queryset>