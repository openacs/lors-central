ALTER TABLE ims_cp_manifest_class DROP CONSTRAINT ims_cp_manifest_class_pkey;
ALTER TABLE ims_cp_items ADD sort_order integer;
ALTER TABLE ims_cp_files DROP CONSTRAINT ims_cp_files_file_if_fk;
ALTER TABLE ims_cp_files ADD CONSTRAINT ims_cp_files_file_if_fk FOREIGN KEY (file_id) REFERENCES cr_revisions(revision_id) ON DELETE CASCADE;

create table ims_cp_items_map (
    man_id         int
                   constraint ims_cp_items_map_man_id_fk references ims_cp_manifests (man_id),
    org_id         int
                   constraint ims_cp_items_map_org_id_fk references ims_cp_organizations (org_id),
    community_id   int
                   constraint ims_cp_items_map_com_id_fk references dotlrn_communities_all(community_id),
    hide_p         boolean default 'f',
    ims_item_id    int
                   constraint ims_cp_items_map_ims_item_id_fk references ims_cp_items (ims_item_id),
                   constraint ims_cp_items_map_pk primary key (ims_item_id,community_id,man_id)
    
);



\i lors-central-imscp-package-create.sql