local d = import 'k8s/deployment.libsonnet';
local n = import 'k8s/namespace.libsonnet';
local s = import 'k8s/service.libsonnet';

local NAMESPACE = 'nusfriends-1';

[
  n.namespace(NAMESPACE),
  d.deployment(
    namespace=NAMESPACE,
    image='pvermeyden/nodejs-hello-world:a1e8cf1edcc04e6d905078aed9861807f6da0da4',
    appName='test1',
    containerPort=80,
  ),
  s.service(
    namespace=NAMESPACE,
    name='test1-service',
    selector='test1',
    serviceType='LoadBalancer',
    port=8080,
    targetPort=80,
  ),
]
