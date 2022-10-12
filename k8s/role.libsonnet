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
    subjectKind='User',
    subjectApiGroup='rbac.authorization.k8s.io',
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
          apiGroup: subjectApiGroup,
          namespace: namespace,
          kind: subjectKind,
          name: subjectName,
        },
      ],
    },
  clusterrole(
    name='',
    apiGroups=[],
    resources=[],
    verbs=[],
  )::
    {
      apiVersion: 'rbac.authorization.k8s.io/v1',
      kind: 'ClusterRole',
      metadata: {
        name: name,
      },
      rules: [
        {
          apiGroups: apiGroups,
          resources: resources,
          verbs: verbs,
        },
      ],
    },
  clusterrolebinding(
    namespace='',
    name='',
    roleRefName='',
    subjectName='',
  )::
    {
      apiVersion: 'rbac.authorization.k8s.io/v1',
      kind: 'ClusterRoleBinding',
      metadata: {
        name: name,
      },
      roleRef: {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'ClusterRole',
        name: roleRefName,
      },
      subjects: [
        {
          apiGroup: 'rbac.authorization.k8s.io',
          kind: 'ServiceAccount',
          namespace: namespace,
          name: subjectName,
        },
      ],
    },
}
