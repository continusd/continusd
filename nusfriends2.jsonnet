local continuousda = import 'continuousd/app.libsonnet';
local continuousdr = import 'continuousd/read_access_role.libsonnet';

local NAMESPACE = 'nusfriends-2';

local USERS = [
  'e0493359@u.nus.edu',
  'e0165588@u.nus.edu',
  'e0493660@u.nus.edu',
  'shaowei',
];

local v =continuousda.app(
  namespace=NAMESPACE,
  name='nus-jira-app-2',
  image='metchee/hello-world-js',
  containerPort=80,
  targetPort=80,
  port=8089,
  replicas=1,
) +
[
  continuousdr.basic_read_access_role(NAMESPACE, USERS),
];

std.trace('' + std.toString(v), v)