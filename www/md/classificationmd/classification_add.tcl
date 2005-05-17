# packages/lorsm/www/md/classificationmd/classification_add.tcl

ad_page_contract {
    
    Add Classification MD Entry
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @creation-date 16 October 2004

} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list "[_ lorsm.lt_IMS_Metadata_Editor_-]"]
set title "[_ lorsm.lt_Add_Classification_MD]"

# Form
ad_form -name classificationmd_add \
    -cancel_url ../classificationmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_cl_id:key(ims_md_classification_seq)

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -new_data {
        db_dml do_insert "
            insert into ims_md_classification (ims_md_cl_id, ims_md_id) 
            values (:ims_md_cl_id, :ims_md_id)"

} -after_submit {
    ad_returnredirect [export_vars -base "../classificationmd" {ims_md_id}]
        ad_script_abort
} 

