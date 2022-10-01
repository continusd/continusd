/**
  * role is kubernetes Role resource.
  */
{
  role(
    name='',
    namespace='default',
    apiGroups=[],
    resources=[],
    verbs=[],
  )::
    {
      apiVersion: 'rbac.authorization.k8s.io/v1',
      kind: 'Role',
      metadata: {
        name: name,
        namespace: namespace,
      },
      rules: [
        {
          apiGroups: apiGroups,
          resources: resources,
          verbs: verbs,
        },
      ],
    },
  rolebinding(
    name='',
    namespace='',
    roleRefName='',
    subjectName='',
  )::
    {
      apiVersion: 'rbac.authorization.k8s.io/v1',
      kind: 'RoleBinding',
      metadata: {
        name: name,
        namespace: namespace,
      },
      roleRef: {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'Role',
        name: roleRefName,
      },
      subjects: [
        {
          apiGroup: 'rbac.authorization.k8s.io',
          kind: 'User',
          name: subjectName,
        },
      ],
    },
}
