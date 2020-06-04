package kube

clusterRoleBinding: prometheus: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		labels: {
			category:                        "rbac"
			deploy:                          "sourcegraph"
			"sourcegraph-resource-requires": "cluster-admin"
		}
		name: "prometheus"
	}
	roleRef: {
		apiGroup: ""
		kind:     "ClusterRole"
		name:     "prometheus"
	}
	subjects: [{
		kind: "ServiceAccount"
		name: "prometheus"
		// value of namespace needs to match namespace value in base/prometheus/prometheus.ServiceAccount.yaml
		namespace: "default"
	}]
}
