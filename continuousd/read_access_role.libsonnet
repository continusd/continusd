local r = import '../k8s/role.libsonnet';

/**
  * basic_read_access_role is a read-only role to a given namespace.
  */
{
  basic_read_access_role(
    namespace='',
    subjectName='',
  )::
    assert namespace != '' : 'namespace is required';
    assert subjectName != '' : 'subjectName is required';
    local role_name = namespace + '-basic-read-access';
    [
      r.role(
        name=role_name,
        namespace=namespace,
        apiGroups=['', 'apps'],
        resources=['*'],
        verbs=['get', 'list'],
      ),
      r.rolebinding(
        name=role_name + '-binding-' + subjectName,
        namespace=namespace,
        roleRefName=role_name,
        subjectName=subjectName,
      ),
    ],
}
