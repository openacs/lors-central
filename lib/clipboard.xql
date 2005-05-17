<?xml version="1.0"?>

<queryset>

<fullquery name="get_cb_id">      
  <querytext>
       select object_id 	
       from acs_objects 
       where package_id= :lors_central_package_id
       and object_type='clipboard'
  </querytext>
</fullquery>      

<fullquery name="get_items">      
  <querytext>
    SELECT 
            o.object_id, 
            t.pretty_name as object_type, 
            coalesce(o.title,'object '||o.object_id) as item_title, 
            to_char(m.clipped_on,'YYYY-MM-DD HH24:MI:SS') as clipped_ansi, 
            coalesce((select 
                               label 
                       from 
                               cr_revisions, 
                               cr_items, 
                               cr_mime_types 
                       where 
                               live_revision=revision_id
                               and cr_revisions.revision_id = o.object_id 
                               and cr_revisions.mime_type = cr_mime_types.mime_type),'') as pretty_mime_type
    FROM 
            clipboard_object_map m, 
            acs_objects o, 
            acs_object_types t
    WHERE 
            clipboard_id = :clipboard_id
            $extra_query
            and o.object_id = m.object_id
            and t.object_type = ( case when o.object_type = 'content_item' then ( 
                                      select 
                                              case when i.content_type = 'content_extlink' then 
                                                        'content_extlink' 
                                                   else r.object_type 
                                              end 
                                       from 
                                              acs_objects r, 
                                              cr_items i 
                                       where 
                                              r.object_id = coalesce( i.live_revision, i.latest_revision, i.item_id) 
                                              and i.item_id = o.object_id) else o.object_type 
                                 end )
  </querytext>
</fullquery>

<fullquery name="get_object_name">      
  <querytext>
       select distinct filename
       from ims_cp_files 
       where file_id = :object_id
  </querytext>
</fullquery>      


</queryset>
