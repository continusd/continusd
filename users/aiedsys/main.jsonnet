local continuousda = import '../../lib/continuousd/app.libsonnet';
local continuousdr = import '../../lib/continuousd/read_access_role.libsonnet';

local NAMESPACE = 'aiedsys';

local USERS = [
  'e0493359@u.nus.edu',
  'e0165588@u.nus.edu',
  'e0493660@u.nus.edu',
  'kohshaowei2',
];

local v = continuousda.app(
            namespace=NAMESPACE,
            name='aiedsys',
            image='registry.gitlab.com/continusd/infrastructure/aiedsys-1:1',
            containerPort=80,
            targetPort=80,
            port=80,
            replicas=1,
          ) +
          [
            continuousdr.basic_read_access_role(NAMESPACE, USERS),
          ];

std.trace('' + std.toString(v), v)
