local t = import 'tekton/task.libsonnet';

local task_1 = 'hello-world';

[
  t.task(
    name=task_1,
    steps=[
      t.step(
        name='echo',
        image='alpine',
        script='#!/bin/sh\necho "Hello World"  \n',
      ),
      t.step(
        name='echo-too',
        image='alpine',
        script='#!/bin/sh\necho "Hello World too"  \n',
      ),
    ],
  ),
  t.task_run(
    task_1
  ),
]
