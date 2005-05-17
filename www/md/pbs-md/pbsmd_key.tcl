# packages/lorsm/www/md/pbs-md/pbsmd_key.tcl

ad_page_contract {
    
    Add/Edit 
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ge_key_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ge_key_id]} {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  [list [export_vars -base "pbs-md" ims_md_id] "PBS Metadata"] "Edit Keywords"]
    set title "Edit Keywords"
} else {
    set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor" ]  [list [export_vars -base "pbs-md" ims_md_id] "PBS Metadata"] "Add Keywords"]
    set title "Add Keywords"
}

# Form

ad_form -name generalmd_key \
    -cancel_url pbs-md?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ge_key_id:key(ims_md_general_key_seq)

    {keyword_l:text,nospell,optional
	{section "Add/Edit Keywords"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }
    
    {keyword_s:text,nospell
        {html {size 50}}
	{help_text "[_ lorsm.lt_Keyword_description_o]"}
        {label "[_ lorsm.Keyword]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_general_key where ims_md_ge_key_id = :ims_md_ge_key_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_general_key
            set keyword_l = :keyword_l, keyword_s = :keyword_s
            where ims_md_ge_key_id = :ims_md_ge_key_id "
} -new_data {
        db_dml do_insert "
            insert into ims_md_general_key (ims_md_ge_key_id, ims_md_id, keyword_l, keyword_s)
            values
            (:ims_md_ge_key_id, :ims_md_id, :keyword_l, :keyword_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "pbs-md" {ims_md_id}]
    ad_script_abort 
} 

# General Keyword
template::list::create \
    -name d_gen_key \
    -multirow d_gen_key \
    -no_data "No Keywords Available" \
    -html { align right style "width: 100%;" } \
    -elements {
        keyword_l {
            label ""
        }
        keyword_s {
            label ""
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "pbsmd_key" {ims_md_ge_key_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_gen_key select_ge_key {
    select keyword_l,
           keyword_s, 
           ims_md_ge_key_id,
           ims_md_id
    from 
           ims_md_general_key
    where
           ims_md_id = :ims_md_id
}

