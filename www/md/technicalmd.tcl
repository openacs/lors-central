ad_page_contract {
    Displays/Adds IMS Metadata Metametadata

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 30 January 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  "[_ lorsm.Technical_MD]"]
set title "[_ lorsm.Technical_MD]"

# Technical Format
template::list::create \
    -name d_te_form \
    -multirow d_te_form \
    -no_data "[_ lorsm.No_Format_Available]" \
    -actions [list "[_ lorsm.Add_Format]" [export_vars -base technicalmd/technical_form {ims_md_id}] "[_ lorsm.Add_another_Format]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        format {
            label ""
        }
    }

db_multirow d_te_form select_te_form {
    select 
           format
    from 
           ims_md_technical_format
    where
           ims_md_id = :ims_md_id
} 

# Technical Size
template::list::create \
    -name d_te_size \
    -multirow d_te_size \
    -no_data "[_ lorsm.No_Size_Available]" \
    -actions [list "[_ lorsm.Add_Size]" [export_vars -base technicalmd/technical_size {ims_md_id}] "[_ lorsm.Add_another_Size]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        t_size_bytes {
            label ""
        }
    }

db_multirow d_te_size select_te_size {
    select 
           t_size || ' bytes' as t_size_bytes
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
} 

# Technical Location
template::list::create \
    -name d_te_loca \
    -multirow d_te_loca \
    -no_data "No Location Available" \
    -actions [list "Add Location" [export_vars -base technicalmd/technical_loca {ims_md_id}] "Add another Location"] \
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

# Technical Requirements 
template::list::create \
    -name d_te_req \
    -multirow d_te_req \
    -no_data "[_ lorsm.lt_No_Requirements_Avail]" \
    -actions [list "[_ lorsm.Add_Requirements]" [export_vars -base technicalmd/technical_req {ims_md_id}] "[_ lorsm.lt_Add_another_Requireme]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        type {
            label "[_ lorsm.Type]"
        }
        name {
            label "[_ lorsm.Name]"
        }
        min_version {
            label "[_ lorsm.Min_Version]"
        }
        max_version {
            label "[_ lorsm.Max_Version]"
        }
    }

db_multirow d_te_req select_te_req {
    select 
    '[' || type_s || ']' || ' ' || type_v as type, 
    '[' || name_s || ']' || ' ' || name_v as name,
    min_version,
    max_version
    from 
           ims_md_technical_requirement
    where
           ims_md_id = :ims_md_id
} 

# Technical Installation Remarks
template::list::create \
    -name d_te_inst \
    -multirow d_te_inst \
    -no_data "[_ lorsm.lt_No_Installation_Remar]" \
    -actions [list "[_ lorsm.lt_Add_Installation_Rema]" [export_vars -base technicalmd/technical_inst {ims_md_id}] "[_ lorsm.lt_Add_another_Installat]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        instl_rmrks {
            label ""
        }
    }

db_multirow d_te_inst select_te_inst {
    select 
    '[' || instl_rmrks_l || ']' || ' ' || instl_rmrks_s as instl_rmrks
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
}

# Technical Other Platform Requirements
template::list::create \
    -name d_te_otr \
    -multirow d_te_otr \
    -no_data "[_ lorsm.lt_No_Other_Platform_Req]" \
    -actions [list "[_ lorsm.lt_Add_Other_Platform_Re]" [export_vars -base technicalmd/technical_otr {ims_md_id}] "[_ lorsm.lt_Add_another_Other_Pla]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        otr_plt {
            label ""
        }
    }

db_multirow d_te_otr select_te_otr {
    select 
    '[' || otr_plt_l || ']' || ' ' || otr_plt_s as otr_plt
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
}

# Technical Duration
template::list::create \
    -name d_te_dur \
    -multirow d_te_dur \
    -no_data "[_ lorsm.lt_No_Duration_Available]" \
    -actions [list "[_ lorsm.Add_Duration]" [export_vars -base technicalmd/technical_dur {ims_md_id}] "[_ lorsm.Add_another_Duration]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        duration_sec {
            label ""
        }
        duration_l {
	    label ""
	}
	duration_s {
	    label ""
	}
    }

db_multirow d_te_dur select_te_dur {
    select 
    duration_l,
    duration_s,
    duration || 's' as duration_sec
    from 
           ims_md_technical
    where
           ims_md_id = :ims_md_id
}
