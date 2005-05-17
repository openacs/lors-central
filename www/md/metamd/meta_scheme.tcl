# packages/lorsm/www/md/metamd/meta_scheme.tcl

ad_page_contract {
    
    Add/Edit Meta MD Language
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_md_sch_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_md_sch_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../metamd" im\s_\\md_id] "[_ lorsm.Meta_Metadata]"] "[_ lorsm.Edit_Scheme]"]
    set title "[_ lorsm.Edit_Meta_MD_Scheme]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../metamd" im\s_\\md_id] "[_ lorsm.Meta_Metadata]"] "[_ lorsm.Add_Scheme]"]
    set title "[_ lorsm.Add_Meta_MD_Scheme]"
}

# Form

ad_form -name metamd_scheme \
    -cancel_url ../metamd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_md_sch_id:key(ims_md_metadata_scheme_seq)

    {scheme:text,nospell
	{section "[_ lorsm.lt_AddEdit_Meta_MD_Schem]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Structure_of_meta-dat]"}
        {label "[_ lorsm.Scheme]"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}
    }


} -select_query  {select * from ims_md_metadata_scheme where ims_md_md_sch_id = :ims_md_md_sch_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_metadata_scheme
            set scheme = :scheme
            where ims_md_md_sch_id = :ims_md_md_sch_id "

} -new_data {
        db_dml do_insert "
            insert into ims_md_metadata_scheme (ims_md_md_sch_id, ims_md_id, scheme)
            values
            (:ims_md_md_sch_id, :ims_md_id, :scheme)"


} -after_submit {
    ad_returnredirect [export_vars -base "../metamd" {ims_md_id}]
        ad_script_abort
} 

# Metametadata metadatascheme
template::list::create \
    -name d_md_scheme \
    -multirow d_md_scheme \
    -no_data "[_ lorsm.No_Scheme_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        scheme {
            label "[_ lorsm.Scheme_1]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "meta_scheme" {ims_md_id ims_md_md_sch_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_md_scheme select_md_scheme {
    select scheme, 
           ims_md_id, ims_md_md_sch_id, scheme
    from 
           ims_md_metadata_scheme
    where
           ims_md_id = :ims_md_id
} 
