# packages/lorsm/www/md/annotationmd/relation_desc.tcl

ad_page_contract {
    
    Add/Edit Relation MD Resource Description
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_re_id:integer
    ims_md_re_re_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../relationmd" ims_md_id] "[_ lorsm.Relation_MD]"] [list [export_vars -base "relation" {ims_md_id ims_md_re_id ims_md_re_re_id}] "[_ lorsm.Relation_Entry]"] "[_ lorsm.AddEdit_Description]"]
set title "[_ lorsm.lt_Edit_Relation_MD_Reso_1]"

# Form

ad_form -name relationmd_desc \
    -cancel_url relation?ims_md_id=$ims_md_id&ims_md_re_id=$ims_md_re_id&ims_md_re_re_id=$ims_md_re_re_id \
    -mode edit \
    -form {

    ims_md_re_re_id:key(ims_md_relation_resource_seq)

    {descrip_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Relation_MD_R_1]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }
    
    {descrip_s:text(textarea),nospell
        {html {rows 2 cols 50}}
	{help_text "[_ lorsm.lt_Description_of_the_ot]"}
        {label "[_ lorsm.Description]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

    {ims_md_re_id:text(hidden) {value $ims_md_re_id}
    }

} -select_query  {select * from ims_md_relation_resource where ims_md_re_re_id = :ims_md_re_re_id and ims_md_re_id = :ims_md_re_id

} -edit_data {
        db_dml do_update "
            update ims_md_relation_resource
            set descrip_l = :descrip_l,
            descrip_s = :descrip_s
            where ims_md_re_re_id = :ims_md_re_re_id "

} -after_submit {
    ad_returnredirect [export_vars -base "relation" {ims_md_re_re_id ims_md_re_id ims_md_id}]
        ad_script_abort
} 

# Relation Description
template::list::create \
    -name d_re_desc \
    -multirow d_re_desc \
    -no_data "[_ lorsm.lt_No_Resource_Descripti]" \
    -html { align right style "width: 100%;" } \
    -elements {
	descrip {
            label "[_ lorsm.Description_1]"
        }
    }

db_multirow d_re_desc select_re_desc {
   select  '[' || rere.descrip_l || ']' || ' ' || rere.descrip_s as descrip,
           rere.ims_md_re_re_id,
           re.ims_md_re_id,
           re.ims_md_id
    from 
           ims_md_relation_resource rere,
           ims_md_relation re
    where
           rere.ims_md_re_id = :ims_md_re_id
    and    re.ims_md_re_id = :ims_md_re_id
} 
