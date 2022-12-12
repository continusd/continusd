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
        rules=[
          {
            apiGroups: ['', 'apps'],
            resources: ['*'],
            verbs: ['get', 'list'],
          },
        ],
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
  /**
    * super_access_role for a namespace.
    */
  super_access_role(
    namespace='',
    subjects=null,
  )::
    assert namespace != '' : 'namespace is required';
    local role_name = namespace + '-super-access';
    [
      r.role(
        namespace=namespace,
        name=role_name,
        rules=[
          {
            apiGroups: ['', '*'],
            resources: ['*'],
            verbs: ['*'],
          },
        ],
      ),
      [
        r.rolebinding(
          namespace=namespace,
          name=role_name + '-binding-' + subject,
          roleRefName=role_name,
          subjectName=subject,
          subjectKind='ServiceAccount',
          subjectApiGroup='',
        )
        for subject in subjects
      ],
    ],
}
