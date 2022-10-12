local d = import '../k8s/deployment.libsonnet';
local n = import '../k8s/namespace.libsonnet';
local s = import '../k8s/service.libsonnet';

/**
  * app is a nodejs application.
  */
{
  app(
    namespace='',
    name='',
    image='',
    replicas=3,
    containerPort=80,
    targetPort=80,
    port=8080,
    serviceType='LoadBalancer',
  )::
    assert namespace != '' : 'namespace is required';
    assert name != '' : 'name is required';
    assert image != '' : 'image is required';
    [
      //n.namespace(namespace),
      d.deployment(
        namespace=namespace,
        image=image,
        appName=name,
        containerPort=containerPort,
        replicas=replicas,
      ),
      s.service(
        namespace=namespace,
        name=name + '-service',
        selector=name,
        serviceType=serviceType,
        port=port,
        targetPort=targetPort,
      ),
    ],
}
