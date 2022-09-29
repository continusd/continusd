/**
  * pipeline is a Tekton Pipeline resource.
  */
{
  pipeline(
    name='',
    tasks=null,
  )::
    assert name != '' : 'name is required';
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'Pipeline',
      metadata: {
        name: name,
      },
      spec: {
        tasks: tasks,
      },
    },
  pipeline_run(
    name='',
    pipeline='',
  )::
    assert name != '' : 'name is required';
    assert pipeline != '' : 'pipeline is required';
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'PipelineRun',
      metadata: {
        name: name + '-run',
      },
      spec: {
        pipelineRef: {
          name: pipeline,
        },
      },
    },
}
