local r = import '../k8s/role.libsonnet';

/**
  * basic_read_access_role is a read-only role to a given namespace.
  */
{
  basic_read_access_role(
    namespace='',
    subjects=[],
  )::
    assert namespace != '' : 'namespace is required';
    local role_name = namespace + '-basic-read-access';
    [
      r.role(
        name=role_name,
        namespace=namespace,
        apiGroups=['', 'apps'],
        resources=['*'],
        verbs=['get', 'list'],
      ),
      [
        r.rolebinding(
          name=role_name + '-binding-' + subject,
          namespace=namespace,
          roleRefName=role_name,
          subjectName=subject,
        )
        for subject in subjects
      ],
    ],
}
