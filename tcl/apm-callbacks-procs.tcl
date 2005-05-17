ad_library {

    Procedures to do a new impl and aliases in the acs-sc.
    @autor Miguel Marin (miguelmarin@viaro.net)
}

namespace eval lors_central::apm_callback {}

ad_proc -private lors_central::apm_callback::package_install {
} {
    Does the integration whith the notifications package.
} {
    db_transaction {

        # Create the impl and aliases
        set impl_id [create_lors_central_impl]

        # Create the notification type
        set type_id [create_lors_central_type $impl_id]

        # Enable the delivery intervals and delivery methods
        enable_intervals_and_methods $type_id
    }
}


ad_proc -public lors_central::apm_callback::create_lors_central_impl {} {
    Register the service contract implementation and return the impl_id
    @return impl_id of the created implementation
} {
    return [acs_sc::impl::new_from_spec -spec {
	name one_lo_notif_type
	contract_name NotificationType
	owner "lors-central"
	aliases {
                GetURL lors_central::notification::get_url
                ProcessReply lors_central::notification::process_reply
	}
    }]
}

ad_proc -public lors_central::apm_callback::create_lors_central_type {impl_id} {
    Create the notification type
    @return the type_id of the created type
} {
    return [notification::type::new \
                -sc_impl_id $impl_id \
                -short_name one_lo_notif \
                -pretty_name "One Learning Object Notification" \
                -description "Notification of a new Learning Object of one specific course"]
}


ad_proc -public lors_central::apm_callback::enable_intervals_and_methods {type_id} {
    Enable the intervals and delivery methods of a specific type
} {
    # Enable the various intervals and delivery method
    notification::type::interval_enable \
        -type_id $type_id \
        -interval_id [notification::interval::get_id_from_name -name instant]

    notification::type::interval_enable \
        -type_id $type_id \
        -interval_id [notification::interval::get_id_from_name -name hourly]

    notification::type::interval_enable \
        -type_id $type_id \
        -interval_id [notification::interval::get_id_from_name -name daily]

    # Enable the delivery methods
    notification::type::delivery_method_enable \
        -type_id $type_id \
        -delivery_method_id [notification::delivery::get_id -short_name email]
}

ad_proc -public lors_central::apm_callback::after_upgrade {
    -from_version_name:required
    -to_version_name:required
} {
    Makes the upgrade of lors-central package
} {
    apm_upgrade_logic \
	-from_version_name $from_version_name \
	-to_version_name $to_version_name \
	-spec {
	    0.1a2 0.1a3 {
		lors_central::apm_callback::package_install
	    }
	}
}