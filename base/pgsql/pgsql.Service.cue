package kube

service: pgsql: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		annotations: {
			"prometheus.io/port":            "9187"
			"sourcegraph.prometheus/scrape": "true"
		}
		labels: {
			app:                             "pgsql"
			"sourcegraph-resource-requires": "no-cluster-admin"
		}
		name: "pgsql"
	}
	spec: {
		ports: [{
			name:       "pgsql"
			port:       5432
			targetPort: "pgsql"
		}]
		selector: app: "pgsql"
		type: "ClusterIP"
	}
}
