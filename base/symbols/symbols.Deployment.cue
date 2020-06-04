package kube

deployment: symbols: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		annotations: description:                "Backend for symbols operations."
		labels: "sourcegraph-resource-requires": "no-cluster-admin"
		name: "symbols"
	}
	spec: {
		minReadySeconds:      10
		revisionHistoryLimit: 10
		selector: matchLabels: app: "symbols"
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
				app:    "symbols"
			}
			spec: {
				containers: [{
					env: [{
						name:  "SYMBOLS_CACHE_SIZE_MB"
						value: "100000"
					}, {
						name: "POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						name:  "CACHE_DIR"
						value: "/mnt/cache/$(POD_NAME)"
					}]
					image:                    "index.docker.io/sourcegraph/symbols:3.16.0@sha256:b5da6814c2a03df210e2258365989a5ba0246ca8b1297d65604bcf9e5e8d6788"
					terminationMessagePolicy: "FallbackToLogsOnError"
					name:                     "symbols"
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
						containerPort: 3184
						name:          "http"
					}, {
						containerPort: 6060
						name:          "debug"
					}]
					resources: {
						limits: {
							cpu:    *"2" | string | int
							memory: *"2G" | string | int
						}
						requests: {
							cpu:    *"500m" | string | int
							memory: *"500M" | string | int
						}
					}
					volumeMounts: [{
						mountPath: "/mnt/cache"
						name:      "cache-ssd"
					}]
				}, {
					image: "index.docker.io/sourcegraph/jaeger-agent:3.16.0@sha256:ad1fc2f6b69ba3622f872bb105ef07dec5e5a539d30e733b006e88445dbe61e1"
					name:  "jaeger-agent"
					env: [{
						name: "POD_NAME"
						valueFrom: fieldRef: {
							apiVersion: "v1"
							fieldPath:  "metadata.name"
						}
					}]
					ports: [{
						containerPort: 5775
						protocol:      "UDP"
					}, {
						containerPort: 5778
						protocol:      "TCP"
					}, {
						containerPort: 6831
						protocol:      "UDP"
					}, {
						containerPort: 6832
						protocol:      "UDP"
					}]
					resources: {
						limits: {
							cpu:    *"1" | string | int
							memory: *"500M" | string | int
						}
						requests: {
							cpu:    *"100m" | string | int
							memory: *"100M" | string | int
						}
					}
					args: [
						"--reporter.grpc.host-port=jaeger-collector:14250",
						"--reporter.type=grpc",
					]
				}]
				securityContext: runAsUser: 0
				volumes: [{
					emptyDir: {}
					name: "cache-ssd"
				}]
			}
		}
	}
}
