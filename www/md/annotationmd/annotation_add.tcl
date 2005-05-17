# packages/lorsm/www/md/annotationmd/annotation_add.tcl

ad_page_contract {
    
    Add/Edit Annotation MD Entry
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../annotationmd" ims_md_id] "[_ lorsm.Annotation_MD]"] "[_ lorsm.Annotation_Entry]"]
set title "[_ lorsm.lt_Add_Annotation_MD_Ent]"

# Form
ad_form -name annotationmd_add \
    -cancel_url ../annotationmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_an_id:key(ims_md_annotation_seq)

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -new_data {
        db_dml do_insert "
            insert into ims_md_annotation (ims_md_an_id, ims_md_id) 
            values (:ims_md_an_id, :ims_md_id)"

} -after_submit {
    ad_returnredirect [export_vars -base "../annotationmd" {ims_md_id}]
        ad_script_abort
} 

