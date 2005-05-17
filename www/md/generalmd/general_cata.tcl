# packages/lorsm/www/md/generalmd/general_cata.tcl

ad_page_contract {
    
    Add/Edit General MD Catalog-Entry
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_cata_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_cata_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Edit_Catalog-Entry]"]
    set title "[_ lorsm.lt_Edit_General_MD_Catal]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Add_Catalog-Entry]"]
    set title "[_ lorsm.lt_Add_General_MD_Catalo]"
}

# Form

ad_form -name generalmd_cata \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_cata_id:key(ims_md_general_cata_seq)

    {catalog:text,nospell
	{section "[_ lorsm.lt_AddEdit_General_MD_Ca]"}
	{html {size 50}}
	{help_text "[_ lorsm.Name_of_the_catalog]"}
	{label "[_ lorsm.Catalog]"}
    }

    {entry_l:text,nospell,optional
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }
    
    {entry_s:text,nospell
        {html {size 50}}
	{help_text "[_ lorsm.lt_Number_in_the_Catalog]"}
        {label "[_ lorsm.Entry]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_cata where ims_md_ge_cata_id = :ims_md_ge_cata_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_cata
            set catalog = :catalog, entry_l = :entry_l, entry_s = :entry_s
            where ims_md_ge_cata_id = :ims_md_ge_cata_id"
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_cata (ims_md_ge_cata_id, ims_md_id, catalog, entry_l, entry_s)
            values
            (:ims_md_ge_cata_id, :ims_md_id, :catalog, :entry_l, :entry_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Catalog-entry
template::list::create \
    -name d_gen_cata \
    -multirow d_gen_cata \
    -no_data "[_ lorsm.lt_No_Catalog_Entry_Avai]" \
    -html { align right style "width: 100%;" } \
    -elements {
	catalog {
	    label "[_ lorsm.Catalog_1]"
	}
        entry_l {
            label "[_ lorsm.Language_1]"
        }
        entry_s {
            label "[_ lorsm.Entry_1]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_cata" {ims_md_ge_cata_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_gen_cata select_ge_cata {
    select catalog,
           entry_l,
           entry_s, 
           ims_md_ge_cata_id,
           ims_md_id
    from 
           ims_md_general_cata
    where
           ims_md_id = :ims_md_id
} 

