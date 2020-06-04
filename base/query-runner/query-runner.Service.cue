package kube

service: "query-runner": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		annotations: {
			"prometheus.io/port":            "6060"
			"sourcegraph.prometheus/scrape": "true"
		}
		labels: {
			app:                             "query-runner"
			"sourcegraph-resource-requires": "no-cluster-admin"
		}
		name: "query-runner"
	}
	spec: {
		ports: [{
			name:       "http"
			port:       80
			targetPort: "http"
		}]
		selector: app: "query-runner"
		type: "ClusterIP"
	}
}
