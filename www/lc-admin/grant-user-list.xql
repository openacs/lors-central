<?xml version="1.0"?>
<queryset>

<fullquery name="all_users">      
   <querytext>
	select 
		first_names, 
		last_name, 
		user_id as p_user_id, 
		email as db_email
	from 
		cc_users 
	where 
		user_id in ( 
	      		   select 
				grantee_id 
			   from 
				acs_permissions 
			   where 
				object_id = :man_id and
		  		privilege = 'admin'
			   ) and 
		user_id <> :user_id and
	        user_id in (
			   select
				distinct user_id
			   from 
				dotlrn_member_rels_full
			   where
				community_id in ( 
						select 
							community_id 
						from 
							dotlrn_member_rels_full 
						where 
							user_id = :user_id and 
							( role = 'instructor' or role = 'admin')
						)
                           )
      </querytext>
</fullquery>

<fullquery name="search_users">      
   <querytext>
	select 
		first_names, 
		last_name, 
		user_id as p_user_id, 
		email as db_email
	from 
		cc_users 
	where 
		user_id <> :user_id and 
			(
			lower(first_names) like lower('%$keyword%') or 
			lower(last_name) like lower('%$keyword%') or
	  		lower(email) like lower('%$keyword%')
			) and
	        user_id in (
			   select
				distinct user_id
			   from 
				dotlrn_member_rels_full
			   where
				community_id in ( 
						select 
							community_id 
						from 
							dotlrn_member_rels_full 
						where 
							user_id = :user_id and
                                                        ( role = 'instructor' or role = 'admin')  
						)
                           )
	order by last_name, first_names, email
      </querytext>
</fullquery>

    <fullquery name="select_member_classes">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   '' as role_pretty_name
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
	    and dotlrn_member_rels_approved.role = 'instructor'
            and dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.department_name,
                     dotlrn_class_instances_full.department_key,
                     dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_clubs">
        <querytext>
            select dotlrn_communities_full.*,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   '' as role_pretty_name
            from dotlrn_clubs_full,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
	    and dotlrn_member_rels_approved.role = 'admin'
            and dotlrn_member_rels_approved.community_id = dotlrn_communities_full.community_id
            order by dotlrn_communities_full.pretty_name,
                     dotlrn_communities_full.community_key
        </querytext>
    </fullquery>


</queryset>
