# packages/lorsm/www/md/educationalmd/educational_intl.tcl

ad_page_contract {
    
    Add/Edit Educational MD Interactivity Level
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" \im\\\s_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.lt_AddEdit_Interactivity]"]

set title "[_ lorsm.lt_Edit_Educational_MD_I_1]"

# Form

ad_form -name educationalmd_intl \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {int_level_s:text,nospell
	{section "[_ lorsm.lt_AddEdit_Educational_M_15]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }

    {int_level_v:text,nospell
        {html {size 10}}
	{help_text "[_ lorsm.lt_Level_of_interactivit]"}
        {label "[_ lorsm.Interactivity_Level]"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the ED Interactivity Level already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_educational where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_educational
            set int_level_s = :int_level_s, int_level_v = :int_level_v
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_educational (ims_md_id, int_level_s, int_level_v)
            values
            (:ims_md_id, :int_level_s, :int_level_v) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Interactivity Level
template::list::create \
    -name d_ed_intl \
    -multirow d_ed_intl \
    -no_data "[_ lorsm.lt_No_Interactivity_Leve]" \
    -html { align right style "width: 100%;" } \
    -elements {
	intl {
            label "[_ lorsm.Interactivity_Level_1]"
        }
    }

db_multirow d_ed_intl select_ed_intl {
    select 
        '[' || int_level_s || '] ' || int_level_v as intl,
        ims_md_id
    from 
           ims_md_educational
    where
           ims_md_id = :ims_md_id
} 
