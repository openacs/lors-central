alter table ims_cp_items_map drop constraint ims_cp_items_map_com_id_fk;
alter table ims_cp_items_map add constraint ims_cp_items_map_com_id_fk
foreign key (community_id) references groups (group_id);
