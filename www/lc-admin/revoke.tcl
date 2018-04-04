ad_page_contract {
    @author          Miguel Marin (miguelmarin@viaro.net)
    @author          Viaro Networks www.viaro.net

    Removes users admin privilege over man_id
} {
    p_user_id:multiple,optional
    class_com_id:optional
    man_id:notnull
}

set user_id [ad_conn user_id]

# Check for privileges over lors-central
lors_central::check_permissions -check_inst t


if { [info exists class_com_id] } {
    # Grant admin privilige to all users in this class or community
    db_foreach get_all_members { } {
	if { ![lors_central::owner -user_id $user_id -object_id $man_id] } {
	    permission::revoke -party_id $user_id -object_id $man_id  -privilege "admin"
	}
    }
} else {
    # Grants Permission for all the users in p_user_id
    foreach user $p_user_id {
	if { ![lors_central::owner -user_id $user -object_id $man_id] } {
	    permission::revoke -party_id $user -object_id $man_id  -privilege "admin"
	}
    }
}

ad_returnredirect [get_referrer]
