# packages/lorsm/www/md/educationalmd/educational_lrt.tcl

ad_page_contract {
    
    Add/Edit Educational MD Learning Resource Type
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @creation-date 16 October 2004

} {
    ims_md_id:integer
    ims_md_ed_lr_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_lr_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" \i\m\\\s_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.lt_Edit_Learning_Resourc]"]
    set title "[_ lorsm.lt_Edit_Educational_MD_L_1]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor] "]  [list [export_vars -base "../educationalmd" \i\m\\\s_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.lt_Add_Learning_Resource]"]
    set title "[_ lorsm.lt_Add_Educational_MD_Le]"
}

# Form

ad_form -name educationalmd_lrt \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_lr_id:key(ims_md_educational_lrt_seq)

    {lrt_s:text,nospell
	{section "[_ lorsm.lt_AddEdit_Educational_M_18]"}
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
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
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
            link_url_eval { [export_vars -base "educational_lrt" {ims_md_ed_lr_id ims_md_id}] }
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
