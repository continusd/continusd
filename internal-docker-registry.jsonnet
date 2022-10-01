local continuousd = import 'continuousd/app.libsonnet';

local NAMESPACE = 'continuousd-registry';

continuousd.app(
  namespace=NAMESPACE,
  name='continuousd-registry',
  image='registry:2',
  containerPort=5000,
  targetPort=5000,
  port=5000,
  replicas=1,
  serviceType='ClusterIP',
)
