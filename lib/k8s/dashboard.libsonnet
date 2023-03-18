local continuousdr = import '../continuousd/read_access_role.libsonnet';
local c = import './configmap.libsonnet';
local d = import './deployment.libsonnet';
local n = import './namespace.libsonnet';
local r = import './role.libsonnet';
local secret = import './secret.libsonnet';
local s = import './service.libsonnet';
local a = import './serviceaccount.libsonnet';

/**
  * dashboard is a combination of kubernetes resource.
  * See: https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml
  */
{
  dashboard(
    name='',
    namespace='',
    image='kubernetesui/dashboard:v2.6.1',
    targetPort=8443,
    port=443,
    dashboardPort=3000,
    scrapperPort=8000
  )::
    assert namespace != '' : 'namespace is required';
    assert name != '' : 'name is required';
    assert image != '' : 'image is required';
    [
      {
        apiVersion: 'v1',
        kind: 'ServiceAccount',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard',
          namespace: namespace,
        },
      },
      //{
      //  kind: 'Service',
      //  apiVersion: 'v1',
      //  metadata: {
      //    labels: {
      //      'k8s-app': 'kubernetes-dashboard',
      //    },
      //    name: 'kubernetes-dashboard',
      //    namespace: namespace,
      //  },
      //  spec: {
      //    ports: [
      //      {
      //        protocol: 'TCP',
      //        port: 443,
      //        targetPort: 8443,
      //      },
      //    ],
      //    externalTrafficPolicy: 'Cluster',
      //    type: 'NodePort',
      //    selector: {
      //      'k8s-app': 'kubernetes-dashboard',
      //    },
      //  },
      //},
      {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard-certs',
          namespace: namespace,
        },
        type: 'Opaque',
      },
      {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard-csrf',
          namespace: namespace,
        },
        type: 'Opaque',
        data: {
          csrf: '',
        },
      },
      {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard-key-holder',
          namespace: namespace,
        },
        type: 'Opaque',
      },
      {
        kind: 'ConfigMap',
        apiVersion: 'v1',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard-settings',
          namespace: namespace,
        },
      },
      {
        kind: 'Role',
        apiVersion: 'rbac.authorization.k8s.io/v1',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard',
          namespace: namespace,
        },
        rules: [
          {
            apiGroups: [''],
            resources: ['secrets'],
            resourceNames: ['kubernetes-dashboard-key-holder', 'kubernetes-dashboard-certs', 'kubernetes-dashboard-csrf'],
            verbs: ['get', 'update', 'delete', 'list'],
          },
          {
            apiGroups: [''],
            resources: ['configmaps'],
            resourceNames: ['kubernetes-dashboard-settings'],
            verbs: ['get', 'update', 'list'],
          },
          {
            apiGroups: [''],
            resources: ['services'],
            resourceNames: ['heapster', 'dashboard-metrics-scraper'],
            verbs: ['proxy'],
          },
          {
            apiGroups: [''],
            resources: ['services/proxy'],
            resourceNames: ['heapster', 'http:heapster:', 'https:heapster:', 'dashboard-metrics-scraper', 'http:dashboard-metrics-scraper'],
            verbs: ['get', 'list'],
          },
          {
            apiGroups: [''],
            resources: ['pods', 'secrets', 'services', 'persistentvolumeclaims', 'pods/log', 'namespaces', 'jobs/batch', 'events'],
            verbs: ['get', 'list', 'watch'],
          },
          {
            apiGroups: ['extensions', 'apps'],
            resources: ['deployments', 'replicasets'],
            verbs: ['get', 'list', 'watch'],
          },
        ],
      },
      //{
      //  kind: "ClusterRole",
      //  apiVersion: "rbac.authorization.k8s.io/v1",
      //  metadata: {
      //    labels: {
      //      "k8s-app": "kubernetes-dashboard"
      //    },
      //    name: "kubernetes-dashboard",
      //  },
      //  rules: [
      //    {
      //      apiGroups: ["metrics.k8s.io"],
      //      resources: ["pods", "nodes"],
      //      verbs: ["get", "list", "watch"]
      //    },
      //  ],
      //},
      {
        apiVersion: 'rbac.authorization.k8s.io/v1',
        kind: 'RoleBinding',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard',
          namespace: namespace,
        },
        roleRef: {
          apiGroup: 'rbac.authorization.k8s.io',
          kind: 'Role',
          name: 'kubernetes-dashboard',
        },
        subjects: [
          {
            kind: 'ServiceAccount',
            name: 'kubernetes-dashboard',
            namespace: namespace,
          },
        ],
      },
      //{
      //  apiVersion: "rbac.authorization.k8s.io/v1",
      //  kind: "ClusterRoleBinding",
      //  metadata: {
      //    name: "kubernetes-dashboard"
      //  },
      //  roleRef: {
      //    apiGroup: "rbac.authorization.k8s.io",
      //    kind: "ClusterRole",
      //    name: "kubernetes-dashboard",
      //  },
      //  subjects: [
      //    {
      //      kind: "ServiceAccount",
      //      name: "kubernetes-dashboard",
      //      namespace: namespace,
      //    },
      //  ],
      //},
      {
        kind: 'Deployment',
        apiVersion: 'apps/v1',
        metadata: {
          labels: {
            'k8s-app': 'kubernetes-dashboard',
          },
          name: 'kubernetes-dashboard',
          namespace: namespace,
        },
        spec: {
          replicas: 1,
          revisionHistoryLimit: 10,
          selector: {
            matchLabels: {
              'k8s-app': 'kubernetes-dashboard',
            },
          },
          template: {
            metadata: {
              labels: {
                'k8s-app': 'kubernetes-dashboard',
              },
            },
            spec: {
              securityContext: {
                seccompProfile:
                  {
                    type: 'RuntimeDefault',
                  },
              },
              containers:
                [
                  {
                    name: 'kubernetes-dashboard',
                    image: 'kubernetesui/dashboard:v2.6.1',
                    imagePullPolicy: 'Always',
                    ports: [
                      {
                        containerPort: 9090,
                        protocol: 'TCP',
                      },
                    ],
                    args: [
                      '--enable-skip-login',
                      '--disable-settings-authorizer',
                      '--enable-insecure-login',
                      '--insecure-bind-address=0.0.0.0',
                      //'--auto-generate-certificates',
                      '--namespace=' + namespace,
                    ],
                    volumeMounts: [
                      {
                        name: 'kubernetes-dashboard-certs',
                        mountPath: '/certs',
                      },
                      {
                        mountPath: '/tmp',
                        name: 'tmp-volume',
                      },
                    ],
                    livenessProbe: {
                      httpGet: {
                        scheme: 'HTTP',
                        path: '/',
                        port: 9090,
                      },
                      initialDelaySeconds: 30,
                      timeoutSeconds: 30,
                    },
                    securityContext: {
                      allowPrivilegeEscalation: false,
                      readOnlyRootFilesystem: true,
                      runAsUser: 1001,
                      runAsGroup: 2001,
                    },
                  },
                ],
              volumes: [
                {
                  name: 'kubernetes-dashboard-certs',
                  secret: {
                    secretName: 'kubernetes-dashboard-certs',
                  },
                },
                {
                  name: 'tmp-volume',
                  emptyDir: {},
                },
              ],
              serviceAccountName: 'kubernetes-dashboard',
              nodeSelector: {
                'kubernetes.io/os': 'linux',
              },
              tolerations: [
                {
                  key: 'node-role.kubernetes.io/master',
                  effect: 'NoSchedule',
                },
              ],
            },
          },
        },
      },
      {
        kind: 'Service',
        apiVersion: 'v1',
        metadata: {
          labels: {
            'k8s-app': 'dashboard-metrics-scraper',
          },
          name: 'dashboard-metrics-scraper',
          namespace: namespace,
        },
        spec: {
          ports: [
            {
              port: 8000,
              targetPort: 8000,
            },
          ],
          selector: {
            'k8s-app': 'dashboard-metrics-scraper',
          },
        },
      },
      {
        kind: 'Deployment',
        apiVersion: 'apps/v1',
        metadata: {
          labels: {
            'k8s-app': 'dashboard-metrics-scraper',
          },
          name: 'dashboard-metrics-scraper',
          namespace: namespace,
        },
        spec: {
          replicas: 1,
          revisionHistoryLimit: 10,
          selector: {
            matchLabels: {
              'k8s-app': 'dashboard-metrics-scraper',
            },
          },
          template: {
            metadata: {
              labels: {
                'k8s-app': 'dashboard-metrics-scraper',
              },
            },
            spec: {
              securityContext: {
                seccompProfile: {
                  type: 'RuntimeDefault',
                },
              },
              containers: [
                {
                  name: 'dashboard-metrics-scraper',
                  image: 'kubernetesui/metrics-scraper:v1.0.8',
                  ports: [
                    {
                      containerPort: 8000,
                      protocol: 'TCP',
                    },
                  ],
                  livenessProbe: {
                    httpGet: {
                      scheme: 'HTTP',
                      path: '/',
                      port: 8000,
                    },
                    initialDelaySeconds: 30,
                    timeoutSeconds: 30,
                  },
                  volumeMounts: [
                    {
                      mountPath: '/tmp',
                      name: 'tmp-volume',
                    },
                  ],
                  securityContext: {
                    allowPrivilegeEscalation: false,
                    readOnlyRootFilesystem: true,
                    runAsUser: 1001,
                    runAsGroup: 2001,
                  },
                },
              ],
              serviceAccountName: 'kubernetes-dashboard',
              nodeSelector: {
                'kubernetes.io/os': 'linux',
              },
              tolerations: [
                {
                  key: 'node-role.kubernetes.io/master',
                },
              ],
              volumes: [
                {
                  name: 'tmp-volume',
                  emptyDir: {},
                },
              ],
            },
          },
        },
      },
    ],
}
