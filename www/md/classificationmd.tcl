ad_page_contract {
    Displays/Adds IMS Metadata Classification

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  "[_ lorsm.Classification_MD]"]
set title "[_ lorsm.Classification_MD]"

# Classification
template::list::create \
    -name d_cl_class \
    -multirow d_cl_class \
    -no_data "[_ lorsm.lt_No_Classification_Ava]" \
    -actions [list "[_ lorsm.Add_Classification]" [export_vars -base classificationmd/classification_add {ims_md_id}] "[_ lorsm.lt_Add_another_Classific_2]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        purpose_s {
            label ""
        }
	purpose_v {
            label ""
        }
	export {
            display_eval {\[View\]}
            link_url_eval { [export_vars -base "classificationmd/classification" {ims_md_cl_id ims_md_id}] }
            link_html {title "[_ lorsm.lt_View_associated_Class]"}
            html { align center }
        }
    }

db_multirow d_cl_class select_cl_class {
select 
    purpose_s,
    purpose_v,
    ims_md_cl_id,
    ims_md_id
from 
    ims_md_classification 
where 
    ims_md_id = :ims_md_id
} 
