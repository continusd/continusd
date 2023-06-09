local continuousdr = import '../lib/continuousd/read_access_role.libsonnet';
local s = import '../lib/k8s/serviceaccount.libsonnet';
local p = import '../lib/tekton/pipeline.libsonnet';
local t = import '../lib/tekton/task.libsonnet';
local v = import '../lib/tekton/volume.libsonnet';

local pipeline_name = 'aiedsys-app-pipeline';
local task_1 = 'deploy-application';
local tmp_vol = 'temp-vol';
local namespace = 'aiedsys';
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
      //t.step(
      //  name='check-has-changed-non-namespaces-directories',
      //  image='alpine/git:2.36.2',
      //  script=|||
      //    #!/bin/sh
      //    cd /git/infrastructure
      //    echo "Files changed:"
      //    git diff --name-status $CI_COMMIT_SHA..master # show changed files
      //    git diff --name-status $CI_COMMIT_SHA..master | grep -v namespaces/ | grep namespaces/
      //    # This script will exit with non-zero exit code if files changed contains namespaces
      //  |||,
      //  env=[
      //    {
      //      name: 'CI_COMMIT_SHA',
      //      value: std.extVar('CI_COMMIT_SHA'),
      //    },
      //  ],
      //  volumeMounts=[
      //    v.volume_mount(name=tmp_vol, mountPath='/git'),
      //  ],
      //),
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
          /git/infrastructure/kubecfg show /git/infrastructure/users/aiedsys/main.jsonnet
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
          /git/infrastructure/kubecfg update --token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) /git/infrastructure/users/aiedsys/main.jsonnet
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
    name=std.extVar('CI_COMMIT_SHA'),
    namespace=namespace,
    pipeline=pipeline_name,
    serviceAccountName=service_account_name,
  ),
]
