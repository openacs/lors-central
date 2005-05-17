# packages/lorsm/www/md/classificationmd/classification_key.tcl

ad_page_contract {
    
    Add/Edit Classification MD Keyword
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_cl_id:integer
    ims_md_cl_ke_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_cl_ke_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../classificationmd" ims_md_id] "[_ lorsm.Classification_MD]"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] "[_ lorsm.Classification_Entry]"] "[_ lorsm.Edit_Keyword_1]"]
    set title "[_ lorsm.lt_Edit_Classification_M]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../classificationmd" ims_md_id] "[_ lorsm.Classification_MD]"] [list [export_vars -base "classification" {ims_md_id ims_md_cl_id}] "[_ lorsm.Classification_Entry]"] "[_ lorsm.Add_Keyword]"]
    set title "[_ lorsm.lt_Add_Classification_MD_3]"
}

# Form

ad_form -name classificationmd_key \
    -cancel_url classification?ims_md_id=$ims_md_id&ims_md_cl_id=$ims_md_cl_id \
    -mode edit \
    -form {

    ims_md_cl_ke_id:key(ims_md_classification_keyword_seq)

    {keyword_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Classificatio_6]"}	
	{html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
	{label "[_ lorsm.Language]"}
    }

    {keyword_s:text,nospell	
	{html {size 20}}
	{help_text "[_ lorsm.lt_Keyword_description_o]"}
	{label "[_ lorsm.Keyword]"}
    }
    
    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

    {ims_md_cl_id:text(hidden) {value $ims_md_cl_id}
    }

} -select_query  {select * from ims_md_classification_keyword where ims_md_cl_ke_id = :ims_md_cl_ke_id and ims_md_cl_id = :ims_md_cl_id

} -edit_data {
        db_dml do_update "
            update ims_md_classification_keyword
            set keyword_l = :keyword_l,
            keyword_s = :keyword_s
            where ims_md_cl_ke_id = :ims_md_cl_ke_id"

} -new_data {
        db_dml do_insert "
            insert into ims_md_classification_keyword (ims_md_cl_ke_id, ims_md_cl_id, keyword_l, keyword_s)
            values 
            (:ims_md_cl_ke_id, :ims_md_cl_id, :keyword_l, :keyword_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "classification" {ims_md_cl_id ims_md_id}]
        ad_script_abort
} 

# Classification Keyword
template::list::create \
    -name d_cl_key \
    -multirow d_cl_key \
    -no_data "[_ lorsm.No_Keyword_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
	keyword {
	    label ""
	}
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "classification_key" {ims_md_cl_ke_id ims_md_cl_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_cl_key select_cl_key {
    select
    '[' || kw.keyword_l || '] ' || kw.keyword_s as keyword,
    kw.ims_md_cl_ke_id,
    cl.ims_md_cl_id,
    cl.ims_md_id
    from 
           ims_md_classification_keyword kw,
           ims_md_classification cl
    where
           kw.ims_md_cl_id = cl.ims_md_cl_id
    and
           kw.ims_md_cl_id = :ims_md_cl_id
} 
