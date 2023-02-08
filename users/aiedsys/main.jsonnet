local continuousda = import '../../lib/continuousd/app.libsonnet';
local continuousdr = import '../../lib/continuousd/read_access_role.libsonnet';

local NAMESPACE = 'aiedsys';

local USERS = [
];

continuousda.app(
  namespace=NAMESPACE,
  name='aiedsys-frontend',
  image='registry.gitlab.com/continusd/infrastructure/aiedsys:1',
  containerPort=3000,
  targetPort=3000,
  port=3000,
  replicas=1,
  env=[
    {
      name: 'REACT_APP_SERVER',
      value: 'http://localhost:5000',
    },
    {
      name: 'CHOKIDAR_USEPOLLING',
      value: 'true',
    },
  ],
) +
[
  continuousdr.basic_read_access_role(NAMESPACE, USERS),
]
