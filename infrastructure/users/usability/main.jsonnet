local continusd = import '../../lib/continuousd/app.libsonnet';

continusd.app(
  namespace='default',
  name='my-first-app',
  image='nginx:mainline-alpine3.17-slim',
  containerPort=80,
  targetPort=80,
  port=8080,
  replicas=2,
  serviceType='ClusterIP'  // only accessible within the cluster
)
