# packages/lorsm/www/md/technicalmd/technical_req.tcl

ad_page_contract {
    
    Add/Edit Technical MD Requirement
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_te_rq_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_te_rq_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../technicalmd" \\im\\s_md_id] "[_ lorsm.Technical_MD]"] "[_ lorsm.Edit_Requirement]"]
    set title "[_ lorsm.lt_Edit_Technical_MD_Req]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../technicalmd" \\im\\s_md_id] "[_ lorsm.Technical_MD]"] "[_ lorsm.Add_Requirement]"]
    set title "[_ lorsm.lt_Add_Technical_MD_Requ]"
}

# Form

ad_form -name technicalmd_req \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_te_rq_id:key(ims_md_technical_requirement_seq)

    {type_s:text,nospell
	{section "[_ lorsm.lt_AddEdit_Technical_MD__5]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }

    {type_v:text,nospell
        {html {size 20}}
	{help_text "[_ lorsm.Type_of_requirement]"}
        {label "[_ lorsm.Type_1]"}
    }
    
    {name_v:text,nospell
        {html {size 20}}
	{help_text "[_ lorsm.lt_Name_of_required_item]"}
        {label "[_ lorsm.Name_1]"}
    }
    
    {min_version:text,nospell
        {html {size 10}}
	{help_text "[_ lorsm.lt_Lowest_version_of_the]"}
        {label "[_ lorsm.Minimum_Version]"}
    }

    {max_version:text,nospell
        {html {size 10}}
	{help_text "[_ lorsm.lt_Highest_version_of_th]"}
        {label "[_ lorsm.Maximum_Version]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {
     select * from 
        ims_md_technical_requirement
    where
        ims_md_te_rq_id = :ims_md_te_rq_id and ims_md_id = :ims_md_id

} -edit_data {
    db_dml do_update "
            update ims_md_technical_requirement
            set type_v = :type_v, 
            type_s = :type_s,
            name_v = :name_v,
            name_s = :type_s,
            min_version = :min_version, 
            max_version = :max_version
            where ims_md_te_rq_id = :ims_md_te_rq_id"
            
} -new_data {
    db_dml do_insert "
            insert into ims_md_technical_requirement (ims_md_te_rq_id, ims_md_id, type_s, type_v, name_s, name_v, min_version, max_version)
            values (:ims_md_te_rq_id, :ims_md_id, :type_s, :type_v, :type_s, :name_v, :min_version, :max_version)"
   
} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Requirements
template::list::create \
    -name d_te_req \
    -multirow d_te_req \
    -no_data "No Requirements Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        type {
            label "[_ lorsm.Type]" 
        }
        name {
            label "[_ lorsm.Name]"
        }
	min_version {
	    label "[_ lorsm.Min_Version]"
	}
	max_version {
	    label "[_ lorsm.Max_Version]"
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "technical_req" {ims_md_te_rq_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record] "}
            html { align center }
        }
    }

db_multirow d_te_req select_te_req {
    select
        '[' || type_s || ']' || ' ' || type_v as type, 
        '[' || name_s || ']' || ' ' || name_v as name,
        min_version,
        max_version,
        ims_md_te_rq_id,
        ims_md_id
    from 
        ims_md_technical_requirement 
    where
        ims_md_id = :ims_md_id
}

