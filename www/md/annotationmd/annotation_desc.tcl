# packages/lorsm/www/md/annotationmd/annotation_desc.tcl

ad_page_contract {
    
    Add/Edit Annotation MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_an_id:integer
    ims_md_an_de_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_an_de_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../annotationmd" ims_md_id] "[_ lorsm.Annotation_MD]"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "[_ lorsm.Annotation_Entry]"] "[_ lorsm.Edit_Description]"]
    set title "Edit Annotation MD Description"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../annotationmd" ims_md_id] "[_ lorsm.Annotation_MD]"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "[_ lorsm.Annotation_Entry]"] "[_ lorsm.Add_Description]"]
    set title "[_ lorsm.lt_Add_Annotation_MD_Des]"
}

# Form

ad_form -name annotationmd_desc \
    -cancel_url annotation?ims_md_id=$ims_md_id&ims_md_an_id=$ims_md_an_id \
    -mode edit \
    -form {

    ims_md_an_de_id:key(ims_md_annotation_descrip_seq)

    {descrip_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Annotation_MD]"}	
	{html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
	{label "[_ lorsm.Language]"}
    }

    {descrip_s:text(textarea),nospell	
	{html {rows 2 cols 50}}
	{help_text "[_ lorsm.lt_Content_of_the_annota]"}
	{label "[_ lorsm.Description]"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

    {ims_md_an_id:text(hidden) {value $ims_md_an_id}
    }

} -select_query  {select * from ims_md_annotation_descrip where ims_md_an_de_id = :ims_md_an_de_id and ims_md_an_id = :ims_md_an_id

} -edit_data {
        db_dml do_update "
            update ims_md_annotation_descrip
            set descrip_l = :descrip_l,
            descrip_s = :descrip_s
            where ims_md_an_de_id = :ims_md_an_de_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_annotation_descrip (ims_md_an_de_id, ims_md_an_id, descrip_l, descrip_s)
            values 
            (:ims_md_an_de_id, :ims_md_an_id, :descrip_l, :descrip_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "annotation" {ims_md_an_id ims_md_id}]
        ad_script_abort
} 

# Annotation Description
template::list::create \
    -name d_an_desc \
    -multirow d_an_desc \
    -no_data "No Description Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	desc {
	    label ""
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "annotation_desc" {ims_md_an_de_id ims_md_an_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_an_desc select_an_desc {
    select
    '[' || ande.descrip_l || '] ' || ande.descrip_s as desc,
    ande.ims_md_an_de_id,
    an.ims_md_an_id,
    an.ims_md_id
    from 
           ims_md_annotation_descrip ande,
           ims_md_annotation an
    where
           ande.ims_md_an_id = an.ims_md_an_id
    and
           ande.ims_md_an_id = :ims_md_an_id
} 
