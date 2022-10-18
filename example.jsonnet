local continuousda = import 'continuousd/app.libsonnet';
local continuousdr = import 'continuousd/read_access_role.libsonnet';

local NAMESPACE = 'my-team-name';

local USERS = [
  'user01@u.nus.edu',
  'user02@u.nus.edu'
];

continuousda.app(
  namespace=NAMESPACE,
  name='my-project-name',
  image='image-file',
  containerPort=80,
  targetPort=80,
  port=8088,
) +
[
  continuousdr.basic_read_access_role(NAMESPACE, USERS),
]
