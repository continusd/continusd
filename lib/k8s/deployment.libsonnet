/**
  * deployment is kubernetes Deployment resource.
  */
{
  deployment(
    name='',
    namespace='default',
    image='',
    appName='',
    replicas=1,
    containerPort=80,
    volumes=[],
    volumeMounts=[],
  )::
    local nameLocal = if name == '' then appName + '-deployment' else name;
    assert appName != '' : 'appName is required';
    assert image != '' : 'image is required';
    local version = '1';
    [
      {
        apiVersion: 'apps/v1',
        kind: 'Deployment',
        metadata: {
          name: nameLocal,
          namespace: namespace,
          labels: {
            'app.kubernetes.io/name': appName,
            app: appName,
            version: version,
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
                app: appName,
                version: version,
              },
            },
            spec: {
              volumes: volumes,
              containers: [
                {
                  name: appName,
                  image: image,
                  ports: [
                    {
                      containerPort: containerPort,
                    },
                  ],
                  volumeMounts: volumeMounts,
                },
              ],
              imagePullSecrets: [
                {
                  name: 'regcred',
                },
              ],
            },
          },
        },
      },
    ],
}
