# packages/lorsm/www/tracker.tcl

ad_page_contract {
    
    set a course for a class to be trackable
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-05-25
    @arch-tag 07ceb832-2053-4579-bec2-76708522707a
    @cvs-id $Id$
} {
    man_id:integer,notnull
    community_id:integer,notnull
} -properties {
} -validate {
} -errors {
}

# Checking privilege over lors-central
lors_central::check_permissions

set lorsm_instance_id [db_string get_lorsm_instance_id { 
    select lorsm_instance_id from ims_cp_manifest_class where man_id = :man_id and community_id = :community_id
} -default 0]

set package_id $lorsm_instance_id 

if { [string equal $package_id "0"] } {
    ad_return_complaint 1 "[_ lors-central.you_have_to]"
    ad_script_abort
}

set title "[_ lorsm.lt_Set_Course_Track_Opti]"
set context [list [list "one-course-associations?man_id=$man_id" \
		       "[_ lors-central.one_course_assoc]"] "[_ lorsm.Set_Course_Options]"]

ad_form -name tracker \
    -export {package_id} \
    -form {
	{man_id:key}
	{project:text(inform)
	    {label "[_ lorsm.Course_Name]"}
	    {value {[lorsm::get_course_name -manifest_id $man_id]}}
	}
	{istrackable:text(inform)
	    {label "[_ lorsm.Current_Status]"}
	}
	{lorsm_instance_id:text(hidden)
	    {value $lorsm_instance_id}
	}
	{community_id:text(hidden)
	    {value $community_id}
	}
	{enable:text(radio)
	    {label Status?}
	    {options {{"[_ lorsm.Trackable_1]" t} {"[_ lorsm.No_Thanks]" f}}}
	}
    } -select_query {
        select 
        case when istrackable = 't' then 'Yes'
          else 'No'
        end as istrackable
	from ims_cp_manifest_class
	where man_id = :man_id and 
	lorsm_instance_id = :package_id
    } -edit_data {
        db_dml do_update "
            update ims_cp_manifest_class
            set istrackable = :enable
            where man_id = :man_id and 
            lorsm_instance_id = :package_id"
    } -after_submit {
        ad_returnredirect "one-course-associations?man_id=$man_id"
        ad_script_abort
    }





