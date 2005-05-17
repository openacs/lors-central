# packages/lors-central/www/md/pbs-md/pbsmd_restype.tcl

ad_page_contract {
    
    Add/Edit PBS Resource Type MD
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2005-04-03
    @arch-tag: b18e4129-8f95-4a73-b6ec-50f67c96ee3c
    @cvs-id $Id$
} {
    ims_md_id:integer
    ims_md_ed_lr_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_lr_id]} {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  [list [export_vars -base "pbs-md" ims_md_id] "PBS Metadata"] "Add PBS Resource Type"]
    set title "Edit PBS Resource Type"
} else {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor "]  [list [export_vars -base "pbs-md" ims_md_id] "PBS Metadata"] "Add PBS Resource Type"]
    set title "Add PBS Resource Type"
}

# Form

ad_form -name educationalmd_lrt \
    -cancel_url pbs-md?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_lr_id:key(ims_md_educational_lrt_seq)

    {lrt_s:text,nospell
	{section "Add/Edit PBS Resource Type"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }

    {lrt_v:text,nospell
        {html {size 10}}
	{help_text "[_ lorsm.lt_Type_of_interactivity]"}
        {label "[_ lorsm.lt_Learning_Resource_Typ]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_lrt where ims_md_ed_lr_id = :ims_md_ed_lr_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_lrt
            set lrt_s = :lrt_s,
            lrt_v = :lrt_v
            where ims_md_ed_lr_id = :ims_md_ed_lr_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_lrt (ims_md_ed_lr_id, ims_md_id, lrt_s, lrt_v) 
            values (:ims_md_ed_lr_id, :ims_md_id, :lrt_s, :lrt_v)"
} -after_submit {
    ad_returnredirect [export_vars -base "pbs-md" {ims_md_id}]
        ad_script_abort
} 

# Educational Learning Resource Type
template::list::create \
    -name d_ed_lrt \
    -multirow d_ed_lrt \
    -no_data "[_ lorsm.lt_No_Learning_Resource_]" \
    -html { align right style "width: 100%;" } \
    -elements {
	lrt {
            label ""
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "pbsmd_restype" {ims_md_ed_lr_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_ed_lrt select_ed_lrt {
    select 
        '[' || lrt_s || '] ' || lrt_v as lrt,
        ims_md_ed_lr_id,
        ims_md_id
    from 
           ims_md_educational_lrt
    where
           ims_md_id = :ims_md_id
} 
