ad_page_contract {
    Upload an IMS Content Package

    Scope:

    1.- Uploads file
    2.- Unzip file
    3.- Finds imsmanifest.xml
    4.- Displays basic imsmanifest.xml information

    @author Ernie Ghiglione (ErnieG@mm.st)
    @creation-date 19 March 2003
    @cvs-id $Id$
} {
    upload_file:trim,optional
    upload_file.tmpfile:optional,tmpfile
    course_id:integer,notnull
    indb_p:integer,notnull
    man_id:optional

} -validate {
    non_empty -requires {upload_file.tmpfile:notnull} {
        if {![empty_string_p $upload_file] && (![file exists ${upload_file.tmpfile}] || [file size ${upload_file.tmpfile}] < 4)} {
            ad_complain "[_ lorsm.lt_The_upload_failed_or_]"
        }
    }
}

# Checking privilege over lors-central
lors_central::check_permissions

# To support versions
if { ![info exists man_id] } {
    set man_id ""
}

# Permissions
set user_id [ad_conn user_id]
# dotlrn::require_user_admin_community -user_id $user_id -community_id [dotlrn_community::get_community_id]

# unzips the file
if { ![empty_string_p $upload_file] &&
     [ catch {set tmp_dir [lors::imscp::expand_file $upload_file ${upload_file.tmpfile} lors-imscp-$course_id] } errMsg] } {
    ad_return_complaint 1 "[_ lorsm.lt_The_uploaded_file_doe]"
    ad_script_abort
}

# if it is not blank...
if {![empty_string_p $upload_file]} {
    ns_log Debug "LORS Package: made directory $tmp_dir to extract from ${upload_file.tmpfile} ($upload_file)\n"
    set allfiles [lors::imscp::dir_walk $tmp_dir]

} else {
    set allfiles [lors::imscp::dir_walk $directory]

}

# Get LORSM Root folder_id
set folder_id [lors_central::get_root_folder_id]


# search for manifest file
set file imsmanifest.xml

set manifest [lors::imscp::findmanifest $tmp_dir $file]

# see if the file actually is where it suppose to be. Othewise abort
if {$manifest == 0} {
        lors::imscp::deltmpdir $tmp_dir
        ad_return_complaint 1 "[_ lorsm.lt_There_is_no_file_with_1]"
}


# Is this a Blackboard6 package?
set isBB [lors::imscp::bb6::isBlackboard6 -tmp_dir $tmp_dir]

if {$isBB == 1} {
    # we generate metadata for the file
    ns_log Notice "Generating MD record from Blackboard6 package $tmp_dir --"
    lors::imscp::bb6::create_MD -tmp_dir $tmp_dir -file $file
    ns_log Notice "Done!"

}

## adds folder to the CR
set parent_id $folder_id
set fs_dir $tmp_dir

# checks for write permission on the parent folder
ad_require_permission $parent_id write

# get their IP
set creation_ip [ad_conn peeraddr]

# checks whether the directory given actually exists
if {[file exists $fs_dir]} {
    set all_files [list]
    # now that exists, let's create it on the CR

    ##  Create lists and multirows
    multirow create element_nodes element attributes

    template::list::create \
        -name d_info \
        -multirow d_info \
        -no_data "[_ lorsm.No_Information]" \
        -elements {
            col1 {
                label ""
                html {valign top style "background-color: #e0e0e0; font-weight: bold;"}
            }
            col2 {
                label ""
                html {valign top style "background-color: #f0f0f0; font-weight: bold;"}
            }
        }

    multirow create d_info col1 col2


    template::list::create \
        -name d_IMS_package_info \
        -multirow d_IMS_package_info \
        -no_data "[_ lorsm.lt_No_IMS_Package_struct]" \
        -elements {
            organizations {
                label "[_ lorsm.Organizations]"
                html {valign top align center}
            }
            items {
                label "[_ lorsm.Items]"
                html {valign top align center}
            }
            resources {
                label "[_ lorsm.Resources]"
                html {valign top align center}
            }
            files {
                label "[_ lorsm.Files]"
                html {valign top align center}
            }
        }

    multirow create d_IMS_package_info organizations items resources files

    template::list::create \
        -name d_SCORM_package_info \
        -multirow d_SCORM_package_info \
        -no_data "[_ lorsm.No_Items]" \
        -elements {
            scos {
                label "[_ lorsm.SCOs]"
                html {valign top}
            }
            assets {
                label "[_ lorsm.Assets]"
                html {valign top}
            }
            sharableresources {
                label "[_ lorsm.Sharable_Resources]"
                html {valign top}
            }
            files {
                label "[_ lorsm.files]"
                html {valign top}
            }
        }

    multirow create d_SCORM_package_info scos assets sharableresources files

    ## Opens imsmanifest.xml

    # open manifest file with tDOM
    set doc [dom parse [read [open $manifest]]]
    # gets the manifest tree
    set manifest [$doc documentElement]

    # gets metadata node
    set metadata [$manifest child all metadata]

    # DETECT SCORM OR IMS CP
    set isSCORM [lors::imscp::isSCORM -node $manifest]

    ## Gets manifest title

    if { ![empty_string_p $metadata] } {

	# gets metadataschema
        set MetadataSchema [lindex [lindex [lors::imsmd::getMDSchema $metadata] 0] 0]
        set MetadataSchemaVersion [lindex [lors::imsmd::getMDSchema $metadata] 1]        
        set lom [lindex [lors::imsmd::getLOM $metadata $tmp_dir] 0]
        set prefix [lindex [lors::imsmd::getLOM $metadata $tmp_dir] 1]

        if { $lom != 0 } {
            # Get title
            set manifest_title_lang [lindex [lindex [lors::imsmd::mdGeneral -element title -node $lom -prefix $prefix] 0] 0]
            set manifest_title [lindex [lindex [lors::imsmd::mdGeneral -element title -node $lom -prefix $prefix] 0] 1]
            # set context
            set context "[_ lorsm.lt_Importing_manifest_ti]"

            ## Gets manifest description
            
            set manifest_descrip_lang [lindex [lindex [lors::imsmd::mdGeneral -element description -node $lom -prefix $prefix] 0] 0]
            set manifest_descrip [lindex [lindex [lors::imsmd::mdGeneral -element description -node $lom -prefix $prefix] 0] 1]

            # adds course information for display
            multirow append d_info "Manifest Title: " "\[$manifest_title_lang\] $manifest_title "
            multirow append d_info "Metadata Type: " [concat $MetadataSchema $MetadataSchemaVersion]
            if {![empty_string_p $manifest_descrip]} {
                multirow append d_info "Description: " "\[$manifest_descrip_lang\] $manifest_descrip"
            }
            # Gets Rights info
            set copyright [lors::imsmd::mdRights -element copyrightandotherrestrictions -node $lom -prefix $prefix]
            if { $copyright != 0 } {
                set copyright_s [lindex [lindex [lindex $copyright 0] 0] 1]
                set copyright_v [lindex [lindex [lindex $copyright 0] 1] 1]
                set cr_descrip [lors::imsmd::mdRights -element description -node $lom -prefix $prefix]
                set cr_descrip_s [lindex [lindex $cr_descrip 0] 1]

                multirow append d_info "Copyrighted?: " "\[$copyright_s\] $copyright_v"
                multirow append d_info "Copyrighted Description: " "$cr_descrip_s"

            } else {
                multirow append d_info "Copyrighted?: " "Information not available"
            }
        } else {
	    # Didn't find LOM although it did find the Metadata schema and
	    # version 
	    regexp {([^/\\]+)$} $tmp_dir match manifest_title
	    set context "[_ lorsm.lt_Importing_No_Metadata]"
	}
    } else {
	# manifest title doesn't exist, so we create one for it. 
	regexp {([^/\\]+)$} $tmp_dir match manifest_title
        set context "[_ lorsm.lt_Importing_No_Metadata]"
    }


    # Gets the organizations

    set organizations [$manifest child all organizations]

    if { ![empty_string_p $organizations] } {

	set num_organizations [$organizations child all organization]

        multirow append d_info "Number of Organizations: " [llength $num_organizations]

        set items 0

        foreach organization $num_organizations {

            set items  [expr $items + [lors::imscp::countItems $organization]]

        }
        multirow append d_info "Number of Items: " $items
    }

    # gets the resources
    set resources [$manifest child all resources]

    # Complain if there's no resources
    if {[empty_string_p $resources]} {
	ad_return_complaint 1 "[_ lorsm.lt_The_package_you_are_t_1]"
    ad_script_abort
    } 

    set resourcex [$resources child all resource]

    if { $isSCORM == 1 } {
        # The imsmanifest.xml file contains a SCORM course 
        
        # extract all the resources and files
        set scos 0
        set assets 0
        set sharableresources 0
        set files 0
        
        if { ![empty_string_p $resources] } {
            
            foreach resourcex [$resources child all resource] {
                
                # gets the type of resource
                set resource_scormtype [string tolower [lors::imsmd::getAtt $resourcex adlcp:scormtype]]

                switch $resource_scormtype {
                    sco {
                        incr scos
                    }
                    asset {
                        incr assets
                    }
                    sharableresource {
                        incr sharableresources
                    }
                }

                set files [expr $files + [llength [lors::imsmd::getResource -node $resourcex -att files]]]

            }
        }

        multirow append d_SCORM_package_info $scos $assets $sharableresources $files



        # end isSCORM if
    } else {
        # The imsmanifest.xml file corresponds to a IMS CP (but not SCORM)

        set files 0
        if { ![empty_string_p $resourcex] } {

            foreach resource $resourcex {
                set files [expr $files + [llength [lors::imsmd::getResource -node $resource -att files]]]
            }
        }
        multirow append d_IMS_package_info [llength $num_organizations] $items [llength $resourcex] $files

    }


} else {
    # Error MSG here
    ad_return_complaint 1 "[_ lorsm.lt_There_has_been_a_prob]"
    ad_script_abort

}

template::form create course_upload -action course-add-3 \
    -display_buttons { {"[_ lorsm.Upload_Course]" upload_course} }  \
    -html {enctype multipart/form-data} \
    -mode edit \
    -cancel_url "[_ lorsm.index]" 


template::element create course_upload course_name  \
  -label "[_ lorsm.Course_Name]" -datatype text -widget text -help_text "[_ lorsm.lt_This_is_the_name_the_]" \
  -maxlength 200

template::element create course_upload course_id  \
  -label "[_ lorsm.course_id]" -datatype integer -widget hidden 

template::element create course_upload indb_p  \
  -label "[_ lorsm.indb_p]" -datatype integer -widget hidden 

template::element create course_upload tmp_dir  \
  -label "[_ lorsm.tmp_dir]" -datatype text -widget hidden -optional

template::element create course_upload folder_id  \
  -label "[_ lorsm.folder_id]" -datatype integer -widget hidden -optional

template::element create course_upload isSCORM  \
  -label "[_ lorsm.isSCORM]" -datatype integer -widget hidden -optional


if { ![empty_string_p $man_id] } {
    set version_id [db_string get_version_id  "select item_id from cr_revisions where revision_id = :man_id"]
    template::element create course_upload version_id -datatype integer -widget hidden -optional
    template::element set_properties course_upload version_id -value $version_id 
}

template::element set_properties course_upload course_id -value $course_id

template::element set_properties course_upload indb_p -value $indb_p

template::element set_properties course_upload tmp_dir -value $tmp_dir

template::element set_properties course_upload folder_id -value $folder_id

template::element set_properties course_upload isSCORM -value $isSCORM

template::element set_properties course_upload course_name -value $manifest_title





