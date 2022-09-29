local p = import 'tekton/pipeline.libsonnet';
local t = import 'tekton/task.libsonnet';

local pipeline_name = 'my-first-ci-pipeline';
local task_1 = 'hello-world';
local task_2 = 'bye-world';

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
  t.task(
    name=task_2,
    steps=[
      t.step(
        name='echo',
        image='alpine',
        script='#!/bin/sh\necho "Bye World"  \n',
      ),
      t.step(
        name='echo-too',
        image='alpine',
        script='#!/bin/sh\necho "Bye World too"  \n',
      ),
    ],
  ),
  p.pipeline(
    name=pipeline_name,
    tasks=[
      {
        name: task_1,
        taskRef: {
          name: task_1,
        },
      },
      {
        name: task_2,
        runAfter: [
          task_1,
        ],
        taskRef: {
          name: task_2,
        },
      },
    ]
  ),
  p.pipeline_run(
    name='test-run',
    pipeline=pipeline_name
  ),
]
