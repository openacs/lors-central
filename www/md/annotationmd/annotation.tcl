ad_page_contract {
    Displays/Adds IMS Metadata Annotation
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_an_id:integer
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base ".." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"] [list [export_vars -base "../annotationmd" ims_md_id] "[_ lorsm.Annotation_MD]"] "[_ lorsm.Annotation_Entry]"]
set title "[_ lorsm.Annotation_MD]"

# Annotation Entity
template::list::create \
    -name d_an_ent \
    -multirow d_an_ent \
    -no_data "[_ lorsm.No_Entity_Available]" \
    -actions [list "[_ lorsm.Add_Entity]" [export_vars -base annotation_ent {ims_md_an_id ims_md_id}] "[_ lorsm.Add_another_Entity]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        entity {
            label ""
        }
    }

db_multirow d_an_ent select_an_ent {
    select entity
    from 
           ims_md_annotation
    where
           ims_md_an_id = :ims_md_an_id
} 

# Annotation Date 
template::list::create \
    -name d_an_date \
    -multirow d_an_date \
    -no_data "[_ lorsm.No_Date_Available]" \
    -actions [list "[_ lorsm.Add_Date]" [export_vars -base annotation_date {ims_md_an_id ims_md_id}] "[_ lorsm.Add_another_Date]"] \
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
    '[' || date_l || '] ' || date_s as datels
    from 
           ims_md_annotation
    where
           ims_md_an_id = :ims_md_an_id
} 

# Annotation Description
template::list::create \
    -name d_an_desc \
    -multirow d_an_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -actions [list "[_ lorsm.Add_Description]" [export_vars -base annotation_desc {ims_md_an_id ims_md_id}] "[_ lorsm.lt_Add_another_Descripti]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        desc {
            label ""
        }
    }

db_multirow d_an_desc select_an_desc {
    select 
    '[' || descrip_l || '] ' || descrip_s as desc
    from 
           ims_md_annotation_descrip
    where
           ims_md_an_id = :ims_md_an_id
} 
