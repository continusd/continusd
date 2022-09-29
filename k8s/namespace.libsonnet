/**
  * namespace is kubernetes Namespace resource.
  */
{
  namespace(
    name='',
  )::
    assert name != '' : 'name is required';
    [
      {
        apiVersion: 'v1',
        kind: 'Namespace',
        metadata: {
          name: name,
          labels: {
            name: name,
          },
        },
      },
    ],
}
