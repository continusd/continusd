/**
  * pod is kubernetes Pod resource.
  */
{
  pod(
    name='',
    namespace='default',
    image='',
    volumeMounts=[],
    volumes=[],
    command=[],
    args=[],
  )::
    assert name != '' : 'name is required';
    assert image != '' : 'image is required';
    [
      {
        apiVersion: 'v1',
        kind: 'Pod',
        metadata: {
          name: name,
          namespace: namespace,
        },
        spec: {
          containers: [
            {
              name: name,
              image: image,
              volumeMounts: volumeMounts,
              command: command,
              args: args,
            },
          ],
          volumes: volumes,
          imagePullSecret: [
            {
              name: 'regcred',
            },
          ],
        },
      },
    ],
}
