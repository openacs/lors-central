# packages/lors-central/www/md/pbs-md/pbsmd_grade.tcl

ad_page_contract {
    
    Add/Edit PBS Grade Range MD
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2005-04-03
    @arch-tag: 6d6ac4ab-a0d4-4610-9175-335981940c33
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
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  [list [export_vars -base "pbs-md" im\s_md_id] "PBS Metadata"] "Edit Grade Range"]
    set title "Edit Grade Range"
} else {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  [list [export_vars -base "pbs-md" ims_md_id] "PBS Metadata"] "Add Grade Range"]
    set title "Add Grade Range"
}

# Form

ad_form -name educationalmd_cont \
    -cancel_url pbs-md?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_co_id:key(ims_md_educational_context_seq)

    {context_s:text,nospell
	{section "Add/Edit Grade Range"}
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
    ad_returnredirect [export_vars -base "pbs-md" {ims_md_id}]
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
            link_url_eval { [export_vars -base "pbsmd_grade" {ims_md_ed_co_id ims_md_id}] }
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

