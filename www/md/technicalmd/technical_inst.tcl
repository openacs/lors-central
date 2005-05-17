# packages/lorsm/www/md/technicalmd/technical_inst.tcl

ad_page_contract {
    
    Add/Edit Technical MD Installation Remarks
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../technicalmd" \\\im\\s_md_id] "[_ lorsm.Technical_MD]"] "[_ lorsm.lt_Edit_Installation_Rem]"]
set title "[_ lorsm.lt_AddEdit_Technical_MD__2]"

# Form

ad_form -name technicalmd_inst \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {instl_rmrks_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Technical_MD__2]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }

    {instl_rmrks_s:text(textarea),nospell
        {html {rows 5 cols 60}}
	{help_text "[_ lorsm.lt_Information_on_how_to]"}
        {label "[_ lorsm.Installation_Remarks]"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}    

} -on_submit {
    # check if the tech size details already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_technical where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_technical
            set instl_rmrks_l = :instl_rmrks_l,
            instl_rmrks_s = :instl_rmrks_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_technical (ims_md_id, instl_rmrks_l, instl_rmrks_s)
            values
            (:ims_md_id, :instl_rmrks_l, :instl_rmrks_s) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Installation Remarks
template::list::create \
    -name d_te_inst \
    -multirow d_te_inst \
    -no_data "[_ lorsm.lt_No_Installation_Remar]" \
    -html { align right style "width: 100%;" } \
    -elements {
        instl_rmrks {
            label "[_ lorsm.Installation_Remarks_1]"
        }
    }

db_multirow d_te_inst select_te_inst {
    select 
        '[' || instl_rmrks_l || ']' || ' ' || instl_rmrks_s as instl_rmrks,
        ims_md_id
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 
