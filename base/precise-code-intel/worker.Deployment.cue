package kube

deployment: "precise-code-intel-worker": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		annotations: description:                "Handles conversion of uploaded precise code intelligence bundles."
		labels: "sourcegraph-resource-requires": "no-cluster-admin"
		name: "precise-code-intel-worker"
	}
	spec: {
		minReadySeconds:      10
		revisionHistoryLimit: 10
		selector: matchLabels: app: "precise-code-intel-worker"
		strategy: {
			rollingUpdate: {
				maxSurge:       1
				maxUnavailable: 1
			}
			type: "RollingUpdate"
		}
		template: {
			metadata: labels: {
				deploy: "sourcegraph"
				app:    "precise-code-intel-worker"
			}
			spec: {
				containers: [{
					env: [{
						name:  "NUM_WORKERS"
						value: "4"
					}, {
						name:  "PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL"
						value: "http://precise-code-intel-bundle-manager:3187"
					}, {
						name: "POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}]
					image:                    "index.docker.io/sourcegraph/precise-code-intel-worker:3.16.0@sha256:9e81c02d203c0dd80e7b2b4a9d3a5b4c74aa9f4d1c86b2aba84f712ea870313c"
					terminationMessagePolicy: "FallbackToLogsOnError"
					name:                     "precise-code-intel-worker"
					livenessProbe: {
						httpGet: {
							path:   "/healthz"
							port:   "http"
							scheme: "HTTP"
						}
						initialDelaySeconds: 60
						timeoutSeconds:      5
					}
					readinessProbe: {
						httpGet: {
							path:   "/healthz"
							port:   "http"
							scheme: "HTTP"
						}
						periodSeconds:  5
						timeoutSeconds: 5
					}
					ports: [{
						containerPort: 3188
						name:          "http"
					}, {
						containerPort: 6060
						name:          "debug"
					}]
					resources: {
						limits: {
							cpu:    *"2" | string | int
							memory: *"4G" | string | int
						}
						requests: {
							cpu:    *"500m" | string | int
							memory: *"2G" | string | int
						}
					}
				}]
				securityContext: runAsUser: 0
			}
		}
	}
}
