# packages/lors-central/tcl/lors-central-install-procs.tcl

ad_library {
    
    LORS CENTRAL Installation procedures
    
    @author Miguel Marin (miguelmarin@viaro.net)
    @author Viaro Networks www.viaro.net
}

#
#
#  This package is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  It is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#


namespace eval lors_central::install {}

ad_proc -private lors_central::install::package_install {} {

    Install creates the lors-central folders
    
} {
    # Create the root folder to store the LO's
    set folder_id [content::folder::new -name "LORSM Root Folder" -label "LORSM Root Folder"]
    content::folder::register_content_type -folder_id $folder_id -content_type "content_revision" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_folder" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_symlink" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_extlink" \
        -include_subtypes "t"

    # Create the root folder to store the LO's Manifests
    set folder_id [content::folder::new -name "LORSM Manifest Folder" -label "LORSM Manifest Folder"]
    content::folder::register_content_type -folder_id $folder_id -content_type "ims_manifest_object" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_revision" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_folder" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_symlink" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_extlink" \
        -include_subtypes "t"

    # Create the root folder to store the LO's Organizations
    set folder_id [content::folder::new -name "LORSM Organizations Folder" -label "LORSM Organizations Folder"]
    content::folder::register_content_type -folder_id $folder_id -content_type "ims_organization_object" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_revision" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_folder" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_symlink" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_extlink" \
        -include_subtypes "t"

    # Create the root folder to store the LO's Items
    set folder_id [content::folder::new -name "LORSM Items Folder" -label "LORSM Items Folder"]
    content::folder::register_content_type -folder_id $folder_id -content_type "ims_item_object" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_revision" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_folder" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_symlink" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_extlink" \
        -include_subtypes "t"

    # Create the root folder to store the LO's Resources
    set folder_id [content::folder::new -name "LORSM Resources Folder" -label "LORSM Resources Folder"]
    content::folder::register_content_type -folder_id $folder_id -content_type "ims_resource_object" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_revision" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_folder" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_symlink" \
        -include_subtypes "t"
    content::folder::register_content_type -folder_id $folder_id -content_type "content_extlink" \
        -include_subtypes "t"

    # Calling apm callback proc for notifications 
    lors_central::apm_callback::package_install
}
