# packages/lorsm/www/md/technicalmd/technical_dur.tcl

ad_page_contract {
    
    Add/Edit Technical MD Duration
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../technicalmd" \\\i\\m\\s_md_id] "[_ lorsm.Technical_MD]"] "[_ lorsm.AddEdit_Duration]"]
set title "[_ lorsm.lt_Edit_Technical_MD_Dur]"

# Form

ad_form -name technicalmd_dur \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {duration:text,nospell
	{section "[_ lorsm.lt_AddEdit_Technical_MD_]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Time_the_continuous_l]"}
        {label "[_ lorsm.Duration] "}
    }

    {duration_l:text,nospell,optional
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }

    {duration_s:text,nospell,optional
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the tech duration details already exist...

    if {[db_0or1row select_duration {select ims_md_id from ims_md_technical where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_technical
            set duration_s = :duration_s,
            duration_l = :duration_l,
            duration = :duration
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_technical (ims_md_id, duration_l, duration_s)
            values
            (:ims_md_id, :duration_l, :duration_s)"
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Duration
template::list::create \
    -name d_te_dur \
    -multirow d_te_dur \
    -no_data "[_ lorsm.lt_No_Duration_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        duration_sec {
            label "[_ lorsm.Duration_Seconds]"
        }
	duration_l {
	    label "[_ lorsm.Language_1]"
	}
	duration_s {
	    label "[_ lorsm.Source_1]"
	}

    }

db_multirow d_te_dur select_te_dur {
    select 
        duration_l,
        duration_s,
        duration || 's' as duration_sec,
        ims_md_id
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 
