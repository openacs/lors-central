<?xml version="1.0"?>
<queryset>

<fullquery name="get_all_members">      
   <querytext>
	select 
		user_id 
	from 
		dotlrn_member_rels_full
	where 
		community_id = :class_com_id and 
		user_id <> :user_id
   </querytext>
</fullquery>

</queryset>