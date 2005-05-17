# packages/lorsm/www/md/annotationmd/annotation_date.tcl

ad_page_contract {
    
    Add/Edit Annotation MD Date
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_an_id:integer
} -properties {
} -validate {
} -errors {
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../annotationmd" ims_md_id] "[_ lorsm.Annotation_MD]"] [list [export_vars -base "annotation" {ims_md_id ims_md_an_id}] "[_ lorsm.Annotation_Entry]"] "[_ lorsm.AddEdit_Date]"]
set title "[_ lorsm.lt_Edit_Annotation_MD_Da]"


# Form

ad_form -name annotationmd_date \
    -cancel_url annotation?ims_md_id=$ims_md_id&ims_md_an_id=$ims_md_an_id \
    -mode edit \
    -form {

    ims_md_an_id:key(ims_md_annotation_seq)

    {date:text,nospell
	{section "[_ lorsm.lt_AddEdit_Annotation_MD_2]"}	
	{html {size 10}}
	{help_text "[_ lorsm.Date_of_contribution]"}
	{label "[_ lorsm.Date]"}
    }

    {date_l:text,nospell,optional	
	{html {size 10}}
	{help_text "[_ lorsm.lt_ie_en_AU_for_Australi_3]"}
	{label "[_ lorsm.Language]"}
    }
    
    {date_s:text(textarea),nospell,optional
        {html {rows 2 cols 50}}
	{help_text "[_ lorsm.lt_Date_and_Time_descrip]"}
        {label "[_ lorsm.Description]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    } 

} -select_query  {select * from ims_md_annotation where ims_md_an_id = :ims_md_an_id

} -edit_data {
        db_dml do_update "
            update ims_md_annotation
            set date = :date,
            date_l = :date_l,
            date_s = :date_s
            where ims_md_an_id = :ims_md_an_id "

} -after_submit {
    ad_returnredirect [export_vars -base "annotation" {ims_md_an_id ims_md_id}]
        ad_script_abort
} 

# Annotation Date
template::list::create \
    -name d_an_date \
    -multirow d_an_date \
    -no_data "[_ lorsm.No_Date_Available]" \
    -html { align right style "width: 100%;" } \
    -elements {
	date {
            label "[_ lorsm.Date_1]"
        }
	datels {
	    label "[_ lorsm.Description_1]"
	}
    }

db_multirow d_an_date select_an_date {
    select date,
    '[' || date_l || '] ' || date_s as datels,
    ims_md_an_id,
    ims_md_id   
    from 
           ims_md_annotation
    where
           ims_md_an_id = :ims_md_an_id
} 
