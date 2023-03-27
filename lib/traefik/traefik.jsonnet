[
  {
    kind: 'ClusterRole',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'traefik-role',
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'services',
          'endpoints',
          'secrets',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'extensions',
          'networking.k8s.io',
        ],
        resources: [
          'ingresses',
          'ingressclasses',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'extensions',
          'networking.k8s.io',
        ],
        resources: [
          'ingresses/status',
        ],
        verbs: [
          'update',
        ],
      },
    ],
  },
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: 'traefik-account',
    },
  },
  {
    kind: 'ClusterRoleBinding',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'traefik-role-binding',
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: 'traefik-role',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'traefik-account',
        namespace: 'default',
      },
    ],
  },
  {
    kind: 'Deployment',
    apiVersion: 'apps/v1',
    metadata: {
      name: 'traefik-deployment',
      labels: {
        app: 'traefik',
      },
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: 'traefik',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'traefik',
          },
          annotations: {
            'prometheus.io/scrape': 'true',
            'prometheus.io/port': '80',
          },
        },
        spec: {
          serviceAccountName: 'traefik-account',
          containers: [
            {
              name: 'traefik',
              image: 'traefik:v2.9',
              args: [
                '--api.dashboard',
                '--api.insecure',
                '--providers.kubernetesingress',
                '--accesslog',
                '--log.level=DEBUG',
                '--metrics',
                '--metrics.prometheus=true',
                '--metrics.prometheus.buckets=0.1,0.3,1.2,5.0,10.0',
                '--metrics.prometheus.addServicesLabels=true',
              ],
              ports: [
                {
                  name: 'web',
                  containerPort: 80,
                },
                {
                  name: 'dashboard',
                  containerPort: 8080,
                },
              ],
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
      name: 'traefik-dashboard-service',
    },
    spec: {
      type: 'ClusterIP',
      ports: [
        {
          port: 8080,
          targetPort: 'dashboard',
        },
      ],
      selector: {
        app: 'traefik',
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'traefik-web-service',
    },
    spec: {
      type: 'LoadBalancer',
      ports: [
        {
          targetPort: 'web',
          port: 80,
        },
      ],
      selector: {
        app: 'traefik',
      },
    },
  },
]
