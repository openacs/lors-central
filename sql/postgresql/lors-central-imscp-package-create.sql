--

-- And

-- SCORM 1.2 Specs

create or replace function ims_manifest_admin__new (
    varchar,   -- course_name
    varchar,   -- identifier
    varchar,   -- version
    varchar,   -- orgs_default
    boolean,   -- hasmetadata
    integer,   -- parent_man_id
    boolean,   -- isscorm 
    integer,   -- folder_id 
    timestamp with time zone, -- creation_date
    integer,   -- creation_user
    varchar,    -- creation_ip
    integer,    -- package_id
    integer,     -- new revision_id for the item in the CR
    boolean,      -- is shared
    integer 	-- course_presentation_format
)
returns integer as '
declare
    p_course_name           alias for $1;
    p_identifier            alias for $2;
    p_version               alias for $3;
    p_orgs_default          alias for $4;
    p_hasmetadata           alias for $5;
    p_parent_man_id         alias for $6;
    p_isscorm               alias for $7;
    p_folder_id             alias for $8;
    p_creation_date         alias for $9;
    p_creation_user         alias for $10;
    p_creation_ip           alias for $11;
    p_package_id            alias for $12;
    p_revision_id           alias for $13;
    p_isshared              alias for $14;
    p_course_presentation_format alias for $15;
begin
  
        -- we make an update here because the content::item::new already inserts a row in the ims_cp_manifests
        update ims_cp_manifests
        set course_name=p_course_name, identifier=p_identifier, version=p_version, 
            orgs_default=p_orgs_default, hasmetadata=p_hasmetadata, parent_man_id=p_parent_man_id, 
            isscorm=p_isscorm, folder_id=p_folder_id, isshared = p_isshared,
            course_presentation_format=p_course_presentation_format
        where man_id = p_revision_id;

	insert into ims_cp_manifest_class
	(man_id, lorsm_instance_id, isenabled, istrackable)
	values
	(p_revision_id, p_package_id, ''t'', ''f'');

        return p_revision_id;
end;
' language 'plpgsql';

