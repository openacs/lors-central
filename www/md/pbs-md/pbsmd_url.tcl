# packages/lorsm/www/md/pbs-md/pbsmd_url.tcl

ad_page_contract {
    
    Add/Edit PBS URL
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_te_lo_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_te_lo_id]} {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  [list [export_vars -base "../technicalmd" ims_md_id] "PBS Metadata"] "Edit URL"]
    set title "Edit URL"
} else {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  [list [export_vars -base "../technicalmd" ims_md_id] "PBS Metadata"] "Add URL"]
    set title "Add URL"
}

# Form

ad_form -name technicalmd_loca \
    -cancel_url pbs-md?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_te_lo_id:key(ims_md_technical_location_seq)

    {type:text,nospell,optional
	{section "Add/Edit URL"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_Reference_to_location]"}
        {label "[_ lorsm.Type_1]"}
    }

    {location:text,nospell
        {html {size 50}}
	{help_text "[_ lorsm.lt_Location_of_the_resou]"}
        {label "[_ lorsm.Location_1]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }
    

} -select_query  {select * from ims_md_technical_location where ims_md_te_lo_id = :ims_md_te_lo_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_technical_location
            set type = :type,
            location = :location
            where ims_md_te_lo_id = :ims_md_te_lo_id "

} -new_data {
       db_dml do_insert "
            insert into ims_md_technical_location (ims_md_te_lo_id, ims_md_id, type, location)
            values
            (:ims_md_te_lo_id, :ims_md_id, :type, :location)"

} -after_submit {
    ad_returnredirect [export_vars -base "pbs-md" {ims_md_id}]
        ad_script_abort
} 

# Technical Location
template::list::create \
    -name d_te_loca \
    -multirow d_te_loca \
    -no_data "No URL Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	type {
	    label "[_ lorsm.Type]"
	}
        location {
            label "[_ lorsm.Location]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "pbsmd_url" {ims_md_te_lo_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_te_loca select_te_loca {
    select type,
           location,
           ims_md_te_lo_id,
           ims_md_id
    from 
           ims_md_technical_location
    where
           ims_md_id = :ims_md_id
} 
