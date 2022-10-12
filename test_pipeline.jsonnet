local continuousdr = import 'continuousd/read_access_role.libsonnet';
local s = import 'k8s/serviceaccount.libsonnet';
local p = import 'tekton/pipeline.libsonnet';
local t = import 'tekton/task.libsonnet';
local v = import 'tekton/volume.libsonnet';

local pipeline_name = 'my-first-ci-pipeline';
local task_1 = 'deploy-application';
local tmp_vol = 'temp-vol';
local namespace = 'nusfriends-1';
local service_account_name = 'tekton-service-account';
local gitlab_secret_name = 'gitlab-creds';

[
  s.service_account(
    namespace=namespace,
    name=service_account_name,
  ),
  continuousdr.super_access_role(
    namespace=namespace,
    subjects=[
      service_account_name,
    ],
  ),
]
+
[
  t.task(
    namespace=namespace,
    name=task_1,
    steps=[
      t.step(
        name='clone-infrastructure-repo',
        image='alpine/git:2.36.2',
        command=['git'],
        env=[
          {
            name: 'GIT_USERNAME',
            valueFrom: {
              secretKeyRef: {
                name: gitlab_secret_name,
                key: 'username',
                optional: false,
              },
            },
          },
          {
            name: 'GIT_PASSWORD',
            valueFrom: {
              secretKeyRef: {
                name: gitlab_secret_name,
                key: 'password',
                optional: false,
              },
            },
          },
        ],
        args=['clone', '--branch', 'master', 'https://$(GIT_USERNAME):$(GIT_PASSWORD)@gitlab.com/continusd/infrastructure.git'],
        volumeMounts=[
          v.volume_mount(name=tmp_vol, mountPath='/git'),
          v.volume_mount(name=gitlab_secret_name, mountPath='/etc/gitlab-creds', readOnly=true),
        ],
      ),
      t.step(
        name='list-repo-contents',
        image='alpine',
        script=|||
          #!/bin/sh
          ls /git/infrastructure
          chmod +x /git/infrastructure/kubecfg
        |||,
        volumeMounts=[
          v.volume_mount(name=tmp_vol, mountPath='/git'),
        ],
      ),
      t.step(
        name='preview-k8s-yaml',
        image='alpine',
        script=|||
          #!/bin/sh
          /git/infrastructure/kubecfg show /git/infrastructure/nusfriends1.jsonnet
        |||,
        volumeMounts=[
          v.volume_mount(name=tmp_vol, mountPath='/git'),
        ],
      ),
      t.step(
        name='apply-kubecfg',
        image='alpine',
        script=|||
          #!/bin/sh
          /git/infrastructure/kubecfg update --token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) /git/infrastructure/nusfriends1.jsonnet
        |||,
        volumeMounts=[
          v.volume_mount(name=tmp_vol, mountPath='/git'),
        ],
      ),
    ],
    volumes=[
      v.empty_volume(tmp_vol),
      v.secret_volume(secretName=gitlab_secret_name),
    ],
  ),
  p.pipeline(
    namespace=namespace,
    name=pipeline_name,
    tasks=[
      {
        name: task_1,
        taskRef: {
          name: task_1,
        },
      },
    ]
  ),
  p.pipeline_run(
    namespace=namespace,
    pipeline=pipeline_name,
    serviceAccountName=service_account_name,
  ),
]
