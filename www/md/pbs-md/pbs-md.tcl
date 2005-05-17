# packages/lors-central/www/md/pbs-md/pbs-md.tcl

ad_page_contract {
    
    Add/Edit PBS MD Schema
    
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2005-04-03
    @arch-tag: 4eb5b155-a31b-461e-a671-9265963e3257
    @cvs-id $Id$
} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}


# set context & title
set context [list [list [export_vars -base "." ims_md_id] "PBS Metadata Editor"]  "PBS Metadata"]
set title "PBS Metadata Editor"

# General Title
template::list::create \
    -name d_gen_titles \
    -multirow d_gen_titles \
    -no_data "No Title Available" \
    -actions [list " Add Program Title " [export_vars -base pbsmd_title {ims_md_id}] "Add Program Title"] \
    -html { align right style "width: 100%;" } \
    -elements {
        title_l {
            label ""
        }
        title_s {
            label ""
        }
    }

db_multirow d_gen_titles select_ge_titles {
    select title_l,
           title_s
    from 
           ims_md_general_title
    where
           ims_md_id = :ims_md_id
} {
    set item_url [export_vars -base "item" { ims_md_id }]
}

# General Description
template::list::create \
    -name d_gen_desc \
    -multirow d_gen_desc \
    -no_data "[_ lorsm.lt_No_Description_Availa]" \
    -actions [list "[_ lorsm.Add_Description]" [export_vars -base pbsmd_desc {ims_md_id}] "[_ lorsm.lt_Add_another_Descripti]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        descrip_l {
            label ""
        }
        descrip_s {
            label ""
        }
    }

db_multirow d_gen_desc select_ge_desc {
    select descrip_l,
           descrip_s
    from 
           ims_md_general_desc
    where
           ims_md_id = :ims_md_id
} 

# General Catalog-entry (PBS SubjectArea)
template::list::create \
    -name d_gen_cata_pbs_sa \
    -multirow d_gen_cata_pbs_sa \
    -no_data " No PBS Subject Area Available " \
    -actions [list "Add PBS-Subject Area" [export_vars -base pbsmd_subarea {ims_md_id}] "Add PBS-Subject Area"] \
    -html { align right style "width: 100%;" } \
    -elements {
        catalog {
            label ""
        }
        entry_l {
            label ""
        }
        entry_s {
            label ""
        }
    }

db_multirow d_gen_cata_pbs_sa select_ge_cata {
    select 
           catalog,
           entry_l,
           entry_s
    from 
           ims_md_general_cata
    where
	   catalog = 'PBS-SubjectArea'
    and
           ims_md_id = :ims_md_id
} 

# General Catalog-entry (PBS-CurriculumTopic)
template::list::create \
    -name d_gen_cata_pbs_ct \
    -multirow d_gen_cata_pbs_ct \
    -no_data "[_ lorsm.lt_No_Catalog_Entry_Avai]" \
    -actions [list "Add PBS-Curriculum Topic" [export_vars -base pbsmd_currtop {ims_md_id}] " Add another PBS-Curriculum Topic "] \
    -html { align right style "width: 100%;" } \
    -elements {
        catalog {
            label ""
        }
        entry_l {
            label ""
        }
        entry_s {
            label ""
        }
    }

db_multirow d_gen_cata_pbs_ct select_ge_cata {
    select 
           catalog,
           entry_l,
           entry_s
    from 
           ims_md_general_cata
    where
           catalog = 'PBS-CurriculumTopic'
    and     
           ims_md_id = :ims_md_id
} 



# General Keywords
template::list::create \
    -name d_gen_key \
    -multirow d_gen_key \
    -no_data "[_ lorsm.lt_No_Keywords_Available]" \
    -actions [list "[_ lorsm.Add_Keywords]" [export_vars -base pbsmd_key {ims_md_id}] "[_ lorsm.Add_another_Keywords]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        keyword_l {
            label ""
        }
        keyword_s {
            label ""
        }
    }

db_multirow d_gen_key select_ge_key {
    select 
           keyword_l,
           keyword_s
    from 
           ims_md_general_key
    where
           ims_md_id = :ims_md_id
} 


# Technical Location (PBS: URL)
template::list::create \
    -name d_te_loca \
    -multirow d_te_loca \
    -no_data "No URL Available" \
    -actions [list "Add URL" [export_vars -base pbsmd_url {ims_md_id}] "Add another URL"] \
    -html { align right style "width: 100%;" } \
    -elements {
        type {
            label ""
        }
        location {
            label ""
        }
    }

db_multirow d_te_loca select_te_loca {
    select 
           type, 
           location
    from 
           ims_md_technical_location
    where
           ims_md_id = :ims_md_id
} 

# Educational Context (PBS: Grade Range)
template::list::create \
    -name d_ed_cont \
    -multirow d_ed_cont \
    -no_data "No Grade Range Available" \
    -actions [list "Add Grade Range" [export_vars -base pbsmd_grade {ims_md_id}] "Add another Grade Range"] \
    -html { align right style "width: 100%;" } \
    -elements {
        context {
            label ""
        }
    }

db_multirow d_ed_cont select_ed_cont {
    select 
    '[' || context_s || '] ' || context_v as context 
    from 
           ims_md_educational_context
    where
           ims_md_id = :ims_md_id
} 

# Educational Learning Resource Type (PBS: Resource Type)
template::list::create \
    -name d_ed_lrt \
    -multirow d_ed_lrt \
    -no_data "No Resource Type Available" \
    -actions [list "Add Resource Type" [export_vars -base pbsmd_restype {ims_md_id}] "Add another Resource Type"] \
    -html { align right style "width: 100%;" } \
    -elements {
        lrt {
            label ""
        }
    }

db_multirow d_ed_lrt select_ed_lrt {
    select 
    '[' || lrt_s || '] ' || lrt_v as lrt 
    from 
           ims_md_educational_lrt
    where
           ims_md_id = :ims_md_id
} 
