/**
  * service is kubernetes Service resource.
  */
{
  service(
    name='',
    namespace='default',
    selector='',
    serviceType='LoadBalancer',  // TODO: change to constants.
    protocol='TCP',
    port=80,
    targetPort=80,
  )::
    assert name != '' : 'name is required';
    assert selector != '' : 'selector is required';
    [
      {
        apiVersion: 'v1',
        kind: 'Service',
        metadata: {
          name: name,
          namespace: namespace,
        },
        spec: {
          type: serviceType,
          selector: {
            'app.kubernetes.io/name': selector,
          },
          ports: [
            {
              protocol: protocol,
              port: port,
              targetPort: targetPort,
            },
          ],
        },
      },
    ],
}
