# packages/lorsm/www/md/addmd.tcl

ad_page_contract {
    
    Add metadata schema
    
    @author Gerard Low (glow5809@mail.usyd.edu.au)
    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 2004-11-13
    @arch-tag: 28b76527-a05f-42cf-b562-37c7b85e799f
    @cvs-id $Id$
} {
    ims_md_id:integer
} -properties {
} -validate {
} -errors {
}

# Get object information
set object_type [acs_object_type $ims_md_id]

# set context & title
set context [list [list [export_vars -base "." ims_md_id]  "PBS Metadata Editor"] "PBS Metadata"]
set title "MD Schema"


# Form
ad_form -name add_md \
    -cancel_url [export_vars -base "." {ims_md_id}] \
    -mode edit \
    -form {

    {schema:text,nospell
        {html {size 20}}
	{help_text "[_ lorsm.lt_Metadata_schema_ie_IM]"}
        {label "[_ lorsm.Schema]"}
    }

    {schemaversion:text,nospell
        {html {size 10}}
	{help_text "[_ lorsm.lt_Version_of_the_Schema]"}
        {label "[_ lorsm.Schema_Version]"}
    }

    {ims_md_id:text(hidden) {value $ims_md_id}}

} -on_submit {
    db_transaction {

	if {![lors::imsmd::mdExist -ims_md_id $ims_md_id]} {

	    db_dml do_insert "
              insert into ims_md(ims_md_id, schema, schemaversion) 
              values (:ims_md_id, :schema, :schemaversion)"

	} else {

	    db_dml do_update {
		update ims_md set schema = :schema, schemaversion = :schemaversion
                where ims_md_id = :ims_md_id
	    }

	}
	
	# If the object_type is on any of the IMS CP object types,
	# then we update also the ims cp tables accordingly. 

	switch $object_type {

	    "ims_manifest_object" {

		db_dml upd_manifest "
            		update ims_cp_manifests set hasmetadata = 't'
		            where man_id = :ims_md_id"
	    }
	    "ims_item_object" {
		
		db_dml upd_item "
            		update ims_cp_items set hasmetadata = 't'
		            where ims_item_id = :ims_md_id"
	    }
	    "ims_organization_object" {

		db_dml upd_organization "
            		update ims_cp_organizations set hasmetadata = 't'
		            where org_id = :ims_md_id"
	    }
	    "ims_resource_object" {

		db_dml upd_resource "
            		update ims_cp_resources set hasmetadata = 't'
		            where res_id = :ims_md_id"
	    }
	    "content_item" {

		db_dml upd_file "
            		update ims_cp_files set hasmetadata = 't'
		            where file_id = :ims_md_id"
	    }

	}
    }

} -after_submit {
    ad_returnredirect [export_vars -base "." ims_md_id]
        ad_script_abort
} 

# MD Schema Info
template::list::create \
    -name md_schema_info \
    -multirow md_schema_info \
    -no_data "[_ lorsm.No_Schema_Available]" \
	-html { align right style "width: 100%;" } \
	-elements {
	    schema {
            label "[_ lorsm.Schema_1]"
	    html { align center }
	    }
	    schemaversion {
            label "[_ lorsm.Version_1]"
	    html { align center }
	    }
	}

    db_multirow md_schema_info select_md_schema {
    select 
	   schema,
	   schemaversion
    from
           ims_md
    where
           ims_md_id = :ims_md_id
    } 

