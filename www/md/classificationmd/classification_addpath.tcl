# packages/lorsm/www/md/classificationmd/classification_addpath.tcl

ad_page_contract {
    
    Add Classification MD Taxonomic Path Entry
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../classificationmd" ims_md_id] "[_ lorsm.Classification_MD]"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] "[_ lorsm.Classification_Entry]"] "[_ lorsm.lt_Add_Taxonomic_Path_En]"]
set title "[_ lorsm.lt_Add_Classification_MD_1]"

# Form
ad_form -name classificationmd_addpath \
    -cancel_url classification?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id \
    -mode edit \
    -form {

    ims_md_cl_ta_id:key(ims_md_classification_taxpath_seq)
    
    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -new_data {
        db_dml do_insert "
            insert into ims_md_classification_taxpath (ims_md_cl_ta_id, ims_md_cl_id) 
            values (:ims_md_cl_ta_id, :ims_md_cl_id)"

} -after_submit {
    ad_returnredirect [export_vars -base "classification" {ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

