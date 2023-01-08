/**
  * service_account is kubernetes ServiceAccount resource.
  */
{
  service_account(
    name='',
    namespace='default',
  )::
    assert name != '' : 'name is required';
    {
      apiVersion: 'v1',
      kind: 'ServiceAccount',
      metadata: {
        name: name,
        namespace: namespace,
        labels: {
          'app.kubernetes.io/name': name,
        },
      },
    },
}
