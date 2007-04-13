# 

ad_page_contract {
    
    Edit the name of a given ims_item_id
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2007-02-26
    @arch-tag: 96877018-3fb2-4faa-bba7-3b91f22b0d71
    @cvs-id $Id$
} {
    {ims_item_id:integer,notnull}
    {name ""}
    {return_url:notnull}
    {man_id:notnull}
} -properties {
} -validate {
} -errors {
}

set title ""
set context [list $title]

set return_url [export_vars -base $return_url {ims_item_id man_id}]

ad_form -name edit_name -export { return_url man_id} -cancel_url "$return_url" -form {
    {ims_item_id:key
	{value $ims_item_id}
    }
    {name:text(text)
	{label "Name:"}
	{value $name}
    }
} -edit_request {
} -on_submit {
    #update name
    db_dml update_name { *SQL* }
    
} -after_submit {
    ad_returnredirect $return_url
}