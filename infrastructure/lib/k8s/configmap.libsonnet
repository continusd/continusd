/* 
* configmap is ConfigMap resource 
*/
{
    configmap(
        name='',
        namespace='',
    )::{
        kind: 'ConfigMap',
        apiVersion: 'v1',
        metadata: {
            name: name,
            namespace: namespace,
        }
    },
}