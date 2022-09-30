[
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      labels: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'extensions.dashboard.tekton.dev',
    },
    spec: {
      group: 'dashboard.tekton.dev',
      names: {
        categories: [
          'tekton',
          'tekton-dashboard',
        ],
        kind: 'Extension',
        plural: 'extensions',
        shortNames: [
          'ext',
          'exts',
        ],
      },
      preserveUnknownFields: false,
      scope: 'Namespaced',
      versions: [
        {
          additionalPrinterColumns: [
            {
              jsonPath: '.spec.apiVersion',
              name: 'API version',
              type: 'string',
            },
            {
              jsonPath: '.spec.name',
              name: 'Kind',
              type: 'string',
            },
            {
              jsonPath: '.spec.displayname',
              name: 'Display name',
              type: 'string',
            },
            {
              jsonPath: '.metadata.creationTimestamp',
              name: 'Age',
              type: 'date',
            },
          ],
          name: 'v1alpha1',
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          served: true,
          storage: true,
          subresources: {
            status: {},
          },
        },
      ],
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      labels: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'tekton-dashboard',
      namespace: 'tekton-pipelines',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'Role',
    metadata: {
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'tekton-dashboard-info',
      namespace: 'tekton-pipelines',
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resourceNames: [
          'dashboard-info',
        ],
        resources: [
          'configmaps',
        ],
        verbs: [
          'get',
        ],
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      labels: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'tekton-dashboard-backend',
    },
    rules: [
      {
        apiGroups: [
          'apiextensions.k8s.io',
        ],
        resources: [
          'customresourcedefinitions',
        ],
        verbs: [
          'get',
          'list',
        ],
      },
      {
        apiGroups: [
          'security.openshift.io',
        ],
        resources: [
          'securitycontextconstraints',
        ],
        verbs: [
          'use',
        ],
      },
      {
        apiGroups: [
          'tekton.dev',
        ],
        resources: [
          'clustertasks',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'triggers.tekton.dev',
        ],
        resources: [
          'clusterinterceptors',
          'clustertriggerbindings',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'serviceaccounts',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'dashboard.tekton.dev',
        ],
        resources: [
          'extensions',
        ],
        verbs: [
          'create',
          'update',
          'delete',
          'patch',
        ],
      },
      {
        apiGroups: [
          'tekton.dev',
        ],
        resources: [
          'clustertasks',
        ],
        verbs: [
          'create',
          'update',
          'delete',
          'patch',
        ],
      },
      {
        apiGroups: [
          'triggers.tekton.dev',
        ],
        resources: [
          'clusterinterceptors',
          'clustertriggerbindings',
        ],
        verbs: [
          'create',
          'update',
          'delete',
          'patch',
        ],
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      labels: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'tekton-dashboard-tenant',
    },
    rules: [
      {
        apiGroups: [
          'dashboard.tekton.dev',
        ],
        resources: [
          'extensions',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'events',
          'namespaces',
          'pods',
          'pods/log',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'tekton.dev',
        ],
        resources: [
          'tasks',
          'taskruns',
          'pipelines',
          'pipelineruns',
          'pipelineresources',
          'runs',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'triggers.tekton.dev',
        ],
        resources: [
          'eventlisteners',
          'triggerbindings',
          'triggers',
          'triggertemplates',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'tekton.dev',
        ],
        resources: [
          'tasks',
          'taskruns',
          'pipelines',
          'pipelineruns',
          'pipelineresources',
          'runs',
        ],
        verbs: [
          'create',
          'update',
          'delete',
          'patch',
        ],
      },
      {
        apiGroups: [
          'triggers.tekton.dev',
        ],
        resources: [
          'eventlisteners',
          'triggerbindings',
          'triggers',
          'triggertemplates',
        ],
        verbs: [
          'create',
          'update',
          'delete',
          'patch',
        ],
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'tekton-dashboard-info',
      namespace: 'tekton-pipelines',
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'Role',
      name: 'tekton-dashboard-info',
    },
    subjects: [
      {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'Group',
        name: 'system:authenticated',
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      labels: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
        'rbac.dashboard.tekton.dev/subject': 'tekton-dashboard',
      },
      name: 'tekton-dashboard-backend',
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: 'tekton-dashboard-backend',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-dashboard',
        namespace: 'tekton-pipelines',
      },
    ],
  },
  {
    apiVersion: 'v1',
    data: {
      version: 'v0.29.2',
    },
    kind: 'ConfigMap',
    metadata: {
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
      name: 'dashboard-info',
      namespace: 'tekton-pipelines',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      labels: {
        app: 'tekton-dashboard',
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/name': 'dashboard',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
        'app.kubernetes.io/version': 'v0.29.2',
        'dashboard.tekton.dev/release': 'v0.29.2',
        version: 'v0.29.2',
      },
      name: 'tekton-dashboard',
      namespace: 'tekton-pipelines',
    },
    spec: {
      ports: [
        {
          name: 'http',
          port: 9097,
          protocol: 'TCP',
          targetPort: 9097,
        },
      ],
      selector: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/name': 'dashboard',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
      },
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      labels: {
        app: 'tekton-dashboard',
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/name': 'dashboard',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
        'app.kubernetes.io/version': 'v0.29.2',
        'dashboard.tekton.dev/release': 'v0.29.2',
        version: 'v0.29.2',
      },
      name: 'tekton-dashboard',
      namespace: 'tekton-pipelines',
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          'app.kubernetes.io/component': 'dashboard',
          'app.kubernetes.io/instance': 'default',
          'app.kubernetes.io/name': 'dashboard',
          'app.kubernetes.io/part-of': 'tekton-dashboard',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'tekton-dashboard',
            'app.kubernetes.io/component': 'dashboard',
            'app.kubernetes.io/instance': 'default',
            'app.kubernetes.io/name': 'dashboard',
            'app.kubernetes.io/part-of': 'tekton-dashboard',
            'app.kubernetes.io/version': 'v0.29.2',
          },
          name: 'tekton-dashboard',
        },
        spec: {
          containers: [
            {
              args: [
                '--port=9097',
                '--logout-url=',
                '--pipelines-namespace=tekton-pipelines',
                '--triggers-namespace=tekton-pipelines',
                '--read-only=false',
                '--log-level=info',
                '--log-format=json',
                '--namespace=',
                '--stream-logs=true',
                '--external-logs=',
              ],
              env: [
                {
                  name: 'INSTALLED_NAMESPACE',
                  valueFrom: {
                    fieldRef: {
                      fieldPath: 'metadata.namespace',
                    },
                  },
                },
              ],
              image: 'gcr.io/tekton-releases/github.com/tektoncd/dashboard/cmd/dashboard:v0.29.2@sha256:67425f5fa32c591578ba6c8b6d4d6a135f8ca195745e023f3f311e3f1ee6ea37',
              livenessProbe: {
                httpGet: {
                  path: '/health',
                  port: 9097,
                },
              },
              name: 'tekton-dashboard',
              ports: [
                {
                  containerPort: 9097,
                },
              ],
              readinessProbe: {
                httpGet: {
                  path: '/readiness',
                  port: 9097,
                },
              },
            },
          ],
          nodeSelector: {
            'kubernetes.io/os': 'linux',
          },
          securityContext: {
            runAsNonRoot: true,
            runAsUser: 65532,
          },
          serviceAccountName: 'tekton-dashboard',
          volumes: [],
        },
      },
    },
  },
  null,
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      labels: {
        'app.kubernetes.io/component': 'dashboard',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-dashboard',
        'rbac.dashboard.tekton.dev/subject': 'tekton-dashboard',
      },
      name: 'tekton-dashboard-tenant',
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: 'tekton-dashboard-tenant',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-dashboard',
        namespace: 'tekton-pipelines',
      },
    ],
  },
]
