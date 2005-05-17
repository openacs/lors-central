# packages/lorsm/www/md/generalmd/general_cover.tcl

ad_page_contract {
    
    Add/Edit General MD Coverage
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_cove_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_cove_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\\\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Edit_Coverage]"]
    set title "[_ lorsm.lt_Edit_General_MD_Cover]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\\\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Add_Coverage]"]
    set title "[_ lorsm.lt_Add_General_MD_Covera]"
}

# Form

ad_form -name generalmd_cover \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_cove_id:key(ims_md_general_cover_seq)

    {cover_l:text,nospell,optional
	{section "[_ lorsm.lt_AddEdit_General_MD_Co]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }
    
    {cover_s:text,nospell
        {html {size 50}}
	{help_text "[_ lorsm.lt_Temporalspatial_chara]"}
        {label "[_ lorsm.Coverage]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_cover where ims_md_ge_cove_id = :ims_md_ge_cove_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_cover
            set cover_l = :cover_l, cover_s = :cover_s
            where ims_md_ge_cove_id = :ims_md_ge_cove_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_cover (ims_md_ge_cove_id, ims_md_id, cover_l, cover_s)
            values
            (:ims_md_ge_cove_id, :ims_md_id, :cover_l, :cover_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Coverage
template::list::create \
    -name d_gen_cover \
    -multirow d_gen_cover \
    -no_data "[_ lorsm.lt_No_Coverage_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        cover_l {
            label "[_ lorsm.Language_1]"
        }
        cover_s {
            label "[_ lorsm.Coverage_1]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_cover" {ims_md_ge_cove_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_gen_cover select_ge_cover {
    select cover_l,
           cover_s, 
           ims_md_ge_cove_id,
           ims_md_id
    from 
           ims_md_general_cover
    where
           ims_md_id = :ims_md_id
}
