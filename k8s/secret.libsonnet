/**
* secret is kubernetes Secret application.
*/
{
    secret(
        name='', 
        namespace='',
        csrf=false,
    )::
    {
        apiVersion: 'v1',
        kind: 'Secret',
        metadata:{
            name: name,
            namespace: namespace,
        },
        type: 'Opaque',
        data: if (csrf) then {
            csrf: ""
        }, 
    },
}