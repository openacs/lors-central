# packages/lorsm/www/md/educationalmd/educational_desc.tcl

ad_page_contract {
    
    Add/Edit Educational MD Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_de_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_de_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" ims_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.Edit_Description]"]
    set title "[_ lorsm.lt_Edit_Educational_MD_D]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" ims_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.Add_Description]"]
    set title "[_ lorsm.lt_Add_Educational_MD_De]"
}

# Form

ad_form -name educationalmd_desc \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_de_id:key(ims_md_educational_descrip_seq)

    {descrip_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Educational_M_12]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }

    {descrip_s:text(textarea),nospell
        {html {rows 2 cols 50}}
	{help_text "[_ lorsm.lt_How_the_learning_obje]"}
        {label "[_ lorsm.Description]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_descrip where ims_md_ed_de_id = :ims_md_ed_de_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_descrip
            set descrip_l = :descrip_l,
            descrip_s = :descrip_s
            where ims_md_ed_de_id = :ims_md_ed_de_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_descrip (ims_md_ed_de_id, ims_md_id, descrip_l, descrip_s) 
            values (:ims_md_ed_de_id, :ims_md_id, :descrip_l, :descrip_s)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Description
template::list::create \
    -name d_ed_desc \
    -multirow d_ed_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -html { align right style "width: 100%;" } \
    -elements {
	desc {
            label "[_ lorsm.Description_1]"
        }
        export {
            display_eval {\[[_ lorsm.Edit_1]\]}
            link_url_eval { [export_vars -base "educational_desc" {ims_md_ed_de_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_ed_desc select_ed_desc {
    select 
        '[' || descrip_l || '] ' || descrip_s as desc,
        ims_md_ed_de_id,
        ims_md_id
    from 
           ims_md_educational_descrip
    where
           ims_md_id = :ims_md_id
} 
