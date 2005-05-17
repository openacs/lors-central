# packages/lorsm/www/md/generalmd/general_lang.tcl

ad_page_contract {
    
    Add/Edit General MD Language
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_lang_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_lang_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Edit_Language]"]
    set title "[_ lorsm.lt_Edit_General_MD_Langu]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Add_Language]"]
    set title "[_ lorsm.lt_Add_General_MD_Langua]"
}

# Form

ad_form -name generalmd_lang \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_lang_id:key(ims_md_general_lang_seq)

    {language:text,nospell
	{section "[_ lorsm.lt_AddEdit_General_MD_La]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_lang where ims_md_ge_lang_id = :ims_md_ge_lang_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_lang
            set language = :language
            where ims_md_ge_lang_id = :ims_md_ge_lang_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_lang (ims_md_ge_lang_id, ims_md_id, language)
            values
            (:ims_md_ge_lang_id, :ims_md_id, :language)"

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Language
template::list::create \
    -name d_gen_lang \
    -multirow d_gen_lang \
    -no_data "[_ lorsm.lt_No_Language_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        language {
            label "[_ lorsm.Language_1]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_lang" {ims_md_ge_lang_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_gen_lang select_ge_lang {
    select language, 
           ims_md_ge_lang_id,
           ims_md_id
    from 
           ims_md_general_lang
    where
           ims_md_id = :ims_md_id
} 
