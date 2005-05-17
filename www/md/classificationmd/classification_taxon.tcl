# packages/lorsm/www/md/classificationmd/classification_taxon.tcl

ad_page_contract {
    
    Add/Edit Classification MD Taxonomic Path Taxonomy
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_ta_id:integer
    ims_md_cl_ta_ta_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_cl_ta_ta_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../classificationmd" ims_md_id] "[_ lorsm.Classification_MD]"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "[_ lorsm.Classification_Entry]"] [list [export_vars -base "classification_tpath" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "[_ lorsm.Taxonomic_Paths_2]"] "[_ lorsm.Edit_Taxonomy]"]
    set title "[_ lorsm.lt_Edit_Classification_M_2]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../classificationmd" ims_md_id] "[_ lorsm.Classification_MD]"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "[_ lorsm.lt_Classification_Entry_]"] "[_ lorsm.Add_Taxonomy]"]
    set title "[_ lorsm.lt_Add_Classification_MD_4]"
}

# Form

ad_form -name classificationmd_taxon \
    -cancel_url classification_tpath?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id&ims_md_cl_ta_id=$ims_md_cl_ta_id \
    -mode edit \
    -form {

    ims_md_cl_ta_ta_id:key(ims_md_classification_taxpath_taxon_seq)

    {identifier:text,nospell
	{section "[_ lorsm.lt_AddEdit_Classificatio_8]"}	
	{html {size 50}}
	{help_text "[_ lorsm.lt_Taxons_identifier_in_]"}
	{label "[_ lorsm.Identifier]"}
    }

    {entry_l:text,nospell	
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

    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

    {ims_md_cl_ta_id:text(hidden) {value $ims_md_cl_ta_id}
    }

} -select_query  {select * from ims_md_classification_taxpath_taxon where ims_md_cl_ta_ta_id = :ims_md_cl_ta_ta_id and ims_md_cl_ta_id = :ims_md_cl_ta_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification_taxpath_taxon
            set identifier = :identifier,
            entry_l = :entry_l,
            entry_s = :entry_s
            where ims_md_cl_ta_ta_id = :ims_md_cl_ta_ta_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_classification_taxpath_taxon (ims_md_cl_ta_ta_id, ims_md_cl_ta_id, identifier, entry_l, entry_s)
            values 
            (:ims_md_cl_ta_ta_id, :ims_md_cl_ta_id, :identifier, :entry_l, :entry_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "classification_tpath" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Taxonomic Path Taxonomy
template::list::create \
    -name d_cl_taxon \
    -multirow d_cl_taxon \
    -no_data "[_ lorsm.lt_No_Taxonomies_Availab]" \
    -html { align right style "width: 100%;" } \
    -elements {
	identifier {
	    label "[_ lorsm.ID]"
	}
	entry {
	    label "[_ lorsm.Entry_1]"
	}
        export {
            display_eval {\[[_ lorsm.Edit_1]\]}
            link_url_eval { [export_vars -base "classification_taxon" {ims_md_cl_ta_ta_id ims_md_cl_ta_id ims_md_cl_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_cl_taxon select_cl_taxon {
    select ctt.identifier,
    '[' || ctt.entry_l || '] ' || ctt.entry_s as entry,
    ctt.ims_md_cl_ta_id,
    ctt.ims_md_cl_ta_ta_id,
    cl.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_taxpath_taxon ctt,
           ims_md_classification cl
    where
           ctt.ims_md_cl_ta_id = :ims_md_cl_ta_id
    and
           cl.ims_md_cl_id = :ims_md_cl_id
} 
