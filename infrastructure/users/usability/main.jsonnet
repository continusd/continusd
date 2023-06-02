local cd = import '../../lib/continuousd/app.libsonnet';

cd.app(
  namespace='default',
  name='hoge',
  image='nginx:mainline-alpine3.17-slim',
  containerPort=80,
  targetPort=8080,
  port=8080,
  replicas=3,
  serviceType='ClusterIP'  // only accessible within the cluster
)
