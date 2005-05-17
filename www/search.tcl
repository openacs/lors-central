# 

ad_page_contract {
    
    Search Learning Objects
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-03-26
    @arch-tag: 79e55eed-608a-449e-b684-5c5d4018fe4f
    @cvs-id $Id$
} {
    {q ""}
    {extra_q ""}
    {offset 0}
    {num 0}
} -properties {
} -validate {
} -errors {
}

set page_title "Search Learning Objects"
set context [list $page_title]
set header_stuff ""
set focus ""

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission \
    -object_id $package_id \
    -party_id $user_id \
    -privilege "read"

set grade_range_options [db_list_of_lists glo "select distinct context_v as label, context_v from ims_md_educational_context"]
set grade_range_options [linsert $grade_range_options 0 {"--" ""}]
set subject_area_options [db_list_of_lists so "select distinct entry_s as label, entry_s from ims_md_general_cata where catalog = 'PBS-SubjectArea'"]
set subject_area_options [linsert $subject_area_options 0 {"--" ""}]
ad_form -name search -method GET -form {
    {q:text(text)
        {label "Enter Search Terms"}
        {html {id search-textbox}}}
    {search:text(submit) {label "Search"}}
    {grade_range:text(select),optional
	{label "Grade Range"}
	{options $grade_range_options}}
    {subject_area:text(select),optional
	{label "Subject Area"}
	{options $subject_area_options}}
   
    
} -on_submit {

append extra_q " object_type:ims_resource_object"
if {[exists_and_not_null grade_range]} {
    append extra_q " grade_range:${grade_range} "
}
if {[exists_and_not_null subject_area]} {
    append extra_q " subject_area:${subject_area} "
}
}

# if {[info exists q] && ![string equal "" $q]} {
#     set search 1
# } else {
#     set search 0
# }

# set filters {search {values {0 1} where_clause_eval {
#     if {$search} {
#         array set result [acs_sc_call FtsEngineDriver search [list [string tolower $q] 0 10 $user_id "" ""] "tsearch2-driver"]
#         if {![info exists result(ids)]} {
#             # search is not working, ignore search terms
#             set where " 1=1 "
#         } elseif {[llength $result(ids)] >0} {
#             set result_ids $result(ids)
#             set where " object_id in ([template::util::tcl_to_sql_list $result_ids])"                              
#         } else {
#             subst {1=0}
#         }
#     } else {
#         subst {1=0}
#     }
# } } }

# # search results (with checkboxes for clipboard)
# template::list::create \
#     -name results \
#     -multirow results \
#     -elements {
#         title { label "title" link_url_col url }
#     } \
#     -filters ${filters}

# # TODO use search to generate multirow, otherwise we have issues with
# # ordering if we try to put the ids into a IN clause

# db_multirow -extend {url} results get_results "select object_id, coalesce ('Untitled',title) as title from acs_objects where [template::list::filter_where_clauses -name results]" {
#     set url "/o/${object_id}"
# }

ad_return_template

