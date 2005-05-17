# packages/lorsm/www/md/classificationmd/classification_tsource.tcl

ad_page_contract {
    
    Add/Edit Classification MD Taxonomic Path Source
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_ta_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title

set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../classificationmd" ims_md_id] "[_ lorsm.Classification_MD]"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "[_ lorsm.Classification_Entry]"] [list [export_vars -base "classification_tpath" {ims_md_id ims_md_cl_id ims_md_cl_ta_id}] "[_ lorsm.Taxonomic_Paths_1]"] "[_ lorsm.AddEdit_Source]"]

set title "[_ lorsm.lt_Edit_Classification_M_3]"


# Form

ad_form -name classificationmd_tsource \
    -cancel_url classification_tpath?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id&ims_md_cl_ta_id=$ims_md_cl_ta_id \
    -mode edit \
    -form {

    ims_md_cl_ta_id:key(ims_md_classification_taxpath_seq)

    {source_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Classificatio_9]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }
    
    {source_v:text,nospell
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }
    
    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -select_query  {select * from ims_md_classification_taxpath where ims_md_cl_ta_id = :ims_md_cl_ta_id and ims_md_cl_id = :ims_md_cl_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification_taxpath
            set source_l = :source_l,
            source_v = :source_v
            where ims_md_cl_ta_id = :ims_md_cl_ta_id"

} -after_submit {
    ad_returnredirect [export_vars -base "classification_tpath" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Taxonomic Path Source
template::list::create \
    -name d_cl_tsource \
    -multirow d_cl_tsource \
    -no_data "[_ lorsm.lt_No_Taxonomic_Path_Sou]" \
    -html { align right style "width: 100%;" } \
    -elements {
	source {
            label ""
        }
        export {
            display_eval {\[[_ lorsm.Edit_1]\]}
            link_url_eval { [export_vars -base "classification_tsource" {ims_md_cl_ta_id ims_md_cl_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_cl_tsource select_cl_tsource {
   select
    '[' || ctp.source_l || '] ' || ctp.source_v as source,
    ctp.ims_md_cl_ta_id,
    ctp.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_taxpath ctp,
           ims_md_classification cl
    where
           ctp.ims_md_cl_ta_id = :ims_md_cl_ta_id
    and    cl.ims_md_cl_id = :ims_md_cl_id
} 
