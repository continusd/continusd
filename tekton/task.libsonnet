/**
  * task is a Tekton Task resource.
  */
{
  task(
    name='',
    steps=null,
  )::
    assert name != '' : 'name is required';
    //assert std.length(steps) == 0 : 'steps is required';
    // TODO: check steps are of type steps?
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'Task',
      metadata: {
        name: name,
      },
      spec: {
        steps: steps,
      },
    },
  step(
    name='',
    image='',
    script='',
  )::
    {
      name: name,
      image: image,
      script: script,
    },
  task_run(
    task='',
  )::
    assert task != '' : 'Please specify which task to run. Use the task.name.';
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'TaskRun',
      metadata: {
        name: task + '-run',  // TODO: change to randomly generated or date timestamp
      },
      spec: {
        taskRef: {
          name: task,
        },
      },
    },
}
