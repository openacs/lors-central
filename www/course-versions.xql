<?xml version="1.0"?>
<queryset>

    <fullquery name="get_versions">
        <querytext>
        select 
               r.title as course_name, 
               r.revision_id as man_id
        from 
               cr_revisions r 
        where 
               :item_id = r.item_id 
        order by 
               revision_id asc
        </querytext>
    </fullquery>

</queryset>