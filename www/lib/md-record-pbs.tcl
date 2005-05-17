
template::list::create \
    -name d_pres \
    -multirow d_pres \
    -no_data "-" \
    -html {width 80%} \
    -elements {
        object_type {
            label "[_ lorsm.Object_Type]"
        }
	schema_and_version {
	    label "[_ lorsm.lt_MD_Schema_and_Version]"
            html { align center }
	}
        admin {
            label "[_ lorsm.Edit_Schema_Details]"
            display_eval {Modify Schema}
            link_url_eval {[export_vars -base "addmd" ims_md_id]}
            link_html {title "[_ lorsm.Admin_Course]" class button}
            html { align center }
        }

    }

db_multirow d_pres select_ge_titles {
    select
           object_type
    from 
           acs_objects
    where
           object_id = :ims_md_id
} 

db_multirow -extend { schema_and_version } d_pres select_schema_details {

    select 
            ims_md_id,
            schema, 
            schemaversion 
    from 
            ims_md 
    where 
            ims_md_id = :ims_md_id

} {
    set schema_and_version [concat $schema "  " $schemaversion]
}

