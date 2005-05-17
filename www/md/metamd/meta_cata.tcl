# packages/lorsm/www/md/metamd/meta_cata.tcl

ad_page_contract {
    
    Add/Edit Meta MD Catalog-Entry
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 16 October 2004
    @cvs-id $Id$

} {
    ims_md_id:integer
    ims_md_md_cata_id:integer,optional
} -properties {
} -validate {
} -errors {
}

# set context & title
if { ![ad_form_new_p -key ims_md_md_cata_id]} {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../metamd" im\s_md_id] "Meta Metadata"] "Edit Catalog-Entry"]
    set title "Edit Meta MD Catalog-Entry"
} else {
    set context [list [list [export_vars -base ".." ims_md_id] "IMS Metadata Editor"]  [list [export_vars -base "../metamd" im\s_md_id] "Meta Metadata"] "Add Catalog-Entry"]
    set title "Add Meta MD Catalog-Entry"
}

# Form

ad_form -name metamd_cata \
    -cancel_url ../metamd?ims_md_id=$ims_md_id \
    -mode edit \
    -form {

    ims_md_md_cata_id:key(ims_md_metadata_cata_seq)

    {catalog:text,nospell
	{section "Add/Edit Meta MD Catalog-Entry"}
	{html {size 50}}
	{help_text "Name of the catalog"}
	{label "Catalog:"}
    }

    {entry_l:text,nospell,optional
        {html {size 10}}
	{help_text "i.e.: 'en_AU' for Australian English"}
        {label "Language:"}
    }
    
    {entry_s:text,nospell
        {html {size 50}}
	{help_text "Number in the Catalog i.e.: '1.3.1'"}
        {label "Entry:"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}
    }

} -select_query  {select * from ims_md_metadata_cata where ims_md_md_cata_id = :ims_md_md_cata_id and ims_md_id = :ims_md_id

} -edit_data {
        db_dml do_update "
            update ims_md_metadata_cata
            set catalog = :catalog, entry_l = :entry_l, entry_s = :entry_s
            where ims_md_md_cata_id = :ims_md_md_cata_id"
} -new_data {
        db_dml do_insert "
            insert into ims_md_metadata_cata (ims_md_md_cata_id, ims_md_id, catalog, entry_l, entry_s)
            values
            (:ims_md_md_cata_id, :ims_md_id, :catalog, :entry_l, :entry_s)"

} -after_submit {
    ad_returnredirect [export_vars -base "../metamd" {ims_md_id}]
        ad_script_abort
} 

# Metametadata Catalog-entry
template::list::create \
    -name d_md_cata \
    -multirow d_md_cata \
    -no_data "No Catalog Entry Available" \
    -html { align right style "width: 100%;" } \
    -elements {
	catalog {
	    label "Catalog"
	}
        entry_ls {
            label "Language Entry"
        }
        export {
            display_eval {\[Edit\]}
            link_url_eval { [export_vars -base "meta_cata" {ims_md_md_cata_id ims_md_id}] }
            link_html {title "Edit Record "}
            html { align center }
        }
    }

db_multirow d_md_cata select_md_cata {
    select catalog,
    '[' || entry_l || ']' || ' ' || entry_s as entry_ls,
    ims_md_md_cata_id,
    ims_md_id       
    from 
           ims_md_metadata_cata
    where
           ims_md_id = :ims_md_id
} 

