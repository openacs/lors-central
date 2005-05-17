# packages/lorsm/www/md/generalmd/general_struc.tcl

ad_page_contract {
    
    Add/Edit General MD Structure
    
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

set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\\\\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.Edit_Structure]"]
set title "[_ lorsm.lt_Edit_General_MD_Struc]"

# Form

ad_form -name generalmd_struc \
    -cancel_url [export_vars -base "../generalmd" ims_md_id] \
    -mode edit \
    -form {

    {structure_v:text
	{section "[_ lorsm.lt_AddEdit_General_MD_St]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Organizational_struct]"}
        {label "[_ lorsm.Structure]"}
    }
    
    {structure_s:text,nospell,optional
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the structure details already exist...

    if {[db_0or1row select_structure {select ims_md_id from ims_md_general where ims_md_id = :ims_md_id}]} {

	db_dml do_update "
            update ims_md_general
            set structure_v = :structure_v, structure_s = :structure_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_general (ims_md_id, structure_v, structure_s)
            values
            (:ims_md_id, :structure_v, :structure_s)"

    }

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Structure
template::list::create \
    -name d_gen_struc \
    -multirow d_gen_struc \
    -no_data "[_ lorsm.lt_No_Structure_Availabl]" \
    -html { align right style "width: 100%;" } \
    -elements {
        structure_s {
            label "[_ lorsm.Source_1]"
	    html {align center}
        }
        structure_v {
            label "[_ lorsm.Value]"
	    html {align center}
        }
    }

db_multirow d_gen_struc select_ge_struc {
    select structure_s,
           structure_v, 
           ims_md_id
    from 
           ims_md_general
    where
           ims_md_id = :ims_md_id
}

