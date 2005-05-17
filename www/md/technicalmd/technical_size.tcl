# packages/lorsm/www/md/technicalmd/technical_size.tcl

ad_page_contract {
    
    Add/Edit Technical MD Size
    
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
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../technicalmd" \im\s_md_id] "[_ lorsm.Technical_MD]"] "[_ lorsm.Edit_Size]"]
set title "[_ lorsm.lt_AddEdit_Technical_MD__6]"

# Form

ad_form -name technicalmd_size \
    -cancel_url ../technicalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    {t_size:text,nospell
	{section "[_ lorsm.lt_AddEdit_Technical_MD__6]"}
        {html {size 30}}
	{help_text "[_ lorsm.lt_Size_of_the_resource_]"}
        {label "[_ lorsm.Size]"}
    }
    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    # check if the tech size details already exist...

    if {[db_0or1row select_size {select ims_md_id from ims_md_technical where ims_md_id = :ims_md_id}]} {

        db_dml do_update "
            update ims_md_technical
            set t_size = :t_size
            where ims_md_id = :ims_md_id "

    } else {

	db_dml do_insert "
            insert into ims_md_technical (ims_md_id, t_size) 
            values
            (:ims_md_id, :t_size) "
    }

} -after_submit {
    ad_returnredirect [export_vars -base "../technicalmd" {ims_md_id}]
        ad_script_abort
} 

# Technical Size
template::list::create \
    -name d_te_size \
    -multirow d_te_size \
    -no_data "[_ lorsm.No_Size_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
        t_size_bytes {
            label "[_ lorsm.Size_1]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "technical_size" {ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_te_size select_te_size {
    select t_size || ' bytes' as t_size_bytes,
           ims_md_id
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 
