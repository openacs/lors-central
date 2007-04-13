ad_page_contract {
    Edit ims_cp_file content and create a new revision
    @param file_id
    @param res_id ?
    @param man_id ?
} {
}

set user_id [ad_conn user_id]

foreach required_param {file_id} {
    if {![info exists $required_param]} {
        return -code error "$required_param is a required parameter."
    }
}

foreach optional_param {return_url submission_p} {
    if {![info exists $optional_param]} {
        set $optional_param {}
    }
}

if {[empty_string_p $return_url]} {
    set return_url [export_vars -base "one-learning-object" {man_id ims_item_id}]
}

set file_item_id [lors_central::get_item_id -revision_id $file_id]
if {![lors_central::item_editable_p -item_id $file_item_id]} {
    set edit_p 0
} else {
    set edit_p 1
}

array set fs_object_info [lors_central::get_object_info -file_id $file_id]
    
if {[empty_string_p $submission_p]} {
    if {[string equal $fs_object_info(mime_type) "text/html"]} {
        set htmlarea_p 1
    } else {
        set htmlarea_p 0
    }
}

ad_form \
    -name file_form \
    -export {res_id man_id file_id return_url edit_p} \
    -html {enctype multipart/form-data} \
    -form {
	{title:text(inform) {label "Title"}}
        {version_notes:text(inform) {label "Current Version Notes"}}
        {description:text(text),optional {label "Version Notes"}}
    }

if {$edit_p} {
    ad_form \
	-extend -name file_form \
	-form {
	    {upload_file:file,optional {label "Upload a file:"} {html "size 30"} {after_html "<br /><br />Or"}}
	    {content:richtext(richtext),optional {label "Edit the current content"} {html {rows 20 cols 60}} {htmlarea_p 1}}
	}
} else {
    ad_form \
	-extend -name file_form \
	-form {
	    {upload_file:file {label "File:"} {html "size 30"}}
	}
}

ad_form -extend -name file_form \
    -form {
	{submission_p:text(hidden) {value 1}}
    } \
    -on_request {
        set title $fs_object_info(name)
        set version_notes $fs_object_info(version_notes)
	# Extract only the HTML body
	regexp -nocase {<\s*?body[^>]*?>(.*)</\s*?body\s*?>} $fs_object_info(content) match fs_object_info(content)
        set content [list [string trim $fs_object_info(content)] $fs_object_info(mime_type)]
        set return_url $return_url
    } -on_submit {
	set file_item_id [lors_central::get_item_id -revision_id $file_id]
	set new_res_id [lors_central::add_resource_revision \
			    -res_id $res_id \
			    -name $title \
			    -user_id [ad_conn user_id] \
			    -man_id $man_id]
	
	if {$edit_p} {
	    if {$upload_file ne ""} {
		set tmp_filename [template::util::file::get_property tmp_filename $upload_file]
		set mime_type [template::util::file::get_property mime_type $upload_file]
		
		set fp [open $tmp_filename r]
		set content_body [read $fp]
		close $fp
		
	    } else {
		set content_body [template::util::richtext::get_property contents $content]
		set mime_type [template::util::richtext::get_property format $content]
	    }
	    # Rebuild HTML if necessary
	    if { [regexp -nocase {^(.*<\s*?body[^>]*?>).*(</\s*?body\s*?>.*)$} $fs_object_info(content) match header footer] } {
		set content_body "${header}${content_body}${footer}"
	    }
	    foreach {link id} [regexp -inline -all {<a href="\.\./o/(\d+?)">.*?</a>} $content_body] {
		# ns_log notice "DAVEB link '${link}' id '${id}"
		# find out if its an image
		
		if {[db_0or1row mime "select mime_type as this_mime_type, title as this_title from cr_revisions, cr_items  where cr_items.item_id=:id and revision_id=live_revision"]} {
		    # ns_log notice "DAVEB mime_type '${this_mime_type}'"
		    if {[string match "image/*" $this_mime_type]} {
			
			regsub -all $link $content_body "<img src=\"images/${this_title}\" />" content_body
		    } else {
			# FIXME for now just throw away non image links until we can do something intelligent with them!
			regsub -all $link $content_body {} content_body
		    }
		}
		
	    }
	    
	    # this is 99% the same as new-file, it _is_ a new file except its not uploaded
	
	    set new_file_id [lors_central::add_file_revision \
				 -file_content $content_body \
				 -mime_type $mime_type \
				 -name $title \
				 -title $title \
				 -res_id $new_res_id \
				 -man_id $man_id \
				 -item_id $file_item_id \
				 -description $description]
	} else {
	    
	    #Getting file info
	    set tmp_filename [template::util::file::get_property tmp_filename $upload_file]
	    set mime_type [template::util::file::get_property mime_type $upload_file]
	    
	    set new_file_id [lors_central::add_file_revision \
				 -tmp_filename $tmp_filename \
				 -mime_type $mime_type \
				 -name $title \
				 -title $title \
				 -res_id $new_res_id \
				 -man_id $man_id \
				 -item_id $file_item_id \
				 -description $description]
	}
	
	set exclude [db_list get_exclude "select revision_id from cr_revisions where item_id=:file_item_id"]
	
	lors_central::resource_carry_forward_files -old_res_id $res_id -new_res_id $new_res_id -exclude $exclude
	lors_central::res_update_items \
	    -old_res_id $res_id \
	    -new_res_id $new_res_id \
	    -user_id [ad_conn user_id]
	
	#Updating version notes
	
	
    } -after_submit {
	
	ad_returnredirect $return_url
    }
