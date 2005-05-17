# packages/lorsm/www/md/educationalmd/educational_cont.tcl

ad_page_contract {
    
    Add/Edit Educational MD Context
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_co_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_co_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" im\s_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.Edit_Context]"]
    set title "[_ lorsm.lt_Edit_Educational_MD_C]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" im\s_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.Add_Context]"]
    set title "[_ lorsm.lt_Add_Educational_MD_Co]"
}

# Form

ad_form -name educationalmd_cont \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_co_id:key(ims_md_educational_context_seq)

    {context_s:text,nospell
	{section "[_ lorsm.lt_AddEdit_Educational_M_11]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }

    {context_v:text,nospell
        {html {size 20}}
	{help_text "[_ lorsm.lt_Learning_environment_]"}
        {label "[_ lorsm.Context]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_context where ims_md_ed_co_id = :ims_md_ed_co_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_context
            set context_s = :context_s,
            context_v = :context_v
            where ims_md_ed_co_id = :ims_md_ed_co_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_context (ims_md_ed_co_id, ims_md_id, context_s, context_v) 
            values (:ims_md_ed_co_id, :ims_md_id, :context_s, :context_v)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Context
template::list::create \
    -name d_ed_cont \
    -multirow d_ed_cont \
    -no_data "[_ lorsm.No_Context_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
	context {
            label "[_ lorsm.Context_1]"
        }
        export {
            display_eval {\[[_ lorsm.Edit_1]\]}
            link_url_eval { [export_vars -base "educational_cont" {ims_md_ed_co_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_ed_cont select_ed_cont {
    select 
        '[' || context_s || '] ' || context_v as context,
        ims_md_ed_co_id,
        ims_md_id
    from 
           ims_md_educational_context
    where
           ims_md_id = :ims_md_id
} 
