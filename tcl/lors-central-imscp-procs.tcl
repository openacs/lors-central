ad_library {
    IMS Content Packaging functions

}

namespace eval lors_central::imscp {}

# IMS CP database transaction functions
ad_proc -public lors_central::imscp::manifest_add {
    {-man_id ""}
    {-identifier ""}
    {-course_name ""}
    {-version ""}
    {-orgs_default {}}
    {-hasmetadata ""}
    {-parent_man_id ""}
    {-isscorm ""}
    {-folder_id ""}
    {-package_id ""}
    {-community_id ""}
    {-user_id ""}
    {-creation_ip ""}
    {-version_id ""}
    {-course_presentation_format "-1"}
    -man_folder_id:required
} {
    Inserts a new manifest according to the imsmanifest.xml file.

    @option man_id manifest id to be inserted.
    @option course_name the actual name of the course (or resource).
    @option identifier intrinsic manifest identifier. 
    @option version version.
    @option orgs_default default organizations value.
    @option hasmetadata whether the manifest has metadata (boolean).
    @option parent_man_id parent manifest id (for manifest with submanifests).
    @option isscorm wheather the manifest is SCORM compliant
    @option folder_id the CR folder ID we created to put the manifest on.
    @option package_id package_id for the instance of LORSm
    @option community_id Community ID
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }
    if {[empty_string_p $parent_man_id]} {
        set parent_man_id 0
    }
    if {[empty_string_p $isscorm]} {
        set isscorm 0
    }

    if {[empty_string_p $community_id]} {
        set community_id ""
    }


    #########################################################################################
    # Since now we dont use acs-objects for the manifest, then a new cr_item and revision
    # needs to be done to store the manifest. The cr_item and cr_revision are created here
    # in orther to use the CR API.

    # Get LORSM Manifest Folder folder_id
    set parent_id $man_folder_id
    set content_type "ims_manifest_object" 
    set name "$course_name"
    if {[empty_string_p $version_id]} {
        set item_id [content::item::new -name $name -item_id $man_id -content_type $content_type -parent_id $parent_id \
                     -creation_date [dt_sysdate] -creation_user $user_id -creation_ip $creation_ip -context_id $package_id]
    
        # We give the user_id admin privilege over the item_id so only he/she can make changes to
        # this course, unless it grants other user privileges
        permission::grant -party_id $user_id -object_id $item_id -privilege admin
        
        # The new course has for default its isshared value false
        set isshared f

    } else {
        set item_id $version_id
	set isshared [db_string get_isshared "select im.isshared from ims_cp_manifests im where im.man_id = (
                                                  select live_revision from cr_items where item_id = :version_id
                                              ) "]
    }

    set revision_id [content::revision::new -title $name -content_type $content_type -creation_user $user_id \
                         -creation_ip $creation_ip -item_id $item_id -is_live "t"] 

    # Now the new revision_id will be sent to the sql function with the 
    # additional information as before

    db_transaction {
        set manifest_id [db_exec_plsql new_manifest {
                select ims_manifest_admin__new (
                                    :course_name,
                                    :identifier,
                                    :version,
                                    :orgs_default,
                                    :hasmetadata,
                                    :parent_man_id,
                                    :isscorm,
                                    :parent_id,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id,
				    :revision_id,
                                    :isshared,
				    :course_presentation_format
                                    );

        }]
    }
    return $manifest_id
}


ad_proc -public lors_central::imscp::addItems {
    -itm_folder_id:required
    {-org_id:required}
    {itemlist} 
    {parent ""}
    {tmp_dir ""}
} {
    Bulk addition of items. 
    Returns a list with the item_id and the identifierref of each item.

    @option org_id Organization Id that the item belongs to. 
    @option itemlist list of items to be uploaded
    @option parent parent item node (items can have subitems).
    @author Ernie Ghiglione (ErnieG@mm.st)

} {
    # set utf-8 system encoding
    encoding system utf-8

    set retlist ""

    foreach item $itemlist {
        set p_org_id $org_id
        set p_parent_item $parent
        set p_identifier [lindex $item 1]
        set p_identifierref [lindex $item 2]
        set p_isvisible [lindex $item 3]
        set p_parameters [lindex $item 4]
        set p_title [lindex $item 5]
        set p_hasmetadata [lindex $item 6]
        set p_prerequisites [lindex $item 7]
        set p_prerequisites_type [lindex $p_prerequisites 0]
        set p_prerequisites_string [lindex $p_prerequisites 1]
        set p_maxtimeallowed [lindex $item 8]
        set p_timelimitaction [lindex $item 9]
        set p_datafromlms [lindex $item 10]
        set p_masteryscore [lindex $item 11]
	set p_dotlrn_permission [lindex $item 12]

        if {$p_hasmetadata != 0} {
            set md_node $p_hasmetadata
            set p_hasmetadata 1
        }

        set item_id [lors_central::imscp::item_add \
                         -org_id $p_org_id \
                         -parent_item $p_parent_item \
                         -identifier $p_identifier \
                         -identifierref $p_identifierref \
                         -isvisible $p_isvisible \
                         -title $p_title \
                         -hasmetadata $p_hasmetadata \
                         -prerequisites_t $p_prerequisites_type \
                         -prerequisites_s $p_prerequisites_string \
                         -maxtimeallowed $p_maxtimeallowed \
                         -timelimitaction $p_timelimitaction \
                         -datafromlms $p_datafromlms \
                         -masteryscore $p_masteryscore \
			 -dotlrn_permission $p_dotlrn_permission \
                         -itm_folder_id $itm_folder_id]

        if {$p_hasmetadata == 1} {
            set aa [lors::imsmd::addMetadata \
                        -acs_object $item_id \
                        -node $md_node \
                        -dir $tmp_dir]
        }

        lappend retlist [list $item_id $p_identifierref]

        if { [llength $item] > 13} {
            set subitem [lors_central::imscp::addItems -itm_folder_id $itm_folder_id \
                             -org_id $p_org_id [lindex $item 13] $item_id $tmp_dir]
            set retlist [concat $retlist $subitem]
        }
    }
    return $retlist
}

ad_proc -public lors_central::imscp::item_add {
    {-item_id ""}
    -org_id:required
    {-identifier ""}
    {-identifierref ""}
    {-isvisible ""}
    {-parameters ""}
    {-title ""}
    {-parent_item ""}
    {-hasmetadata ""}
    {-prerequisites_t ""}
    {-prerequisites_s ""}
    {-type ""}
    {-maxtimeallowed ""}
    {-timelimitaction ""}
    {-datafromlms ""}
    {-masteryscore ""}
    {-dotlrn_permission ""}
    {-package_id ""}
    {-user_id ""}
    {-creation_ip ""}
    -itm_folder_id:required

} {
    Inserts a new item according to the info retrieved from the imsmanifest.xml file.

    @option item_id item id to be inserted.
    @option org_id organization_id the item belogs to.
    @option identifier intrinsic item identifier. 
    @option identifierref items indentifier reference (use to map with resources)
    @option isvisible is the item visible?.
    @option parameters items parameters
    @option title items title.
    @option parent_item for recursive items. Items can have subitems.
    @option hasmetadata whether the item has metadata (boolean).
    @option prerequisites_t items prerequisites type (SCORM extension).
    @option prerequisites_s items prerequisites string (SCORM extension).
    @option type items type (SCORM extension).
    @option maxtimeallowed items maximum time allowed (SCORM extension).
    @option timelimitaction items time limit action (SCORM extension).
    @option datafromlms items data from LMS (SCORM extension).
    @option masteryscore items mastery score (SCORM extension).
    @option dotlrn_permission dotlrn extension to incoporate permissions.
    @option package_id Package id.
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }
    if {[empty_string_p $isvisible]} {
        set isvisible 1
    }
    if {$parent_item == 0} {
        set parent_item $org_id
    }
    if {[empty_string_p $title]} {
        set title "No Title"
    }

    #--------------------------------------------------------------------------------------#
    # Since now we dont use acs-objects for the item, then a new cr_item and revision
    # needs to be done to store it. The cr_item and cr_revision are created here
    # in orther to use the CR API. The item name probably has to change

    # Get LORSM Item Folder folder_id
    set parent_id $itm_folder_id
    set content_type "ims_item_object" 
    set sysdate [dt_sysdate]
    set name "$identifier"
    set cr_item_id [content::item::new -name $name -item_id $item_id -content_type $content_type -parent_id $parent_id \
                     -creation_date [dt_sysdate] -creation_user $user_id -creation_ip $creation_ip \
                     -context_id $package_id -description $title]


    set revision_id [content::revision::new -title $name -content_type $content_type -creation_user $user_id \
			 -creation_ip $creation_ip -item_id $cr_item_id -is_live "t"] 

    db_transaction {
        set item_id [db_exec_plsql new_item {
                select ims_item__new (
                                    :item_id,
                                    :org_id,
                                    :identifier,
                                    :identifierref,
                                    :isvisible,
                                    :parameters,
                                    :title,
                                    :parent_item,
                                    :hasmetadata,
                                    :prerequisites_t,
                                    :prerequisites_s,
                                    :type,
                                    :maxtimeallowed,
                                    :timelimitaction,
                                    :datafromlms,
                                    :masteryscore,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id,
				    :revision_id
                                    );

        }
                        ]

    }

    if {![empty_string_p $dotlrn_permission]} {
	
	permission::toggle_inherit -object_id $item_id


	set community_id [dotlrn_community::get_community_id]

	# Set read permissions for community/class dotlrn_admin_rel

	# set party_id_admin [db_string party_id {select segment_id from rel_segments \
						     where group_id = :community_id \
						     and rel_type = 'dotlrn_admin_rel'}]

	# permission::grant -party_id $party_id_admin -object_id $item_id -privilege read
	

	# Set read permissions for *all* other professors  within .LRN
	# (so they can see the content)

        set party_id_professor [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_professor_profile_rel'}]

	permission::grant -party_id $party_id_professor -object_id $item_id -privilege read

	# Set read permissions for *all* other admins within .LRN
	# (so they can see the content)

        set party_id_admins [db_string party_id {select segment_id from rel_segments \
                                                     where rel_type = 'dotlrn_admin_profile_rel'}]

	permission::grant -party_id $party_id_admins -object_id $item_id -privilege read

	ns_log Notice "ims_item_id ($item_id)  read permissions granted for community admins"


    }

    return $item_id
}

ad_proc -public lors_central::imscp::resource_add {
    {-res_id ""}
    -man_id:required
    {-identifier ""}
    {-type ""}
    {-href ""}
    {-scorm_type ""}
    {-hasmetadata ""}
    {-package_id ""}
    {-user_id ""}
    {-creation_ip ""}
    {-num ""}
    -res_folder_id:required

} {
    Inserts a new resource according to the imsmanifest.xml file.

    @option res_id resource id to be inserted.
    @option man_id manifest the resource belogs to (required).
    @option identifier intrinsic item identifier.
    @option type item type.
    @option href location or references to item location.
    @option scorm_type SCORM item type (SCORM extension).
    @option hasmetadata whether the item has metadata (boolean).
    @option package_id Package id.
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }

    #--------------------------------------------------------------------------------------#
    # Since now we dont use acs-objects for the resource, then a new cr_item and revision
    # needs to be done to store it. The cr_item and cr_revision are created here
    # in orther to use the CR API. The item name probably has to change

    # Get LORSM Resource Folder folder_id
    set parent_id $res_folder_id
    set content_type "ims_resource_object" 
    set name "$identifier"
    set item_id [content::item::new -name $name -content_type $content_type -parent_id $parent_id \
                     -creation_date [dt_sysdate] -creation_user $user_id -creation_ip $creation_ip -context_id $package_id]


    set revision_id [content::revision::new -title $name -content_type $content_type -creation_user $user_id \
			 -creation_ip $creation_ip -item_id $item_id -is_live "t"] 

    db_transaction {
        set resource_id [db_exec_plsql new_resource {
                select ims_resource__new (
                                    :res_id,
                                    :man_id,
                                    :identifier,
                                    :type,
                                    :href,
                                    :scorm_type,
                                    :hasmetadata,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id,
				    :revision_id
                                    );

        }
                        ]

    }
    return $resource_id
}

ad_proc -public lors_central::imscp::organization_add {
    {-org_id ""}
    -man_id:required
    {-identifier ""}
    {-structure ""}
    {-title ""}
    {-hasmetadata ""}
    {-package_id ""}
    {-user_id ""}
    {-creation_ip ""}
    -org_folder_id:required

} {
    Inserts a new organizations according to the imsmanifest.xml file.

    @option org_id organization id to be inserted.
    @option man_id manifest_id the organization belogs to.
    @option identifier intrinsic organization identifier. 
    @option structure organization structure.
    @option title organization title.
    @option hasmetadata whether the organization has metadata (boolean).
    @option package_id Package id.
    @option user_id user that adds the category. [ad_conn user_id] used by default.
    @option creation_ip ip-address of the user that adds the category. [ad_conn peeraddr] used by default.
    @author Ernie Ghiglione (ErnieG@mm.st)
} {
    # set utf-8 system encoding
    encoding system utf-8

   if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    if {[empty_string_p $creation_ip]} {
        set creation_ip [ad_conn peeraddr]
    }
    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }

    #--------------------------------------------------------------------------------------#
    # Since now we dont use acs-objects for the organizations, then a new cr_item and revision
    # needs to be done to store it. The cr_item and cr_revision are created here
    # in orther to use the CR API. The item name probably has to change

    # Get LORSM Organizations Folder folder_id
    set parent_id $org_folder_id
    set content_type "ims_organization_object" 
    set name "$identifier"
    set item_id [content::item::new -name $name -item_id $org_id -content_type $content_type -parent_id $parent_id \
                     -creation_date [dt_sysdate] -creation_user $user_id -creation_ip $creation_ip -context_id $package_id]


    set revision_id [content::revision::new -title $name -content_type $content_type -creation_user $user_id \
			 -creation_ip $creation_ip -item_id $item_id -is_live "t"] 

    db_transaction {
        set organization_id [db_exec_plsql new_organization {
                select ims_organization__new (
                                    :org_id,
                                    :man_id,
                                    :identifier,
                                    :structure,
                                    :title,
                                    :hasmetadata,
                                    current_timestamp,
                                    :user_id,
                                    :creation_ip,
                                    :package_id,
				    :revision_id
                                    );

        }
                        ]

    }
    return $organization_id
}