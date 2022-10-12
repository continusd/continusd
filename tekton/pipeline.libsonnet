/**
  * pipeline is a Tekton Pipeline resource.
  */
{
  pipeline(
    namespace='default',
    name='',
    tasks=null,
  )::
    assert name != '' : 'name is required';
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'Pipeline',
      metadata: {
        name: name,
        namespace: namespace,
      },
      spec: {
        tasks: tasks,
      },
    },
  pipeline_run(
    namespace='default',
    name='',
    pipeline='',
    serviceAccountName='',
  )::
    assert name != '' : 'name is required';
    assert pipeline != '' : 'pipeline is required';
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'PipelineRun',
      metadata: {
        name: name,
        namespace: namespace,
      },
      spec: {
        serviceAccountName: serviceAccountName,
        pipelineRef: {
          name: pipeline,
        },
      },
    },
}
