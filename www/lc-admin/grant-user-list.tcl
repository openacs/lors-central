ad_page_contract {
    @author          Miguel Marin (miguelmarin@viaro.net) 
    @author          Viaro Networks www.viaro.net

} {
    { keyword "" }
    man_id:notnull
    creation_user:notnull
}

set user_id [ad_conn user_id]
# Check for privileges 
lors_central::check_permissions -check_inst t

set page_title "[_ lors-central.search_users_to]"
set context [list [list "." [_ lors-central.lors_admin]] \
		 [list "grant-permissions"  [_ lors-central.grant_permissions]] $page_title]

if { [string equal $keyword [_ lors-central.please_type]] || [empty_string_p $keyword]} {
    set query all_users
} else {
    set query search_users
}

db_multirow -extend { privilege email } grant_list $query { } {
    set privilege [permission::permission_p -party_id $p_user_id -object_id $man_id -privilege "admin"]
    if { [catch { set email [email_image::get_user_email -user_id $p_user_id] } errmsg] } {
	set email $db_email
    } else {
	set email [email_image::get_user_email -user_id $p_user_id]
    }
}

template::list::create \
    -name grant_list \
    -multirow grant_list \
    -key p_user_id \
    -bulk_actions {"\#lors-central.grant\#" "grant" "\#lors-central.grant_per\#"\
		       "\#lors-central.revoke\#" "revoke" "\#lors-central.revoke_per\#" }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	keyword
	man_id
	back_url
    }\
    -row_pretty_plural "[_ lors-central.user_to_grant]" \
    -elements {
	name {
	    label "[_ lors-central.username]"
	    display_template {
		@grant_list.first_names@ @grant_list.last_name@
	    }
	}
	email {
	    label "[_ lors-central.email]"
	    display_template {
		@grant_list.email;noquote@
	    }
	}
	permission {
	    label "[_ lors-central.privilege_on]"
	    display_template {
		<div align=center>
		<if @grant_list.privilege@ eq 1>
		#lors-central.admin#
		</if>
		<else>
		<i>[_ lors-central.not_allowed]</i>
		</else>
		</div>
	    }
	}
    }


db_multirow -extend { associated_p grant_url revoke_url } classes select_member_classes { } {
    set grant_url "<a href=\"grant?man_id=$man_id&class_com_id=$class_instance_id\">#lors-central.grant#</a>"
    set revoke_url "<a href=\"revoke?man_id=$man_id&class_com_id=$class_instance_id\">#lors-central.revoke#</a>"
    set associated_p [lors_central::relation_between -item_id $man_id -community_id $class_instance_id]
}

db_multirow -extend { associated_p grant_url revoke_url } clubs select_member_clubs { } {
    set grant_url "<a href=\"grant?man_id=$man_id&class_com_id=$community_id\">#lors-central.grant#</a>"
    set revoke_url "<a href=\"revoke?man_id=$man_id&class_com_id=$community_id\">#lors-central.revoke#</a>"
    set associated_p [lors_central::relation_between -item_id $man_id -community_id $community_id]
}

