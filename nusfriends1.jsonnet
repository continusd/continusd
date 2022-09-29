local continuousd = import 'continuousd/app.libsonnet';

local NAMESPACE = 'nusfriends-1';

continuousd.app(
  namespace=NAMESPACE,
  name='nus-jira-app',
  image='pvermeyden/nodejs-hello-world:a1e8cf1edcc04e6d905078aed9861807f6da0da4',
  containerPort=80,
  targetPort=80,
  port=8080,
)
