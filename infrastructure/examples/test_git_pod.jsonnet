local m = import 'k8s/pod.libsonnet';

m.pod(
  name='git-test',
  image='alpine/git:2.36.2',
  volumeMounts=[
    {
      name: 'git-storage',
      mountPath: '/git',
    },
  ],
  volumes=[
    {
      name: 'git-storage',
      emptyDir: {},
    },
  ],
  command=['git'],
  args=['clone', 'https://github.com/vmware-archive/kubecfg'],
)
