# packages/lorsm/www/md/educationalmd/educational_tar.tcl

ad_page_contract {
    
    Add/Edit Educational MD Typical Age Range
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_ed_ta_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_ed_ta_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" ims_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.lt_Edit_Typical_Age_Rang]"]
    set title "[_ lorsm.lt_Edit_Educational_MD_T]"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  [list [export_vars -base "../educationalmd" ims_md_id] "[_ lorsm.Educational_MD]"] "[_ lorsm.Add_Typical_Age_Rang]"]
    set title "[_ lorsm.lt_Add_Educational_MD_Ty]"
}

# Form

ad_form -name educationalmd_tar \
    -cancel_url ../educationalmd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_ed_ta_id:key(ims_md_educational_tar_seq)

    {tar_l:text,nospell
	{section "[_ lorsm.lt_AddEdit_Educational_M_20]"}
        {html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi]"}
        {label "[_ lorsm.Language]"}
    }

    {tar_s:text,nospell
        {html {size 20}}
	{help_text "[_ lorsm.lt_Age_of_the_typical_in]"}
        {label "[_ lorsm.Typical_Age_Range]" }
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_educational_tar where ims_md_ed_ta_id = :ims_md_ed_ta_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_educational_tar
            set tar_l = :tar_l,
            tar_s = :tar_s
            where ims_md_ed_ta_id = :ims_md_ed_ta_id "
} -new_data {
       db_dml do_insert "
            insert into ims_md_educational_tar (ims_md_ed_ta_id, ims_md_id, tar_l, tar_s) 
            values (:ims_md_ed_ta_id, :ims_md_id, :tar_l, :tar_s)"
} -after_submit {
    ad_returnredirect [export_vars -base "../educationalmd" {ims_md_id}]
        ad_script_abort
} 

# Educational Typical Age Range
template::list::create \
    -name d_ed_tar \
    -multirow d_ed_tar \
    -no_data "[_ lorsm.lt_No_Typical_Age_Range_]" \
    -html { align right style "width: 100%;" } \
    -elements {
	tar {
            label "[_ lorsm.Typical_Age_Range_1]"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "educational_tar" {ims_md_ed_ta_id ims_md_id}] }
            link_html {title "[_ lorsm.Edit_Record]"}
            html { align center }
        }
    }

db_multirow d_ed_tar select_ed_tar {
    select 
        '[' || tar_l || '] ' || tar_s as tar,
        ims_md_ed_ta_id,
        ims_md_id
    from 
           ims_md_educational_tar
    where
           ims_md_id = :ims_md_id
} 
