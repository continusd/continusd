// Converted from https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml on 29/09/2022

[
  {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  {
    apiVersion: 'policy/v1beta1',
    kind: 'PodSecurityPolicy',
    metadata: {
      name: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
      annotations: {
        'seccomp.security.alpha.kubernetes.io/allowedProfileNames': 'docker/default,runtime/default',
        'seccomp.security.alpha.kubernetes.io/defaultProfileName': 'runtime/default',
        'apparmor.security.beta.kubernetes.io/allowedProfileNames': 'runtime/default',
        'apparmor.security.beta.kubernetes.io/defaultProfileName': 'runtime/default',
      },
    },
    spec: {
      privileged: false,
      allowPrivilegeEscalation: false,
      requiredDropCapabilities: [
        'ALL',
      ],
      volumes: [
        'emptyDir',
        'configMap',
        'secret',
      ],
      hostNetwork: false,
      hostIPC: false,
      hostPID: false,
      runAsUser: {
        rule: 'MustRunAsNonRoot',
      },
      runAsGroup: {
        rule: 'MustRunAs',
        ranges: [
          {
            min: 1,
            max: 65535,
          },
        ],
      },
      seLinux: {
        rule: 'RunAsAny',
      },
      supplementalGroups: {
        rule: 'MustRunAs',
        ranges: [
          {
            min: 1,
            max: 65535,
          },
        ],
      },
      fsGroup: {
        rule: 'MustRunAs',
        ranges: [
          {
            min: 1,
            max: 65535,
          },
        ],
      },
    },
  },
  {
    kind: 'ClusterRole',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'tekton-pipelines-controller-cluster-access',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods',
        ],
        verbs: [
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
          'clustertasks',
          'taskruns',
          'pipelines',
          'pipelineruns',
          'pipelineresources',
          'conditions',
          'runs',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
      {
        apiGroups: [
          'tekton.dev',
        ],
        resources: [
          'taskruns/finalizers',
          'pipelineruns/finalizers',
          'runs/finalizers',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
      {
        apiGroups: [
          'tekton.dev',
        ],
        resources: [
          'tasks/status',
          'clustertasks/status',
          'taskruns/status',
          'pipelines/status',
          'pipelineruns/status',
          'pipelineresources/status',
          'runs/status',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
      {
        apiGroups: [
          'resolution.tekton.dev',
        ],
        resources: [
          'resolutionrequests',
          'resolutionrequests/status',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
    ],
  },
  {
    kind: 'ClusterRole',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'tekton-pipelines-controller-tenant-access',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods',
          'persistentvolumeclaims',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'events',
        ],
        verbs: [
          'create',
          'update',
          'patch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
          'limitranges',
          'secrets',
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
          'apps',
        ],
        resources: [
          'statefulsets',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
    ],
  },
  {
    kind: 'ClusterRole',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'tekton-pipelines-webhook-cluster-access',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          'apiextensions.k8s.io',
        ],
        resources: [
          'customresourcedefinitions',
          'customresourcedefinitions/status',
        ],
        verbs: [
          'get',
          'update',
          'patch',
        ],
        resourceNames: [
          'pipelines.tekton.dev',
          'pipelineruns.tekton.dev',
          'runs.tekton.dev',
          'tasks.tekton.dev',
          'clustertasks.tekton.dev',
          'taskruns.tekton.dev',
          'pipelineresources.tekton.dev',
          'conditions.tekton.dev',
          'resolutionrequests.resolution.tekton.dev',
        ],
      },
      {
        apiGroups: [
          'apiextensions.k8s.io',
        ],
        resources: [
          'customresourcedefinitions',
        ],
        verbs: [
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'admissionregistration.k8s.io',
        ],
        resources: [
          'mutatingwebhookconfigurations',
          'validatingwebhookconfigurations',
        ],
        verbs: [
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'admissionregistration.k8s.io',
        ],
        resources: [
          'mutatingwebhookconfigurations',
        ],
        resourceNames: [
          'webhook.pipeline.tekton.dev',
        ],
        verbs: [
          'get',
          'update',
          'delete',
        ],
      },
      {
        apiGroups: [
          'admissionregistration.k8s.io',
        ],
        resources: [
          'validatingwebhookconfigurations',
        ],
        resourceNames: [
          'validation.webhook.pipeline.tekton.dev',
          'config.webhook.pipeline.tekton.dev',
        ],
        verbs: [
          'get',
          'update',
          'delete',
        ],
      },
      {
        apiGroups: [
          'policy',
        ],
        resources: [
          'podsecuritypolicies',
        ],
        resourceNames: [
          'tekton-pipelines',
        ],
        verbs: [
          'use',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'namespaces',
        ],
        verbs: [
          'get',
        ],
        resourceNames: [
          'tekton-pipelines',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'namespaces/finalizers',
        ],
        verbs: [
          'update',
        ],
        resourceNames: [
          'tekton-pipelines',
        ],
      },
    ],
  },
  {
    kind: 'Role',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'tekton-pipelines-controller',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        verbs: [
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        verbs: [
          'get',
        ],
        resourceNames: [
          'config-logging',
          'config-observability',
          'config-artifact-bucket',
          'config-artifact-pvc',
          'feature-flags',
          'config-leader-election',
          'config-registry-cert',
        ],
      },
      {
        apiGroups: [
          'policy',
        ],
        resources: [
          'podsecuritypolicies',
        ],
        resourceNames: [
          'tekton-pipelines',
        ],
        verbs: [
          'use',
        ],
      },
    ],
  },
  {
    kind: 'Role',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'tekton-pipelines-webhook',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        verbs: [
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        verbs: [
          'get',
        ],
        resourceNames: [
          'config-logging',
          'config-observability',
          'config-leader-election',
          'feature-flags',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'secrets',
        ],
        verbs: [
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'secrets',
        ],
        verbs: [
          'get',
          'update',
        ],
        resourceNames: [
          'webhook-certs',
        ],
      },
      {
        apiGroups: [
          'policy',
        ],
        resources: [
          'podsecuritypolicies',
        ],
        resourceNames: [
          'tekton-pipelines',
        ],
        verbs: [
          'use',
        ],
      },
    ],
  },
  {
    kind: 'Role',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'tekton-pipelines-leader-election',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          'coordination.k8s.io',
        ],
        resources: [
          'leases',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'update',
          'delete',
          'patch',
          'watch',
        ],
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'Role',
    metadata: {
      name: 'tekton-pipelines-info',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        resourceNames: [
          'pipelines-info',
        ],
        verbs: [
          'get',
        ],
      },
    ],
  },
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: 'tekton-pipelines-controller',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: 'tekton-pipelines-webhook',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: 'tekton-pipelines-controller-cluster-access',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-controller',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: 'tekton-pipelines-controller-cluster-access',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: 'tekton-pipelines-controller-tenant-access',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-controller',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: 'tekton-pipelines-controller-tenant-access',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: 'tekton-pipelines-webhook-cluster-access',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-webhook',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: 'tekton-pipelines-webhook-cluster-access',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'tekton-pipelines-controller',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-controller',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'Role',
      name: 'tekton-pipelines-controller',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'tekton-pipelines-webhook',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-webhook',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'Role',
      name: 'tekton-pipelines-webhook',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'tekton-pipelines-controller-leaderelection',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-controller',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'Role',
      name: 'tekton-pipelines-leader-election',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'tekton-pipelines-webhook-leaderelection',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'tekton-pipelines-webhook',
        namespace: 'tekton-pipelines',
      },
    ],
    roleRef: {
      kind: 'Role',
      name: 'tekton-pipelines-leader-election',
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'RoleBinding',
    metadata: {
      name: 'tekton-pipelines-info',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    subjects: [
      {
        kind: 'Group',
        name: 'system:authenticated',
        apiGroup: 'rbac.authorization.k8s.io',
      },
    ],
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'Role',
      name: 'tekton-pipelines-info',
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'clustertasks.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      preserveUnknownFields: false,
      versions: [
        {
          name: 'v1beta1',
          served: true,
          storage: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'ClusterTask',
        plural: 'clustertasks',
        singular: 'clustertask',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
      },
      scope: 'Cluster',
      conversion: {
        strategy: 'Webhook',
        webhook: {
          conversionReviewVersions: [
            'v1beta1',
          ],
          clientConfig: {
            service: {
              name: 'tekton-pipelines-webhook',
              namespace: 'tekton-pipelines',
            },
          },
        },
      },
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'pipelines.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      preserveUnknownFields: false,
      versions: [
        {
          name: 'v1beta1',
          served: true,
          storage: true,
          subresources: {
            status: {},
          },
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
        },
        {
          name: 'v1',
          served: false,
          storage: false,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'Pipeline',
        plural: 'pipelines',
        singular: 'pipeline',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
      },
      scope: 'Namespaced',
      conversion: {
        strategy: 'Webhook',
        webhook: {
          conversionReviewVersions: [
            'v1beta1',
            'v1',
          ],
          clientConfig: {
            service: {
              name: 'tekton-pipelines-webhook',
              namespace: 'tekton-pipelines',
            },
          },
        },
      },
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'pipelineruns.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      preserveUnknownFields: false,
      versions: [
        {
          name: 'v1beta1',
          served: true,
          storage: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].status',
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].reason',
            },
            {
              name: 'StartTime',
              type: 'date',
              jsonPath: '.status.startTime',
            },
            {
              name: 'CompletionTime',
              type: 'date',
              jsonPath: '.status.completionTime',
            },
          ],
          subresources: {
            status: {},
          },
        },
        {
          name: 'v1',
          served: false,
          storage: false,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].status',
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].reason',
            },
            {
              name: 'StartTime',
              type: 'date',
              jsonPath: '.status.startTime',
            },
            {
              name: 'CompletionTime',
              type: 'date',
              jsonPath: '.status.completionTime',
            },
          ],
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'PipelineRun',
        plural: 'pipelineruns',
        singular: 'pipelinerun',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
        shortNames: [
          'pr',
          'prs',
        ],
      },
      scope: 'Namespaced',
      conversion: {
        strategy: 'Webhook',
        webhook: {
          conversionReviewVersions: [
            'v1beta1',
          ],
          clientConfig: {
            service: {
              name: 'tekton-pipelines-webhook',
              namespace: 'tekton-pipelines',
            },
          },
        },
      },
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'resolutionrequests.resolution.tekton.dev',
      labels: {
        'resolution.tekton.dev/release': 'devel',
      },
    },
    spec: {
      group: 'resolution.tekton.dev',
      scope: 'Namespaced',
      names: {
        kind: 'ResolutionRequest',
        plural: 'resolutionrequests',
        singular: 'resolutionrequest',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
        shortNames: [
          'resolutionrequest',
          'resolutionrequests',
        ],
      },
      versions: [
        {
          name: 'v1alpha1',
          served: true,
          storage: true,
          subresources: {
            status: {},
          },
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: ".status.conditions[?(@.type=='Succeeded')].status",
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: ".status.conditions[?(@.type=='Succeeded')].reason",
            },
          ],
        },
        {
          name: 'v1beta1',
          served: false,
          storage: false,
          subresources: {
            status: {},
          },
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: ".status.conditions[?(@.type=='Succeeded')].status",
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: ".status.conditions[?(@.type=='Succeeded')].reason",
            },
          ],
        },
      ],
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'pipelineresources.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      versions: [
        {
          name: 'v1alpha1',
          served: true,
          storage: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'PipelineResource',
        plural: 'pipelineresources',
        singular: 'pipelineresource',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
      },
      scope: 'Namespaced',
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'runs.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      preserveUnknownFields: false,
      versions: [
        {
          name: 'v1alpha1',
          served: true,
          storage: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].status',
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].reason',
            },
            {
              name: 'StartTime',
              type: 'date',
              jsonPath: '.status.startTime',
            },
            {
              name: 'CompletionTime',
              type: 'date',
              jsonPath: '.status.completionTime',
            },
          ],
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'Run',
        plural: 'runs',
        singular: 'run',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
      },
      scope: 'Namespaced',
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'tasks.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      preserveUnknownFields: false,
      versions: [
        {
          name: 'v1beta1',
          served: true,
          storage: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          subresources: {
            status: {},
          },
        },
        {
          name: 'v1',
          served: false,
          storage: false,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'Task',
        plural: 'tasks',
        singular: 'task',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
      },
      scope: 'Namespaced',
      conversion: {
        strategy: 'Webhook',
        webhook: {
          conversionReviewVersions: [
            'v1beta1',
            'v1',
          ],
          clientConfig: {
            service: {
              name: 'tekton-pipelines-webhook',
              namespace: 'tekton-pipelines',
            },
          },
        },
      },
    },
  },
  {
    apiVersion: 'apiextensions.k8s.io/v1',
    kind: 'CustomResourceDefinition',
    metadata: {
      name: 'taskruns.tekton.dev',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      group: 'tekton.dev',
      preserveUnknownFields: false,
      versions: [
        {
          name: 'v1beta1',
          served: true,
          storage: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].status',
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].reason',
            },
            {
              name: 'StartTime',
              type: 'date',
              jsonPath: '.status.startTime',
            },
            {
              name: 'CompletionTime',
              type: 'date',
              jsonPath: '.status.completionTime',
            },
          ],
          subresources: {
            status: {},
          },
        },
        {
          name: 'v1',
          served: false,
          storage: false,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              'x-kubernetes-preserve-unknown-fields': true,
            },
          },
          additionalPrinterColumns: [
            {
              name: 'Succeeded',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].status',
            },
            {
              name: 'Reason',
              type: 'string',
              jsonPath: '.status.conditions[?(@.type=="Succeeded")].reason',
            },
            {
              name: 'StartTime',
              type: 'date',
              jsonPath: '.status.startTime',
            },
            {
              name: 'CompletionTime',
              type: 'date',
              jsonPath: '.status.completionTime',
            },
          ],
          subresources: {
            status: {},
          },
        },
      ],
      names: {
        kind: 'TaskRun',
        plural: 'taskruns',
        singular: 'taskrun',
        categories: [
          'tekton',
          'tekton-pipelines',
        ],
        shortNames: [
          'tr',
          'trs',
        ],
      },
      scope: 'Namespaced',
      conversion: {
        strategy: 'Webhook',
        webhook: {
          conversionReviewVersions: [
            'v1beta1',
            'v1',
          ],
          clientConfig: {
            service: {
              name: 'tekton-pipelines-webhook',
              namespace: 'tekton-pipelines',
            },
          },
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      name: 'webhook-certs',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
      },
    },
  },
  {
    apiVersion: 'admissionregistration.k8s.io/v1',
    kind: 'ValidatingWebhookConfiguration',
    metadata: {
      name: 'validation.webhook.pipeline.tekton.dev',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
      },
    },
    webhooks: [
      {
        admissionReviewVersions: [
          'v1',
        ],
        clientConfig: {
          service: {
            name: 'tekton-pipelines-webhook',
            namespace: 'tekton-pipelines',
          },
        },
        failurePolicy: 'Fail',
        sideEffects: 'None',
        name: 'validation.webhook.pipeline.tekton.dev',
      },
    ],
  },
  {
    apiVersion: 'admissionregistration.k8s.io/v1',
    kind: 'MutatingWebhookConfiguration',
    metadata: {
      name: 'webhook.pipeline.tekton.dev',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
      },
    },
    webhooks: [
      {
        admissionReviewVersions: [
          'v1',
        ],
        clientConfig: {
          service: {
            name: 'tekton-pipelines-webhook',
            namespace: 'tekton-pipelines',
          },
        },
        failurePolicy: 'Fail',
        sideEffects: 'None',
        name: 'webhook.pipeline.tekton.dev',
      },
    ],
  },
  {
    apiVersion: 'admissionregistration.k8s.io/v1',
    kind: 'ValidatingWebhookConfiguration',
    metadata: {
      name: 'config.webhook.pipeline.tekton.dev',
      labels: {
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
      },
    },
    webhooks: [
      {
        admissionReviewVersions: [
          'v1',
        ],
        clientConfig: {
          service: {
            name: 'tekton-pipelines-webhook',
            namespace: 'tekton-pipelines',
          },
        },
        failurePolicy: 'Fail',
        sideEffects: 'None',
        name: 'config.webhook.pipeline.tekton.dev',
        objectSelector: {
          matchLabels: {
            'app.kubernetes.io/part-of': 'tekton-pipelines',
          },
        },
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      name: 'tekton-aggregate-edit',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
        'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
      },
    },
    rules: [
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
          'conditions',
        ],
        verbs: [
          'create',
          'delete',
          'deletecollection',
          'get',
          'list',
          'patch',
          'update',
          'watch',
        ],
      },
    ],
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      name: 'tekton-aggregate-view',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'rbac.authorization.k8s.io/aggregate-to-view': 'true',
      },
    },
    rules: [
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
          'conditions',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
    ],
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-artifact-bucket',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-artifact-pvc',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-defaults',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      _example: "################################\n#                              #\n#    EXAMPLE CONFIGURATION     #\n#                              #\n################################\n\n# This block is not actually functional configuration,\n# but serves to illustrate the available configuration\n# options and document them in a way that is accessible\n# to users that `kubectl edit` this config map.\n#\n# These sample configuration options may be copied out of\n# this example block and unindented to be in the data block\n# to actually change the configuration.\n\n# default-timeout-minutes contains the default number of\n# minutes to use for TaskRun and PipelineRun, if none is specified.\ndefault-timeout-minutes: \"60\"  # 60 minutes\n\n# default-service-account contains the default service account name\n# to use for TaskRun and PipelineRun, if none is specified.\ndefault-service-account: \"default\"\n\n# default-managed-by-label-value contains the default value given to the\n# \"app.kubernetes.io/managed-by\" label applied to all Pods created for\n# TaskRuns. If a user's requested TaskRun specifies another value for this\n# label, the user's request supercedes.\ndefault-managed-by-label-value: \"tekton-pipelines\"\n\n# default-pod-template contains the default pod template to use for\n# TaskRun and PipelineRun. If a pod template is specified on the\n# PipelineRun, the default-pod-template is merged with that one.\n# default-pod-template:\n\n# default-affinity-assistant-pod-template contains the default pod template\n# to use for affinity assistant pods. If a pod template is specified on the\n# PipelineRun, the default-affinity-assistant-pod-template is merged with\n# that one.\n# default-affinity-assistant-pod-template:\n\n# default-cloud-events-sink contains the default CloudEvents sink to be\n# used for TaskRun and PipelineRun, when no sink is specified.\n# Note that right now it is still not possible to set a PipelineRun or\n# TaskRun specific sink, so the default is the only option available.\n# If no sink is specified, no CloudEvent is generated\n# default-cloud-events-sink:\n\n# default-task-run-workspace-binding contains the default workspace\n# configuration provided for any Workspaces that a Task declares\n# but that a TaskRun does not explicitly provide.\n# default-task-run-workspace-binding: |\n#   emptyDir: {}\n\n# default-max-matrix-combinations-count contains the default maximum number\n# of combinations from a Matrix, if none is specified.\ndefault-max-matrix-combinations-count: \"256\"\n",
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'feature-flags',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      'disable-affinity-assistant': 'false',
      'disable-creds-init': 'false',
      'await-sidecar-readiness': 'true',
      'running-in-environment-with-injected-sidecars': 'true',
      'require-git-ssh-secret-known-hosts': 'false',
      'enable-tekton-oci-bundles': 'false',
      'enable-custom-tasks': 'false',
      'enable-api-fields': 'stable',
      'send-cloudevents-for-runs': 'false',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'pipelines-info',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      version: 'v0.40.1',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-leader-election',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      _example: '################################\n#                              #\n#    EXAMPLE CONFIGURATION     #\n#                              #\n################################\n# This block is not actually functional configuration,\n# but serves to illustrate the available configuration\n# options and document them in a way that is accessible\n# to users that `kubectl edit` this config map.\n#\n# These sample configuration options may be copied out of\n# this example block and unindented to be in the data block\n# to actually change the configuration.\n# lease-duration is how long non-leaders will wait to try to acquire the\n# lock; 15 seconds is the value used by core kubernetes controllers.\nlease-duration: "60s"\n# renew-deadline is how long a leader will try to renew the lease before\n# giving up; 10 seconds is the value used by core kubernetes controllers.\nrenew-deadline: "40s"\n# retry-period is how long the leader election client waits between tries of\n# actions; 2 seconds is the value used by core kubernetes controllers.\nretry-period: "10s"\n# buckets is the number of buckets used to partition key space of each\n# Reconciler. If this number is M and the replica number of the controller\n# is N, the N replicas will compete for the M buckets. The owner of a\n# bucket will take care of the reconciling for the keys partitioned into\n# that bucket.\nbuckets: "1"\n',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-logging',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      'zap-logger-config': '{\n  "level": "info",\n  "development": false,\n  "sampling": {\n    "initial": 100,\n    "thereafter": 100\n  },\n  "outputPaths": ["stdout"],\n  "errorOutputPaths": ["stderr"],\n  "encoding": "json",\n  "encoderConfig": {\n    "timeKey": "timestamp",\n    "levelKey": "severity",\n    "nameKey": "logger",\n    "callerKey": "caller",\n    "messageKey": "message",\n    "stacktraceKey": "stacktrace",\n    "lineEnding": "",\n    "levelEncoder": "",\n    "timeEncoder": "iso8601",\n    "durationEncoder": "",\n    "callerEncoder": ""\n  }\n}\n',
      'loglevel.controller': 'info',
      'loglevel.webhook': 'info',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-observability',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      _example: "################################\n#                              #\n#    EXAMPLE CONFIGURATION     #\n#                              #\n################################\n\n# This block is not actually functional configuration,\n# but serves to illustrate the available configuration\n# options and document them in a way that is accessible\n# to users that `kubectl edit` this config map.\n#\n# These sample configuration options may be copied out of\n# this example block and unindented to be in the data block\n# to actually change the configuration.\n\n# metrics.backend-destination field specifies the system metrics destination.\n# It supports either prometheus (the default) or stackdriver.\n# Note: Using Stackdriver will incur additional charges.\nmetrics.backend-destination: prometheus\n\n# metrics.stackdriver-project-id field specifies the Stackdriver project ID. This\n# field is optional. When running on GCE, application default credentials will be\n# used and metrics will be sent to the cluster's project if this field is\n# not provided.\nmetrics.stackdriver-project-id: \"<your stackdriver project id>\"\n\n# metrics.allow-stackdriver-custom-metrics indicates whether it is allowed\n# to send metrics to Stackdriver using \"global\" resource type and custom\n# metric type. Setting this flag to \"true\" could cause extra Stackdriver\n# charge.  If metrics.backend-destination is not Stackdriver, this is\n# ignored.\nmetrics.allow-stackdriver-custom-metrics: \"false\"\nmetrics.taskrun.level: \"task\"\nmetrics.taskrun.duration-type: \"histogram\"\nmetrics.pipelinerun.level: \"pipeline\"\nmetrics.pipelinerun.duration-type: \"histogram\"\n",
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-registry-cert',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'tekton-pipelines-controller',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/name': 'controller',
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.40.1',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          'app.kubernetes.io/name': 'controller',
          'app.kubernetes.io/component': 'controller',
          'app.kubernetes.io/instance': 'default',
          'app.kubernetes.io/part-of': 'tekton-pipelines',
        },
      },
      template: {
        metadata: {
          labels: {
            'app.kubernetes.io/name': 'controller',
            'app.kubernetes.io/component': 'controller',
            'app.kubernetes.io/instance': 'default',
            'app.kubernetes.io/version': 'v0.40.1',
            'app.kubernetes.io/part-of': 'tekton-pipelines',
            'pipeline.tekton.dev/release': 'v0.40.1',
            app: 'tekton-pipelines-controller',
            version: 'v0.40.1',
          },
        },
        spec: {
          affinity: {
            nodeAffinity: {
              requiredDuringSchedulingIgnoredDuringExecution: {
                nodeSelectorTerms: [
                  {
                    matchExpressions: [
                      {
                        key: 'kubernetes.io/os',
                        operator: 'NotIn',
                        values: [
                          'windows',
                        ],
                      },
                    ],
                  },
                ],
              },
            },
          },
          serviceAccountName: 'tekton-pipelines-controller',
          containers: [
            {
              name: 'tekton-pipelines-controller',
              image: 'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/controller:v0.40.1@sha256:02aef94088e2f5487b224c6a9d380cac7fa72e8fec883c9e2833569f302cb53c',
              args: [
                '-kubeconfig-writer-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/kubeconfigwriter:v0.40.1@sha256:6fbdec9b659be2a895edec1675fdc073217f4e1823e1baf1365fe60a671e7d84',
                '-git-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.40.1@sha256:6e875f2d66eb4cf9faceb06b60d840185a4fc71b9b16cf31f977c9c1b21abc28',
                '-entrypoint-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.40.1@sha256:4ef4d1ec86858cf370e8189fb9d6f7cfc32381b8f5d53cb42fd32fd8dd986637',
                '-nop-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/nop:v0.40.1@sha256:f9668bd0aa7beebd115e5e29c8e19a677db3fb9ffeeb4e6681eace0d0b5a4759',
                '-imagedigest-exporter-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/imagedigestexporter:v0.40.1@sha256:8ca77ef46e9ee2aab42badaf1553e05cd4ad2f2126b42ede422efb62be5ec763',
                '-pr-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/pullrequest-init:v0.40.1@sha256:840b5e181ec1c82af2bcf5da88840ca4af115f84c3cea5e0cc8877ccd75446ac',
                '-workingdirinit-image',
                'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/workingdirinit:v0.40.1@sha256:5746168c372d146837a1822c128515ba73a7cf5b9e3764dd6897c00eedcc8956',
                '-gsutil-image',
                'gcr.io/google.com/cloudsdktool/cloud-sdk@sha256:27b2c22bf259d9bc1a291e99c63791ba0c27a04d2db0a43241ba0f1f20f4067f',
                '-shell-image',
                'distroless.dev/busybox@sha256:19f02276bf8dbdd62f069b922f10c65262cc34b710eea26ff928129a736be791',
                '-shell-image-win',
                'mcr.microsoft.com/powershell:nanoserver@sha256:b6d5ff841b78bdf2dfed7550000fd4f3437385b8fa686ec0f010be24777654d6',
              ],
              volumeMounts: [
                {
                  name: 'config-logging',
                  mountPath: '/etc/config-logging',
                },
                {
                  name: 'config-registry-cert',
                  mountPath: '/etc/config-registry-cert',
                },
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
                  name: 'CONFIG_DEFAULTS_NAME',
                  value: 'config-defaults',
                },
                {
                  name: 'CONFIG_LOGGING_NAME',
                  value: 'config-logging',
                },
                {
                  name: 'CONFIG_OBSERVABILITY_NAME',
                  value: 'config-observability',
                },
                {
                  name: 'CONFIG_ARTIFACT_BUCKET_NAME',
                  value: 'config-artifact-bucket',
                },
                {
                  name: 'CONFIG_ARTIFACT_PVC_NAME',
                  value: 'config-artifact-pvc',
                },
                {
                  name: 'CONFIG_FEATURE_FLAGS_NAME',
                  value: 'feature-flags',
                },
                {
                  name: 'CONFIG_LEADERELECTION_NAME',
                  value: 'config-leader-election',
                },
                {
                  name: 'SSL_CERT_FILE',
                  value: '/etc/config-registry-cert/cert',
                },
                {
                  name: 'SSL_CERT_DIR',
                  value: '/etc/ssl/certs',
                },
                {
                  name: 'METRICS_DOMAIN',
                  value: 'tekton.dev/pipeline',
                },
              ],
              securityContext: {
                allowPrivilegeEscalation: false,
                capabilities: {
                  drop: [
                    'all',
                  ],
                },
                runAsUser: 65532,
                runAsGroup: 65532,
              },
              ports: [
                {
                  name: 'metrics',
                  containerPort: 9090,
                },
                {
                  name: 'profiling',
                  containerPort: 8008,
                },
                {
                  name: 'probes',
                  containerPort: 8080,
                },
              ],
              livenessProbe: {
                httpGet: {
                  path: '/health',
                  port: 'probes',
                  scheme: 'HTTP',
                },
                initialDelaySeconds: 5,
                periodSeconds: 10,
                timeoutSeconds: 5,
              },
              readinessProbe: {
                httpGet: {
                  path: '/readiness',
                  port: 'probes',
                  scheme: 'HTTP',
                },
                initialDelaySeconds: 5,
                periodSeconds: 10,
                timeoutSeconds: 5,
              },
            },
          ],
          volumes: [
            {
              name: 'config-logging',
              configMap: {
                name: 'config-logging',
              },
            },
            {
              name: 'config-registry-cert',
              configMap: {
                name: 'config-registry-cert',
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
        'app.kubernetes.io/name': 'controller',
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.40.1',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        app: 'tekton-pipelines-controller',
        version: 'v0.40.1',
      },
      name: 'tekton-pipelines-controller',
      namespace: 'tekton-pipelines',
    },
    spec: {
      ports: [
        {
          name: 'http-metrics',
          port: 9090,
          protocol: 'TCP',
          targetPort: 9090,
        },
        {
          name: 'http-profiling',
          port: 8008,
          targetPort: 8008,
        },
        {
          name: 'probes',
          port: 8080,
        },
      ],
      selector: {
        'app.kubernetes.io/name': 'controller',
        'app.kubernetes.io/component': 'controller',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  {
    apiVersion: 'autoscaling/v2beta1',
    kind: 'HorizontalPodAutoscaler',
    metadata: {
      name: 'tekton-pipelines-webhook',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/name': 'webhook',
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.40.1',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      minReplicas: 1,
      maxReplicas: 5,
      scaleTargetRef: {
        apiVersion: 'apps/v1',
        kind: 'Deployment',
        name: 'tekton-pipelines-webhook',
      },
      metrics: [
        {
          type: 'Resource',
          resource: {
            name: 'cpu',
            targetAverageUtilization: 100,
          },
        },
      ],
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'tekton-pipelines-webhook',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/name': 'webhook',
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.40.1',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        version: 'v0.40.1',
      },
    },
    spec: {
      selector: {
        matchLabels: {
          'app.kubernetes.io/name': 'webhook',
          'app.kubernetes.io/component': 'webhook',
          'app.kubernetes.io/instance': 'default',
          'app.kubernetes.io/part-of': 'tekton-pipelines',
        },
      },
      template: {
        metadata: {
          labels: {
            'app.kubernetes.io/name': 'webhook',
            'app.kubernetes.io/component': 'webhook',
            'app.kubernetes.io/instance': 'default',
            'app.kubernetes.io/version': 'v0.40.1',
            'app.kubernetes.io/part-of': 'tekton-pipelines',
            'pipeline.tekton.dev/release': 'v0.40.1',
            app: 'tekton-pipelines-webhook',
            version: 'v0.40.1',
          },
        },
        spec: {
          affinity: {
            nodeAffinity: {
              requiredDuringSchedulingIgnoredDuringExecution: {
                nodeSelectorTerms: [
                  {
                    matchExpressions: [
                      {
                        key: 'kubernetes.io/os',
                        operator: 'NotIn',
                        values: [
                          'windows',
                        ],
                      },
                    ],
                  },
                ],
              },
            },
            podAntiAffinity: {
              preferredDuringSchedulingIgnoredDuringExecution: [
                {
                  podAffinityTerm: {
                    labelSelector: {
                      matchLabels: {
                        'app.kubernetes.io/name': 'webhook',
                        'app.kubernetes.io/component': 'webhook',
                        'app.kubernetes.io/instance': 'default',
                        'app.kubernetes.io/part-of': 'tekton-pipelines',
                      },
                    },
                    topologyKey: 'kubernetes.io/hostname',
                  },
                  weight: 100,
                },
              ],
            },
          },
          serviceAccountName: 'tekton-pipelines-webhook',
          containers: [
            {
              name: 'webhook',
              image: 'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/webhook:v0.40.1@sha256:bb890af26f46853272577c39772cb2377bd550a3810de22b797cd9efbcc2636d',
              resources: {
                requests: {
                  cpu: '100m',
                  memory: '100Mi',
                },
                limits: {
                  cpu: '500m',
                  memory: '500Mi',
                },
              },
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
                  value: 'config-logging',
                },
                {
                  name: 'CONFIG_OBSERVABILITY_NAME',
                  value: 'config-observability',
                },
                {
                  name: 'CONFIG_LEADERELECTION_NAME',
                  value: 'config-leader-election',
                },
                {
                  name: 'CONFIG_FEATURE_FLAGS_NAME',
                  value: 'feature-flags',
                },
                {
                  name: 'WEBHOOK_SERVICE_NAME',
                  value: 'tekton-pipelines-webhook',
                },
                {
                  name: 'WEBHOOK_SECRET_NAME',
                  value: 'webhook-certs',
                },
                {
                  name: 'METRICS_DOMAIN',
                  value: 'tekton.dev/pipeline',
                },
              ],
              securityContext: {
                allowPrivilegeEscalation: false,
                capabilities: {
                  drop: [
                    'all',
                  ],
                },
                runAsUser: 65532,
                runAsGroup: 65532,
              },
              ports: [
                {
                  name: 'metrics',
                  containerPort: 9090,
                },
                {
                  name: 'profiling',
                  containerPort: 8008,
                },
                {
                  name: 'https-webhook',
                  containerPort: 8443,
                },
                {
                  name: 'probes',
                  containerPort: 8080,
                },
              ],
              livenessProbe: {
                httpGet: {
                  path: '/health',
                  port: 'probes',
                  scheme: 'HTTP',
                },
                initialDelaySeconds: 5,
                periodSeconds: 10,
                timeoutSeconds: 5,
              },
              readinessProbe: {
                httpGet: {
                  path: '/readiness',
                  port: 'probes',
                  scheme: 'HTTP',
                },
                initialDelaySeconds: 5,
                periodSeconds: 10,
                timeoutSeconds: 5,
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
        'app.kubernetes.io/name': 'webhook',
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/version': 'v0.40.1',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
        'pipeline.tekton.dev/release': 'v0.40.1',
        app: 'tekton-pipelines-webhook',
        version: 'v0.40.1',
      },
      name: 'tekton-pipelines-webhook',
      namespace: 'tekton-pipelines',
    },
    spec: {
      ports: [
        {
          name: 'http-metrics',
          port: 9090,
          targetPort: 9090,
        },
        {
          name: 'http-profiling',
          port: 8008,
          targetPort: 8008,
        },
        {
          name: 'https-webhook',
          port: 443,
          targetPort: 8443,
        },
        {
          name: 'probes',
          port: 8080,
        },
      ],
      selector: {
        'app.kubernetes.io/name': 'webhook',
        'app.kubernetes.io/component': 'webhook',
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
  },
  null,
]
