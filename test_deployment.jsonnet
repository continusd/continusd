local m = import 'k8s/deployment.libsonnet';

{
  actual: m.deployment(
    image='pvermeyden/nodejs-hello-world:a1e8cf1edcc04e6d905078aed9861807f6da0da4',
    appLabel='test1',
    containerPort=8080,
  ),
}
