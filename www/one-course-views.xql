<?xml version="1.0"?>
<queryset>

    <fullquery name="get_versions">
        <querytext>
        select 
               r.title as course_name, 
               r.revision_id as man_id,
               r.publish_date as last_modified,
               ao.creation_user as user_id
        from 
               cr_revisions r, acs_objects ao
        where 
               :item_id = r.item_id and
               r.revision_id = ao.object_id
        order by 
               revision_id asc
        </querytext>
    </fullquery>

</queryset>