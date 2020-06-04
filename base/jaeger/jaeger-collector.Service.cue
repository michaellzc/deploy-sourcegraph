package kube

service: "jaeger-collector": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "jaeger-collector"
		labels: {
			"sourcegraph-resource-requires": "no-cluster-admin"
			app:                             "jaeger"
			"app.kubernetes.io/name":        "jaeger"
			"app.kubernetes.io/component":   "collector"
		}
	}
	spec: {
		ports: [{
			name:       "jaeger-collector-tchannel"
			port:       14267
			protocol:   "TCP"
			targetPort: 14267
		}, {
			name:       "jaeger-collector-http"
			port:       14268
			protocol:   "TCP"
			targetPort: 14268
		}, {
			name:       "jaeger-collector-grpc"
			port:       14250
			protocol:   "TCP"
			targetPort: 14250
		}]
		selector: {
			"app.kubernetes.io/name":      "jaeger"
			"app.kubernetes.io/component": "all-in-one"
		}
		type: "ClusterIP"
	}
}
