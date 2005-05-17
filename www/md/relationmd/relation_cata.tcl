# packages/lorsm/www/md/relationmd/relation_cata.tcl

ad_page_contract {
    
    Add/Edit Relation MD Resource Catalog-Entry
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_re_id:integer
    ims_md_re_re_id:integer
    ims_md_re_re_ca_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_re_re_ca_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../relationmd" ims_md_id] "[_ lorsm.Relation_MD]"] [list [export_vars -base "relation" {ims_md_id ims_md_re_id ims_md_re_re_id}] "[_ lorsm.Relation_Entry]"] "[_ lorsm.Edit_Catalog-Entry]"]
    set title "[_ lorsm.lt_Edit_Relation_MD_Reso]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../relationmd" ims_md_id] "[_ lorsm.Relation_MD]"] [list [export_vars -base "relation" {ims_md_id ims_md_re_id ims_md_re_re_id}] "[_ lorsm.Relation_Entry]"] "[_ lorsm.Add_Catalog-Entry]"]
    set title "[_ lorsm.lt_Add_Relation_MD_Resou]"
}

# Form

ad_form -name relationmd_cata \
    -cancel_url relation?ims_md_id=$ims_md_id&ims_md_re_id=$ims_md_re_id&ims_md_re_re_id=$ims_md_re_re_id \
    -mode edit \
    -form {

    ims_md_re_re_ca_id:key(ims_md_relation_resource_catalog_seq)

    {catalog:text,nospell
	{section "[_ lorsm.lt_AddEdit_Relation_MD_R]"}	
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
    
    {ims_md_re_re_id:text(hidden) {value $ims_md_re_re_id}
    } 

    {ims_md_re_id:text(hidden) {value $ims_md_re_id}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_relation_resource_catalog where ims_md_re_re_ca_id = :ims_md_re_re_ca_id and ims_md_re_re_id = :ims_md_re_re_id

} -edit_data {
        db_dml do_update "
            update ims_md_relation_resource_catalog
            set catalog = :catalog,
            entry_l = :entry_l,
            entry_s = :entry_s
            where ims_md_re_re_ca_id = :ims_md_re_re_ca_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_relation_resource_catalog (ims_md_re_re_ca_id, ims_md_re_re_id, catalog, entry_l, entry_s)
            values 
            (:ims_md_re_re_ca_id, :ims_md_re_re_id, :catalog, :entry_l, :entry_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "relation" {ims_md_re_id ims_md_re_re_id ims_md_id}]
        ad_script_abort
} 

# Relation Catalog-Entry
template::list::create \
    -name d_re_cata \
    -multirow d_re_cata \
    -no_data "[_ lorsm.lt_No_Catalog-Entries_Av]" \
    -html { align right style "width: 100%;" } \
    -elements {
	catalog {
	    label ""
	}
	entry_l {
	    label ""
	}
	entry_s {
	    label ""
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "relation_cata" {ims_md_re_re_ca_id ims_md_re_re_id ims_md_re_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_re_cata select_re_cata {
    select
    reca.catalog,
    reca.entry_l,
    reca.entry_s,
    reca.ims_md_re_re_ca_id,
    reca.ims_md_re_re_id,
    re.ims_md_id,
    re.ims_md_re_id
    from 
           ims_md_relation_resource_catalog reca,
           ims_md_relation re
    where
           reca.ims_md_re_re_id = :ims_md_re_re_id
    and
           re.ims_md_re_id = :ims_md_re_id
} 
