# packages/lorsm/www/md/generalmd/general_aggl.tcl

ad_page_contract {
    
    Add/Edit General MD Aggregation Level
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../generalmd" im\\\\\s_md_id] "[_ lorsm.General_MD]"] "[_ lorsm.lt_Edit_Aggregation_Leve]"]
set title "[_ lorsm.lt_Edit_General_MD_Aggre]"

# Form

ad_form -name generalmd_aggl \
    -cancel_url ../generalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {



    {agg_level_v:text,nospell
	{section "[_ lorsm.lt_AddEdit_General_MD_Ag]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Functional_size_of_th]"}
        {label "[_ lorsm.Aggregation_Level]"}
    }
    
    {agg_level_s:text,nospell,optional
        {html {size 10}}
	{help_text "[_ lorsm.lt_Source_of_vocabulary_]"}
        {label "[_ lorsm.Source]"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the aggregation level already exist..

    if {[db_0or1row select_aggregation_level {select ims_md_id from ims_md_general where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_general
            set agg_level_v = :agg_level_v, agg_level_s = :agg_level_s
            where ims_md_id = :ims_md_id "

    } else {

        db_dml do_insert "
            insert into ims_md_general (ims_md_id, agg_level_v, agg_level_s)
            values
            (:ims_md_id, :agg_level_v, :agg_level_s)"

    }

} -after_submit {
    ad_returnredirect [export_vars -base "../generalmd" {ims_md_id}]
        ad_script_abort
} 

# General Aggregation Level
template::list::create \
    -name d_gen_aggl \
    -multirow d_gen_aggl \
    -no_data "[_ lorsm.lt_No_Aggregation_Level__1]" \
    -html { align right style "width: 100%;" } \
    -elements {
        agg_level_s {
            label "[_ lorsm.Source_1]" 
        }
        agg_level_v {
            label "[_ lorsm.Value]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "general_aggl" {ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record] "}
            html { align center }
        }
    }

db_multirow d_gen_aggl select_ge_aggl {
    select agg_level_s,
           agg_level_v, 
           ims_md_id
    from 
           ims_md_general
    where
           ims_md_id = :ims_md_id
}

