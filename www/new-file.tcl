ad_page_contract {
    Adds a new file to one resource
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
} {
    res_id:integer,notnull
    {man_id ""}
    {name ""}
    file_upload:trim,optional
    file_upload.tmpfile:optional,tmpfile
    {mime_type ""}
}


set user_id [ad_conn user_id]
# Checking privilege over lors-central
lors_central::check_permissions

set page_title "[_ lors-central.new_file]"
set context "[list [list [export_vars -base one-resource {res_id}] \
                   [_ lors-central.One_learning]] \
                    [_ lors-central.new_file]]"

set man_id [db_string get_man_id "select man_id from ims_cp_resources where res_id=:res_id"]
ad_form -name file_upload -html {enctype multipart/form-data} \
    -export {res_id man_id} \
    -form {
    {file_title:text(text)
        {label "[_ lors-central.item_title]"}
    }
    {file_upload:text(file)
        {label "[_ lors-central.choose_the_file]"}
	{help_text "[_ lors-central.help_text]"}
    }
} -on_submit {

         set res_href [lors_central::get_res_href -res_id $res_id]

         set tmp_filename [ns_queryget file_upload.tmpfile]
         set mime_type [cr_filename_to_mime_type -create $file_upload]
         set tmp_size [file size $tmp_filename]

	 set new_res_rev_id [lors_central::add_file \
				 -filename $file_upload \
				 -title $file_title \
				 -tmp_filename $tmp_filename \
				 -res_id $res_id \
				 -mime_type $mime_type \
				 -man_id $man_id ]
	 
} -after_submit {

ad_returnredirect [export_vars -base "one-resource" {{res_id $new_res_rev_id}}]
    ad_script_abort
}

ad_form -name file_write -form {
    {file_title:text(text)
        {label "[_ lors-central.item_title]"}
    }
    {content:richtext(richtext),optional 
	{label "Content"} 
	{html {rows 20 cols 60}}
    }
    {man_id:text(hidden)
	{value $man_id}
    }
    {res_id:text(hidden)
	{value $res_id}
    }
} -on_submit {
    set content_body [template::util::richtext::get_property contents $content]
    # Rebuild HTML if necessary
    if { [regexp -nocase {^(.*<\s*?body[^>]*?>).*(</\s*?body\s*?>.*)$} $content match header footer] } {
	set content_body "${header}${content_body}${footer}"
    }
    
    foreach {link id} [regexp -inline -all {<a href="\.\./o/(\d+?)">.*?</a>} $content_body] {
	# ns_log notice "DAVEB link '${link}' id '${id}"
	# find out if its an image
	if {[db_0or1row mime "select mime_type as this_mime_type, title as this_title 
                              from cr_revisions, cr_items  
                              where cr_items.item_id=:id and revision_id=live_revision"] } {
	    # ns_log notice "DAVEB mime_type '${this_mime_type}'"
	    if {[string match "image/*" $this_mime_type]} {
		regsub -all $link $content_body "<img src=\"images/${this_title}\" />" content_body
	    } else {
		# FIXME for now just throw away non image links until we can do something intelligent with them!
		regsub -all $link $content_body {} content_body
	    }
	}
    }
    set mime_type [template::util::richtext::get_property format $content]
    set new_res_rev_id [lors_central::add_file \
			    -filename $file_title \
			    -title $file_title \
			    -file_content $content_body \
			    -res_id $res_id \
			    -mime_type $mime_type \
			    -man_id $man_id ]

    
} -after_submit {
    ad_returnredirect [export_vars -base "one-resource" {{res_id $new_res_rev_id}}]
    ad_script_abort
}

