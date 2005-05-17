ad_page_contract {
   Displays all the information related to one course
} {
   item_id:integer,optional
   man_id:integer,optional
}

# Checking swa privilege over lors-central
lors_central::is_swa

if { ![info exist item_id] && ![info exist man_id] } {
   ad_return_complaint 1 "You must pass either item_id or man_id"
} else {
    if { ![info exist man_id] } {
       set man_id [content::item::get_live_revision -item_id $item_id]
    }
    if { ![info exist item_id] } {
       set item_id [lors_central::get_item_id -revision_id $man_id]
    }
}


set package_id ""
set title "[_ lors-central.one_course]"
set assoc_num [db_string get_associations_num { } -default 0]

if {[db_0or1row manifest { }]} {

    # Sets the variable for display. 
    set display 1
    
    # Course Name
    if {[empty_string_p $course_name]} {
	set course_name "[_ lorsm.No_course_Name]"
    }   

    # Version
    set version [lors_central::count_versions -item_id $item_id]

    if {[string equal $version "0"]} {
	set version_msg "[_ lorsm.No_version_Available]"
    } 
    
    # Instance
    set instance [lors_central::get_course_name -man_id $man_id]

    # Folder
    set root_folder [lors_central::get_root_folder_id]

    set folder [db_string get_folder_id { }]

    # Created By
    set created_by [person::name -person_id $creation_user]

    # Creation Date
    set creation_date [lc_time_fmt $creation_date "%x %X"]

    # Check for submanifests
    if {[db_0or1row submans "
           select 
                count(*) as submanifests 
           from 
                ims_cp_manifests 
           where 
                man_id = :man_id
              and
                parent_man_id = :man_id"]} {
    } else {
	set submanifests 0
    }


} else {

    set display 0
    
}


append orgs_list "<table class=\"list\" cellpadding=\"3\" cellspacing=\"1\" width=\"100%\">"
append orgs_list "<tr class=\"list-header\">
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">
            [_ lorsm.Organization]
        </th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">
            [_ lorsm.Metadata_1]
        </th>
        <th class=\"list\" valign=\"top\" style=\"background-color: #e0e0e0; font-weight: bold;\">
            [_ lorsm.Items]</th>
        </tr>"



db_foreach organizations { } {

    set total_items [db_string items_count {select count(*) from ims_cp_items where org_id=:org_id} -default 0]
    # We get the indent of the items in this org_id
    set indent_list [lors_central::get_items_indent -org_id $org_id]
    template::util::list_of_lists_to_array $indent_list indent_array

    append orgs_list "<tr class=\"list-even\">
                         <td valign=\"top\" width=\"15%\">
                             $org_title
                         </td>
                         <td valign=\"top\" align=\"center\" width=\"5%\">
                             $hasmetadata</td>
                         <td>"
    
    set missing_text "[_ lorsm.Nothing_here]"
    set return_url [export_vars -base [ns_conn url] man_id]
    set table_extra_html { width="100%" }
   
    set table_extra_vars {return_url man_id total_items indent_array}
    set table_def {
        {
	    reorder "" "no_sort" "<td width=5%>
            [if {![empty_string_p $identifierref]} {
                set min_item [db_string get_min_item { 
                                    select min(sort_order) from ims_cp_items
                                    where parent_item = (select parent_item
                                                         from ims_cp_items
                                                         where ims_item_id = :item_id)}]
                set max_item [db_string get_max_item { 
                                    select max(sort_order) from ims_cp_items
                                    where parent_item = (select parent_item
                                                         from ims_cp_items
                                                         where ims_item_id = :item_id)}]
                set childs_count [db_string get_max_item {
                                     select count(sort_order) from ims_cp_items
                                     where parent_item = (select parent_item
                                                          from ims_cp_items
                                                          where ims_item_id = :item_id) and 
                                                          ims_item_id in ( select live_revision from cr_items)}]

                if { $childs_count > 1 } {
                    if { [string equal $max_item $sort_order] } {
                       set href \"
                       <div align=center>
                       <a href=\'reorder-items?item_id=$item_id&org_id=$org_id&sort_order=$sort_order&dir=up\'>
                       <img border=0 src=images/up.gif>
                       </a></div>\"
                    } else {
                       if { [string equal $min_item $sort_order] } {
                          set href \"
                          <div align=center>
                          <a href=\'reorder-items?item_id=$item_id&org_id=$org_id&sort_order=$sort_order&dir=down\'>
                          <img border=0 src=images/down.gif>
                          </a></div>\"
                       } else {
                          set href \"
                          <div align=center>
                          <a href=\'reorder-items?item_id=$item_id&org_id=$org_id&sort_order=$sort_order&dir=up\'>
                          <img border=0 src=images/up.gif>
                          </a>
                          <a href=\'reorder-items?item_id=$item_id&org_id=$org_id&sort_order=$sort_order&dir=down\'>
                          <img border=0 src=images/down.gif>
                          </a></div>\"
                       }
                    }
                }
             }]
             </td>"
	}
	{ title "\#lorsm.Item_Name\#" \
	      "no_sort" \
	      "<td> [ set indent \"\"
                      for { set i 0 } { $i < [expr $indent_array($item_id)-1]} { incr i } {
                      append indent \"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\"
                      }
                      if {![empty_string_p $identifierref]} {
                          set href \"$indent<a href=\'one-learning-object?ims_item_id=$item_id&man_id=$man_id&name=$item_title\'>$item_title</a>\"
                       } else {
                          set href \"$item_title\"
                       }
                    ]" 
        }
        { add_object "\#lors-central.add_object\#" "no_sort" "
              <td><div align=center>
              [if {[string equal $parent_item $org_id]} {
                set href \"
                            <a href=\'new-learning-object?man_id=$man_id&org_id=$org_id&sort_order=$sort_order&parent=$item_id\'>
                [_ lors-central.add]</a>
                 </td></div></td></center>\"
              }]" 
        }
	{ metadata "\#lorsm.Metadata_1\#" 
                   "no_sort" 
                   "<td align=\"center\">[if {$hasmetadata == \"f\"} {
                                             set hasmetadata \"<a href=md/pbs-md/?ims_md_id=$item_id>No\"} else {set hasmetadata \"<a href=md/pbs-md/?ims_md_id=$item_id>Yes\"
                                          }]</a></td>" 
        }
	{ type   "\#lorsm.Type\#" "no_sort" "<td align=\"center\">$type</td>" }
    }

    set table_item [ad_table -Tmissing_text $missing_text -Textra_vars $table_extra_vars -Theader_row_extra "style=\"background-color: #e0e0e0; font-weight: bold;\" class=\"list-header\"" -Ttable_extra_html $table_extra_html ad_table_contents_query { } $table_def]

   append orgs_list "$table_item"
   append orgs_list "</td></tr>
                     <tr>
                        <td>
                        <a href=\"new-learning-object?org_id=$org_id&man_id=$man_id&parent=$org_id\" class=button>
                        [_ lors-central.add_object]
                        </a>
                        </td>
                     </tr>"
} if_no_rows {
    append orgs_list "<tr class=\"list-odd\"><td></td></tr>"
}

append orgs_list "</table>"

