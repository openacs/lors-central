ad_page_contract {
    Displays/Adds IMS Metadata Relation

    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
}

# set context & title
set context [list [list [export_vars -base "." ims_md_id] "[_ lorsm.IMS_Metadata_Editor]"]  "[_ lorsm.Relation_MD]"]
set title "Relation MD"

# Relation
template::list::create \
    -name d_re_relat \
    -multirow d_re_relat \
    -no_data "[_ lorsm.lt_No_Relation_Available]" \
    -actions [list "[_ lorsm.Add_Relation]" [export_vars -base relationmd/relation_add {ims_md_id}] "[_ lorsm.lt_Add_another_Relation__1]"] \
    -html { align right style "width: 100%;" } \
    -elements {
        kind_s {
            label ""
        }
	kind_v {
	    label ""
	}
	export {
            display_eval {\[View \\ Edit\]}
            link_url_eval { [export_vars -base "relationmd/relation" {ims_md_re_re_id ims_md_re_id ims_md_id}] }
            link_html {title "[_ lorsm.lt_View_associated_Relat]"}
            html { align center }
        }
    }

db_multirow d_re_relat select_re_relat {
select 
    re.kind_s,
    re.kind_v,
    re.ims_md_id,
    re.ims_md_re_id,
    rere.ims_md_re_re_id
from 
    ims_md_relation re,
    ims_md_relation_resource rere
where 
    re.ims_md_id = :ims_md_id
and
    rere.ims_md_re_id = re.ims_md_re_id
} 
