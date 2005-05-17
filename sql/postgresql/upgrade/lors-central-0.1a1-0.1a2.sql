ALTER TABLE ims_cp_files DROP CONSTRAINT ims_cp_files_file_if_fk;

UPDATE ims_cp_files
SET file_id = ( 
		select live_revision 
 		from cr_items 
		where item_id = file_id );

ALTER TABLE ims_cp_files ADD CONSTRAINT ims_cp_files_file_if_fk FOREIGN KEY (file_id) REFERENCES cr_revisions(revision_id) ON DELETE CASCADE;