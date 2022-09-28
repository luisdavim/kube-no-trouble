package deprecated116

main[return] {
	resource := input[_]
	annotations := get_default(resource.metadata, "annotations", {"doit-intl.com/kube-no-trouble", "<undefined>"})
	api := deprecated_resource(resource)
	return := {
		"Name": get_default(resource.metadata, "name", "<undefined>"),
		# Namespace does not have to be defined in case of local manifests
		"Namespace": get_default(resource.metadata, "namespace", "<undefined>"),
		"Kind": resource.kind,
		"ApiVersion": api.old,
		"ReplaceWith": api.new,
		"RuleSet": "Deprecated APIs removed in 1.16",
		"Since": api.since,
		"Collector": get_default(annotations, "doit-intl.com/kube-no-trouble", "<undefined>"),
	}
}

deprecated_resource(r) = api {
	api := deprecated_api(r.kind, r.apiVersion)
}

deprecated_api(kind, api_version) = api {
	deprecated_apis = {
		"Deployment": {
			"old": ["extensions/v1beta1", "apps/v1beta1", "apps/v1beta2"],
			"new": "apps/v1",
			"since": "1.9",
		},
		"NetworkPolicy": {
			"old": ["extensions/v1beta1"],
			"new": "networking.k8s.io/v1",
			"since": "1.8",
		},
		"PodSecurityPolicy": {
			"old": ["extensions/v1beta1"],
			"new": "policy/v1beta1",
			"since": "1.10",
		},
		"DaemonSet": {
			"old": ["extensions/v1beta1", "apps/v1beta2"],
			"new": "apps/v1",
			"since": "1.9",
		},
		"StatefulSet": {
			"old": ["apps/v1beta1", "apps/v1beta2"],
			"new": "apps/v1",
			"since": "1.9",
		},
		"ReplicaSet": {
			"old": ["extensions/v1beta1", "apps/v1beta1", "apps/v1beta2"],
			"new": "apps/v1",
			"since": "1.9",
		},
	}

	deprecated_apis[kind].old[_] == api_version
	api := {
		"old": api_version,
		"new": deprecated_apis[kind].new,
		"since": deprecated_apis[kind].since,
	}
}

get_default(val, key, _) = val[key]

get_default(val, key, fallback) = fallback {
	not val[key]
}
