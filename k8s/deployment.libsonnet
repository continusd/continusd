/**
  * deployment is kubernetes Deployment resource.
  */
{
  deployment(
    name='',
    namespace='default',
    image='',
    appName='',
    replicas=3,
    containerPort=80,
  )::
    local nameLocal = if name == '' then appName + '-deployment' else name;
    assert appName != '' : 'appName is required';
    assert image != '' : 'image is required';
    [
      {
        apiVersion: 'apps/v1',
        kind: 'Deployment',
        metadata: {
          name: nameLocal,
          namespace: namespace,
          labels: {
            'app.kubernetes.io/name': appName,
          },
        },
        spec: {
          replicas: replicas,
          selector: {
            matchLabels: {
              'app.kubernetes.io/name': appName,
            },
          },
          template: {
            metadata: {
              labels: {
                'app.kubernetes.io/name': appName,
              },
            },
            spec: {
              containers: [
                {
                  name: appName,
                  image: image,
                  ports: [
                    {
                      containerPort: containerPort,
                    },
                  ],
                },
              ],
            },
          },
        },
      },
    ],
}
