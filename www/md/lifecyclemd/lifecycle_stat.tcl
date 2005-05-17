# packages/lorsm/www/md/lifecyclemd/lifecycle_stat.tcl

ad_page_contract {
    
    Add/Edit Lifecycle MD Status
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../lifecyclemd" im\\\\\\\s_md_id] "[_ lorsm.Life_Cycle_MD]"] "[_ lorsm.Edit_Status]"]
set title "[_ lorsm.lt_Edit_Lifecycle_MD_Sta]"

# Form

ad_form -name lifecyclemd_stat \
    -cancel_url ../lifecyclemd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {status_v:text,nospell
	{section "[_ lorsm.lt_AddEdit_Lifecycle_MD__1]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Learning_objects_edit]"}
        {label "[_ lorsm.Status]"}
    }
    
    {status_s:text,nospell,optional
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # Checks whether LC status exist...

    if {[db_0or1row select_lc_version {select ims_md_id from ims_md_life_cycle where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_life_cycle
            set status_s = :status_s, status_v = :status_v
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_life_cycle (ims_md_id, status_s, status_v)
            values
            (:ims_md_id, :status_s, :status_v)"

    }

} -after_submit {
    ad_returnredirect [export_vars -base "../lifecyclemd" {ims_md_id}]
        ad_script_abort
} 

# Lifecycle Status
template::list::create \
    -name d_lf_stat \
    -multirow d_lf_stat \
    -no_data "[_ lorsm.No_Status_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        status_s {
            label "[_ lorsm.Source_1]"
        }
        status_v {
            label "[_ lorsm.Value]" 
        }
    }

db_multirow d_lf_stat select_lf_stat {
    select status_s,
           status_v, 
           ims_md_id
    from 
           ims_md_life_cycle
    where
           ims_md_id = :ims_md_id
}

