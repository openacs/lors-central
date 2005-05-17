ad_page_contract {
    Displays all the information about one learning object (ims_item_id)
    
    @author         Miguel Marin (miguelmarin@viaro.net)
    @author         Viaro Networks www.viaro.net
    @creation-date  2005-03-17
} {
    man_id:integer
    ims_item_id:integer
    {name ""}
    {orderby "class,asc"}
}

# Checking swa privilege over lors-central
lors_central::is_swa

set displayed_object_id $ims_item_id

# Get the item_id that the ims_item_id has associated
set item_id [lors_central::get_item_id -revision_id $ims_item_id]
set man_item_id [lors_central::get_item_id -revision_id $man_id]
set course_name [lors_central::get_course_name -man_id $man_id]
set org_id [db_string get_org_id { } -default ""]


# Get the live revision for preview

set last_version [db_string get_live_revision { }]
set file_revision [lors_central::get_content_revision_id -ims_item_id $ims_item_id]
if { [empty_string_p $name] } {
    set name [db_string get_name { }]
}

if { [string equal $file_revision 0] } {
    # The items is probably an URL so we are going to get it
    set file_prev_id [lors_central::get_item_url -ims_item_id $ims_item_id -man_id $man_id]
    set prev_type ""
} else {
    set file_prev_id [lors_central::get_item_id -revision_id $file_revision]
    set prev_type [db_string get_prev_mime_type { } -default ""]
    set prev_type [lindex [split $prev_type "/"] 0]
}


####################################      Versions Template      #################################################
set num 0
db_multirow -extend { ver_num date author mime_type num file_id} item_versions get_versions { } {
    set ver_num [lors_central::get_version_num -revision_id $ims_item_id]
    set date [lindex $last_modified 0]
    append date " [lindex [split [lindex $last_modified 1] "."] 0]"
    set author [lors_central::get_username -user_id $user_id]
    set file_id [lors_central::get_res_file_id -res_id $res_id]
    if { ![string equal $file_id ""] } {
        set mime_type [db_string get_mime_type { } -default ""]
        if { [string equal $ims_item_id $last_version] } {
             set live_file_id $file_id
	}
    } else {
        set mime_type "URL"
        set live_file_id 0
    }
    set num [expr $num + 1]
    if {$displayed_object_id == $ims_item_id} {
	set displayed_object_title $item_name
    }
}

template::list::create \
    -name item_versions \
    -multirow item_versions \
    -key ims_item_id \
    -bulk_action_method post \
    -has_checkboxes \
    -bulk_action_export_vars {
    } \
    -row_pretty_plural "[_ lors-central.item_versions]" \
    -elements {
        version_number {
	    label "[_ lors-central.version_number]"
            display_template {
            <if $displayed_object_id eq @item_versions.ims_item_id@>
		<center><b>&raquo; @item_versions.ver_num@</b></center>
            </if>
            <else>
		<center>@item_versions.ver_num@</center>
            </else>
	    }
	}
	course_name {
            label "[_ lors-central.item_name]"
            display_template {
            <a href="one-resource?res_id=@item_versions.res_id@">
            <if $displayed_object_id eq @item_versions.ims_item_id@>
                <b>@item_versions.item_name@</b>
            </if>
            <else>
                   @item_versions.item_name@
            </else>
            </a>
	    }
	} 
        author {
            label "[_ lors-central.author]"	    
            display_template {
                <a href="/shared/community-member?user_id=@item_versions.user_id@">@item_versions.author@</a>
	    }	    
	}
        last_modified {
            label "[_ lors-central.last_modified]"	    
            display_template {
                @item_versions.date@
	    }	    
	}
        mime_type {
            label "[_ lors-central.type]:"	    
            display_template {
                @item_versions.mime_type@
	    }	    
	}
	make_live {
            display_template {
		[_ lors-central.make]&nbsp;
		<a href="change-lo-version?ims_item_id=@item_versions.ims_item_id@&man_id=$man_id&item_id=$item_id&name=$name&live_hide_p=live">[_ lors-central.live]<a>
                /
		<a href="change-lo-version?ims_item_id=@item_versions.ims_item_id@&man_id=$man_id&item_id=$item_id&name=$name&live_hide_p=hide">[_ lors-central.hide]</a>&nbsp;
                [_ lors-central.everywhere]
	    }
	} 
    }

###################################      Associations Template      #################################################

template::list::create \
    -name courses \
    -multirow cl_list \
    -key com_id \
    -has_checkboxes \
    -bulk_actions { #lors-central.update_versions# "change-one-lo-version" #lors-central.update_course_ver# } \
    -bulk_action_method post \
    -bulk_action_export_vars { man_id name ims_item_id } \
    -row_pretty_plural "[_ lors-central.dotlrn_classes]" \
    -elements {
	class  {
	    label "[_ lors-central.class_name]"
	    display_template {
		@cl_list.pretty_name@
	    }
	}
	subject  {
	    label "[_ lors-central.subject_name]"
	    display_template {
		    @cl_list.class_name@
	    }
	}
	term_name  {
	    label "[_ lors-central.term_name]"
	    display_template {
		    @cl_list.term_name@
	    }
	}
	current  {
	    label "[_ lors-central.current]"
	    display_template {
                <if @cl_list.hide_p@>
                     0
                </if>
                <else>
		@cl_list.ver_num@ 
		</else>
                [_ lors-central.of] @cl_list.ver_count@
	    }
	}
	set_to  {
	    label "[_ lors-central.set_to]"
	    display_template {
                <input type=hidden name="objects_id" value=@cl_list.com_id@>
                <input type=hidden name="objects_count" value=@cl_list.ver_count@>
                <select name="objects_value">
  		    @cl_list.options;noquote@
                </select>
	    }
	}
        views {
            label "[_ lors-central.views_in]"
	    display_template {
		<center>
		<a href="tracking/?man_id=@cl_list.manifest_id@&community_id=@cl_list.com_id@&item_id=$ims_item_id">
                [_ lors-central.views]
		</a>
		</center> 
	    }
	}
    } -filters { 
	man_id {} 
    } -orderby { 
	class  {
	    orderby_asc {pretty_name asc}
            orderby_desc {pretty_name desc}
	}
	subject  {
	    orderby_asc {class_name asc}
            orderby_desc {class_name desc}
	}
	term_name  {
	    orderby_asc {term_name asc}
            orderby_desc {term_name desc}
	}
    }
    
set orderby_clause [template::list::orderby_clause -orderby -name "courses"]

db_multirow -extend { ver_num  ver_count manifest_id options hide_p } cl_list get_dotlrn_classes { } {
    set manifest_id [lors_central::get_man_id -community_id $com_id -item_id $man_item_id]
    set ims_item [db_string get_ims_item_id { }]    
    set hide_p  [db_string get_hide_p { }]
    set ver_num [lors_central::get_version_num -revision_id $ims_item]
    set ver_count [lors_central::get_revision_count -revision_id $ims_item_id]
    # Create the options for the select menu
    set options ""
    for { set i 0 } { $i < [expr $ver_count + 1] } { incr i } {
	if { [string equal $i $ver_num] } {
            append options "<option value=$i selected>$i</options>"
	} else {
            append options "<option value=$i>$i</options>"
	}
    }
}

set title "${course_name}: ${item_title}"
set context [list [list "one-course?man_id=$man_id" [_ lors-central.one_course]] "[_ lors-central.One_learning]"]

ad_return_template
