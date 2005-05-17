# packages/lorsm/www/md/generalmd/general_desc.tcl

ad_page_contract {
    
    Add/Edit General MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_desc_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_desc_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" ims_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Edit_Description]"]
    set title "[_ lorsm.lt_Edit_General_MD_Descr]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" ims_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Add_Description]"]
    set title "[_ lorsm.lt_Add_General_MD_Descri]"
}

# Form

ad_form -name generalmd_desc \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_desc_id:key(ims_md_general_desc_seq)

    {descrip_l:text,nospell,optional
	{section "[_ lorsm.lt_AddEdit_General_MD_De]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }

    {descrip_s:text(textarea),nospell
        {html {rows 5 cols 50}}
	{help_text "[_ lorsm.lt_Describes_learning_ob]"}
        {label "[_ lorsm.Description]"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_desc where ims_md_ge_desc_id = :ims_md_ge_desc_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_desc
            set descrip_l = :descrip_l, descrip_s = :descrip_s
            where ims_md_ge_desc_id = :ims_md_ge_desc_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_desc (ims_md_ge_desc_id, ims_md_id, descrip_l, descrip_s)
            values
            (:ims_md_ge_desc_id, :ims_md_id, :descrip_l, :descrip_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Language
template::list::create \
    -name d_gen_desc \
    -multirow d_gen_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip_l {
            label "[_ lorsm.Language_1]"
        }
	descrip_s {
	    label "[_ lorsm.Description_1]"
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_desc" {ims_md_ge_desc_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record] "}
            html { align center }
        }
    }

db_multirow d_gen_desc select_ge_desc {
    select descrip_l,
           descrip_s,
           ims_md_ge_desc_id,
           ims_md_id
    from 
           ims_md_general_desc
    where
           ims_md_id = :ims_md_id
} 
