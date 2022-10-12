/**
  * empty_volume is a Volume resource that can be attached to the container; and it's empty.
  * See: https://tekton.dev/docs/pipelines/tasks/#specifying-volumes
  */
{
  empty_volume(
    name='',
  )::
    assert name != '' : 'name is required';
    {
      name: name,
      emptyDir: {},
    },
  secret_volume(
    name='',
    secretName='',
  )::
    assert secretName != '' : 'secretName is required';
    local localName = if name == '' then secretName else name;
    {
      name: localName,
      secret: {
        secretName: secretName,
      },
    },
  volume_mount(
    name='',
    mountPath='',
    readOnly=false,
  )::
    assert name != '' : 'name is required';
    assert mountPath != '' : 'mountPath is required';
    {
      name: name,
      mountPath: mountPath,
      readOnly: readOnly,
    },
}
