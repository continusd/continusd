// Converted from https://storage.googleapis.com/tekton-releases/triggers/previous/v0.15.1/interceptors.yaml on 02/10/2022
// Installs interceptors for GitHub, GitLab, BitBucket, CEL
[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'tekton-triggers-core-interceptors',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/name': 'core-interceptors',
        'app.kubernetes.io/component': 'interceptors',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.15.1',
        'app.kubernetes.io/part-of': 'tekton-triggers',
        'triggers.tekton.dev/release': 'v0.15.1',
      },
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          'app.kubernetes.io/name': 'core-interceptors',
          'app.kubernetes.io/component': 'interceptors',
          'app.kubernetes.io/instance': 'default',
          'app.kubernetes.io/part-of': 'tekton-triggers',
        },
      },
      template: {
        metadata: {
          labels: {
            'app.kubernetes.io/name': 'core-interceptors',
            'app.kubernetes.io/component': 'interceptors',
            'app.kubernetes.io/instance': 'default',
            'app.kubernetes.io/version': 'v0.15.1',
            'app.kubernetes.io/part-of': 'tekton-triggers',
            app: 'tekton-triggers-core-interceptors',
            'triggers.tekton.dev/release': 'v0.15.1',
            version: 'v0.15.1',
          },
        },
        spec: {
          serviceAccountName: 'tekton-triggers-core-interceptors',
          containers: [
            {
              name: 'tekton-triggers-core-interceptors',
              image: 'gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/interceptors:v0.15.1@sha256:726c308bcab1d746b0cb3b90c5f6abbea64da34459681cba2143c34c337cdc94',
              args: [
                '-logtostderr',
                '-stderrthreshold',
                'INFO',
              ],
              env: [
                {
                  name: 'SYSTEM_NAMESPACE',
                  valueFrom: {
                    fieldRef: {
                      fieldPath: 'metadata.namespace',
                    },
                  },
                },
                {
                  name: 'CONFIG_LOGGING_NAME',
                  value: 'config-logging-triggers',
                },
                {
                  name: 'CONFIG_OBSERVABILITY_NAME',
                  value: 'config-observability-triggers',
                },
                {
                  name: 'METRICS_DOMAIN',
                  value: 'tekton.dev/triggers',
                },
              ],
              readinessProbe: {
                httpGet: {
                  path: '/ready',
                  port: 8082,
                  scheme: 'HTTP',
                },
                initialDelaySeconds: 5,
                periodSeconds: 10,
                timeoutSeconds: 5,
              },
              securityContext: {
                allowPrivilegeEscalation: false,
                runAsUser: 65532,
                runAsGroup: 65532,
                capabilities: {
                  drop: [
                    'all',
                  ],
                },
              },
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      labels: {
        'app.kubernetes.io/name': 'tekton-triggers-core-interceptors',
        'app.kubernetes.io/component': 'interceptors',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.15.1',
        'app.kubernetes.io/part-of': 'tekton-triggers',
        'triggers.tekton.dev/release': 'v0.15.1',
        app: 'tekton-triggers-core-interceptors',
        version: 'v0.15.1',
      },
      name: 'tekton-triggers-core-interceptors',
      namespace: 'tekton-pipelines',
    },
    spec: {
      ports: [
        {
          name: 'http',
          port: 80,
          targetPort: 8082,
        },
      ],
      selector: {
        'app.kubernetes.io/name': 'core-interceptors',
        'app.kubernetes.io/component': 'interceptors',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-triggers',
      },
    },
  },
  {
    apiVersion: 'triggers.tekton.dev/v1alpha1',
    kind: 'ClusterInterceptor',
    metadata: {
      name: 'github',
    },
    spec: {
      clientConfig: {
        service: {
          name: 'tekton-triggers-core-interceptors',
          namespace: 'tekton-pipelines',
          path: 'github',
        },
      },
    },
  },
  {
    apiVersion: 'triggers.tekton.dev/v1alpha1',
    kind: 'ClusterInterceptor',
    metadata: {
      name: 'gitlab',
    },
    spec: {
      clientConfig: {
        service: {
          name: 'tekton-triggers-core-interceptors',
          namespace: 'tekton-pipelines',
          path: 'gitlab',
        },
      },
    },
  },
  null,
]