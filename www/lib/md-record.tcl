set actions [list]

lappend actions  "[_ lorsm._General]" [export_vars -base generalmd {ims_md_id}] "[_ lorsm.lt_View_General_Metadata]"
lappend actions  "[_ lorsm.Lifecycle_MD]" [export_vars -base lifecyclemd {ims_md_id}] "[_ lorsm.lt_View_Lifecycle_Metada]"
lappend actions  "[_ lorsm.Meta_MD]" [export_vars -base metamd {ims_md_id}] "[_ lorsm.View_Meta_Metadata]"
lappend actions  "[_ lorsm.Technical_MD]" [export_vars -base technicalmd {ims_md_id}] "[_ lorsm.lt_View_Technical_Metada]"
lappend actions  "[_ lorsm.Educational_MD]" [export_vars -base educationalmd {ims_md_id}] "[_ lorsm.lt_View_Educational_Meta]"
lappend actions  "[_ lorsm.Rights_MD]" [export_vars -base rightsmd {ims_md_id}] "[_ lorsm.View_Rights_Metadata]"
lappend actions  "[_ lorsm.Relation_MD]" [export_vars -base relationmd {ims_md_id}] "[_ lorsm.lt_View_Relation_Metadat]"
lappend actions  "[_ lorsm.Annotation_MD]" [export_vars -base annotationmd {ims_md_id}] "[_ lorsm.lt_View_Annotation_Metad]"
lappend actions  "[_ lorsm.Classification_MD]" [export_vars -base classificationmd {ims_md_id}] "[_ lorsm.lt_View_Classification_M_1]"


# Presentation 
template::list::create \
    -name d_pres \
    -multirow d_pres \
    -no_data "-" \
    -actions  $actions \
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

