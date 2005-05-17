# packages/lorsm/www/md/relationmd/relation_add.tcl

ad_page_contract {
    
    Add/Edit Relation MD Entry
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../relationmd" ims_md_id] "[_ lorsm.Relation_MD]"] "[_ lorsm.Add_Relation_Entry]"]
set title "[_ lorsm.lt_Add_Relation_MD_Entry]"

# Form
ad_form -name relationmd_add \
    -cancel_url ../relationmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_re_id:key(ims_md_relation_seq)

    {ims_md_id:text(hidden) {value $ims_md_id}} 

} -new_data {
    db_transaction {
        db_dml do_insert_relation "
            insert into ims_md_relation (ims_md_re_id, ims_md_id) 
            values (:ims_md_re_id, :ims_md_id)"

	db_dml do_insert_resource "
            insert into ims_md_relation_resource (ims_md_re_re_id, ims_md_re_id)
            values (nextval('ims_md_relation_resource_seq'), :ims_md_re_id)"
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../relationmd" {ims_md_id}]
        ad_script_abort
} 

