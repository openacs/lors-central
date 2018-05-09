ad_library {
    
    @author Miguel Marin (miguelmarin@viaro.net)
}

namespace eval lors_central::cr {}

ad_proc -public lors_central::cr::add_files {
    {-parent_id:required}
    {-files:required}
    {-indb_p:required}
} {
    Adds a bunch of files to a folder in the CR
    Returns a list with full_path_to_file, mime-type, parent_id, 
    file_id, version_id, cr_file, file size.

    @param parent_id Folder's parent_id where the files will be put
    @param files All files for the parent_id folder come in one list
    @param indb_p Whether this file-storage instance (we are about to use) stores files in the file system or in the db
								     
} {

    # Get the user
    set user_id [ad_conn user_id]
    
    # Get the ip
    set creation_ip [ad_conn peeraddr]

    set retlist [list]
    foreach fle $files {

	regexp {[^//\\]+$} $fle filename
	set title $filename
        set mime_type [cr_filename_to_mime_type -create $fle]

        # insert file into the CR
        db_transaction {
	    set description "uploaded using LORS-CENTRAL"

	    # add file
	    set file_id [content::item::new -name $title -parent_id $parent_id -creation_user $user_id \
			     -creation_ip $creation_ip]


	    # add revision
	    set version_id [content::revision::new -title $title -description $description -mime_type $mime_type \
				-creation_user $user_id -creation_ip $creation_ip -item_id $file_id -is_live "t"]

	    # move the actual file into the CR
	    set cr_file [cr_create_content_file $file_id $version_id $fle]
	    # get the size
	    set file_size [cr_file_size $cr_file]
		
	    # update the file path in the CR and the size on cr_revisions
	    db_dml update_revi "update cr_revisions set content = '$cr_file', content_length = $file_size where revision_id = :version_id"

        }

        lappend retlist [list $fle $mime_type $parent_id $file_id $version_id $cr_file $file_size]
    }
    return $retlist
}
