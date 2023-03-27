local continuousda = import '../../lib/continuousd/app.libsonnet';
local continuousdr = import '../../lib/continuousd/read_access_role.libsonnet';
local continuousdd = import '../../lib/k8s/dashboard.libsonnet';

local NAMESPACE = 'aiedsys';

local USERS = [
];

continuousda.namespace(NAMESPACE)
+
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-frontend',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys-frontend:7',
  containerPort=3000,
  targetPort=3000,
  port=3000,
  replicas=3,
  serviceType='ClusterIP'  // only accessible within the cluster
) +
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-dashboard',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys-dashboard:4',
  containerPort=5000,
  targetPort=5000,
  port=5000,
  replicas=2,
  serviceType='ClusterIP'  // only accessible within the cluster
) +
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-learning-path',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys-learning-path:9',
  containerPort=5000,
  targetPort=5000,
  port=5000,
  replicas=2,
  serviceType='ClusterIP'  // only accessible within the cluster
) +
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-quizzes',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys-quizzes:5',
  containerPort=4500,
  targetPort=4500,
  port=4500,
  replicas=2,
  serviceType='ClusterIP'  // only accessible within the cluster
) +
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-assignments',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys-assignments:10',
  containerPort=5000,
  targetPort=5000,
  port=5000,
  replicas=2,
  serviceType='ClusterIP'  // only accessible within the cluster
) +
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-python-scripts',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys-python-scripts:6',
  containerPort=4800,
  targetPort=4800,
  port=4800,
  replicas=3,
  serviceType='ClusterIP'  // only accessible within the cluster
) +
continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-mongodb',
  image='mongo:latest',
  containerPort=27017,
  targetPort=27017,
  port=27017,
  appProtocol='mongo',
  replicas=1,
  serviceType='ClusterIP',  // only accessible within the cluster
  volumes=[
    {
      name: 'mongodb-pv-storage',
      persistentVolumeClaim: {
        claimName: 'aiedsys-mongo-pv-claim',
      },
    },
  ],
  volumeMounts=[
    {
      name: 'mongodb-pv-storage',
      mountPath: '/data/db',
    },
  ],
) +
continuousdd.dashboard(
  namespace=NAMESPACE,
  name='aiedsys-kubernetes-dashboard',
)
+
[
  {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: 'aiedsys-mongo-pv-claim',
      namespace: NAMESPACE,
    },
    spec: {
      storageClassName: 'do-block-storage',
      accessModes: [
        'ReadWriteOnce',
      ],
      resources: {
        requests: {
          storage: '10Gi',
        },
      },
    },
  },
  continuousdr.basic_read_access_role(NAMESPACE, USERS),
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: 'aiedsys-ingress',  // TODO: make into a module
      namespace: NAMESPACE,
    },
    spec: {
      rules: [
        {
          host: 'aiedsys.cantrips.dev',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'aiedsys-frontend-service',
                    port: {
                      number: 3000,
                    },
                  },
                },
              },
            ],
          },
        },
        {
          host: 'dashboard.cantrips.dev',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'aiedsys-dashboard-service',
                    port: {
                      number: 5000,
                    },
                  },
                },
              },
            ],
          },
        },
        {
          host: 'learning-path.cantrips.dev',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'aiedsys-learning-path-service',
                    port: {
                      number: 5000,
                    },
                  },
                },
              },
            ],
          },
        },
        {
          host: 'quizzes.cantrips.dev',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'aiedsys-quizzes-service',
                    port: {
                      number: 4500,
                    },
                  },
                },
              },
            ],
          },
        },
        {
          host: 'assignments.cantrips.dev',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'aiedsys-assignments-service',
                    port: {
                      number: 5000,
                    },
                  },
                },
              },
            ],
          },
        },
        {
          host: 'python-scripts.cantrips.dev',
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'aiedsys-python-scripts-service',
                    port: {
                      number: 4800,
                    },
                  },
                },
              },
            ],
          },
        },
      ],
    },
  },
]
