ad_page_contract {
    Displays all information about one file and all it's revisions
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
    man_id:notnull
    ims_item_id:notnull
    {org_id "" }
} {
    file_id:notnull
    {res_id ""}
    {name "" }
    {prev_file_id ""}
    ims_item_id:notnull
}

# Checking swa privilege over lors-central
lors_central::is_swa

#if { [empty_string_p $name] } {
#    set name [db_string get_name { } -default "..."]
#}
#if { [empty_string_p $org_id] } {
#    set name [db_string get_name { } -default "..."]
#}


set page_title "[_ lors-central.one_file] [_ lors-central.of_title]"

set context [list [list [export_vars -base one-resource {res_id}] "One Resource" ] [_ lors-central.one_file]]
# Get the file item_id and live_revision
set file_item_id [lors_central::get_item_id -revision_id $file_id]

# Get the type of the file for preview
set type [db_string get_prev_mime_type { }]
set prev_type [lindex [split $type "/"] 0]

template::list::create \
    -name file_list \
    -multirow files \
    -key file_id \
    -has_checkboxes \
    -bulk_actions { } \
    -bulk_action_method post \
    -bulk_action_export_vars { } \
    -row_pretty_plural "[_ lors-central.item_files]" \
    -elements {
	filename {
	    label "[_ lors-central.filename]"
	    display_template {
		<if @files.fileid@ eq $file_id>
		<b>&raquo; @files.filename@</b>
		</if>
		<else>
 		    @files.filename@
		</else>
	    }
	}
	preview {
	    display_template {
		<if @files.fileid@ eq $file_id>
		&nbsp;
		</if>
		<else>
		<a href="@files.prev_url@" title="[_ lors-central.click_for_prev]">[_ lors-central.preview]</a>
		</else>
	    }
	}
    }

db_multirow -extend { mime_type prev_url } files get_file_info { } {
    set mime_type [db_string get_mime_type { }]
    set prev_url [export_vars -base one-file {{file_id $fileid} res_id man_id}]
}


template::list::create \
    -name course_list \
    -multirow courses \
    -key course_id \
    -has_checkboxes \
    -bulk_actions { } \
    -bulk_action_method post \
    -bulk_action_export_vars { } \
    -row_pretty_plural "[_ lors-central.courses]" \
    -elements {
	coursename {
	    label "[_ lors-central.course_name]"
	    display_template {
		@courses.course_name@
	    }
	}
    }

db_multirow courses get_course_info { } {

}

set return_url [ad_return_url]
set edit_url [export_vars -base "file-content-edit" {ims_item_id file_id return_url res_id man_id}]
ad_return_template
