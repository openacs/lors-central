ad_page_contract {
    List files used in this object
    @param res_id
    @param ims_item_id
}

if {![exists_and_not_null res_id]} {
    set res_id [lors_central::get_item_res_id -ims_item_id $ims_item_id]
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set clipboard_id [db_string get_cb_id { } -default ""]
if { [empty_string_p $clipboard_id] } {
    # Create the clipboard_id 
    set clipboard_id [clipboard::new -owner_id $user_id -title "Lors Central" \
			  -package_id $package_id -creation_user_id $user_id]

}
db_multirow -extend {edit edit_url clip clip_url count one_file_url main_file} files get_files2 { } {
    set edit "Edit"
    set edit_url [export_vars -base one-object-edit {res_id}]
    set clip "Clip"
    set clip_url [export_vars -base "/clipboard/attach" {{object_id $file_id} clipboard_id}]
    set file_item_id [db_string get_file_item_id { } -default 0]
    set count [db_string get_revision_count { } -default 0]
    set one_file_url [export_vars -base one-file {file_id res_id ims_item_id}]
    if {$main_file_p} {
	set main_file "Main File"
    } else {
	set main_file ""
    }
}

# To action buttons one for adding a new file to this resource
# and the second one to clip all the resource ( all files )
set actions_list [list \
		      [_ lors-central.add_file] [export_vars -base "new-file" {res_id}] \
		      [_ lors-central.add_file] \
		      [_ lors-central.clip_this_res] \
		      [export_vars -base "/clipboard/attach" {{object_id $res_id} clipboard_id}] \
		      [_ lors-central.clip_this_res]]
		   
template::list::create \
    -name files \
    -multirow files \
    -actions $actions_list \
    -elements {
	title {
	    label "Title" 
	    display_template {
	    <a href=@files.one_file_url@ title="[_ lors-central.Edit] [_ lors-central.this_file]"><img border=0 src=/resources/Edit16.gif></a>
		&nbsp;&nbsp;
		<a href="@files.one_file_url@" title="[_ lors-central.view] [_ lors-central.this_file] [_ lors-central.description]">@files.title@</a>
	    }
	}
	rev_count {
	    label "[_ lors-central.versions]" 
	    display_template {
		<center>@files.count@</center>
	    }
	}
	mime_type_pretty {label "Type"}
	main_file {label ""}
	clip {label "" link_url_col {clip_url}}
    }