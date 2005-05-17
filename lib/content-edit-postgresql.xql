<?xml version="1.0"?>

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>
  
  <fullquery name="lob_content">      
    <querytext>

	update cr_revisions
 	set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
	where revision_id = :revision_id

    </querytext>
  </fullquery>

  <fullquery name="lob_size">      
    <querytext>

	update cr_revisions
 	set content_length = lob_length(lob)
	where revision_id = :revision_id

    </querytext>
  </fullquery>

  <fullquery name="new_version">      
    <querytext>

        select file_storage__new_version(:title,:description,:mime_type,:file_id,:creation_user,:creation_ip);

    </querytext>
  </fullquery>
  
  <fullquery name="update_revision_data">      
    <querytext>

	update cr_revisions
 	set content = '$tmp_filename',
	    content_length = $tmp_size
	where revision_id = :revision_id

    </querytext>
  </fullquery>
</queryset>
