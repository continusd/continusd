local continuousda = import 'continuousd/app.libsonnet';
local continuousdr = import 'continuousd/read_access_role.libsonnet';

local NAMESPACE = 'nusfriends-1';

local USERS = [
  'yisheng',
  'metilda',
  'wengxian',
  'shaowei',
];

continuousda.app(
  namespace=NAMESPACE,
  name='nus-jira-app',
  image='pvermeyden/nodejs-hello-world:a1e8cf1edcc04e6d905078aed9861807f6da0da4',
  containerPort=80,
  targetPort=80,
  port=8080,
) +
[
  continuousdr.basic_read_access_role(NAMESPACE, USERS),
]
