/**
  * task is a Tekton Task resource.
  */
{
  task(
    namespace='default',
    name='',
    steps=null,
    volumes=null,
  )::
    assert name != '' : 'name is required';
    //assert std.length(steps) == 0 : 'steps is required';
    // TODO: check steps are of type steps?
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'Task',
      metadata: {
        name: name,
        namespace: namespace,
      },
      spec: {
        steps: steps,
        volumes: volumes,
      },
    },
  step(
    name='',
    image='',
    script='',
    volumeMounts=null,
    command=null,
    args=null,
    env=null,
  )::
    {
      name: name,
      image: image,
      script: script,
      volumeMounts: volumeMounts,
      command: command,
      args: args,
      env: env,
    },
  task_run(
    task='',
    namespace='default',
  )::
    assert task != '' : 'Please specify which task to run. Use the task.name.';
    {
      apiVersion: 'tekton.dev/v1beta1',
      kind: 'TaskRun',
      metadata: {
        name: task + '-run',  // TODO: change to randomly generated or date timestamp
        namespace: namespace,
      },
      spec: {
        taskRef: {
          name: task,
        },
      },
    },
}
