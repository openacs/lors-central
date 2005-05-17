<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lors_central::export::publish_versioned_object_to_file_system.select_object_content">
        <querytext>
            select lob
            from cr_revisions
            where revision_id = $live_revision
        </querytext>
    </fullquery>

    <fullquery name="lors_central::export::publish_versioned_object_to_file_system.select_file_name">
        <querytext>
            select content
            from cr_revisions
            where revision_id = :live_revision
        </querytext>
    </fullquery>

</queryset>