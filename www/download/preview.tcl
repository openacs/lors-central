ad_page_contract {

   URL handler for file preview

} {
    file_id:integer,optional
    version_id:integer,optional
}

# DAVEB file_id is version_id now
set version_id $file_id
#if {![exists_and_not_null version_id]} {
#        set version_id [item::get_live_revision $file_id]
#}

set preview [cr_write_content -string -revision_id $version_id]





