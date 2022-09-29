# Testing on local Minikube

```bash
# On one terminal, enable minikube tunnel
minikube tunnel --cleanup

# Then on another terminal, run:
kubecfg update test_service.jsonnet

# Verify that you have an External IP (should be 127.0.0.1) in the Service created
kubectl get all -n nusfriends-1

# Then test that you can hit the exposed container deployment
curl localhost:8080 # expect to see "hello world" response

# To clean up, just run
kubecfg delete test_service.jsonnet
```

You can also try the above steps with `nusfriends-1.jsonnet` instead of `test_service.jsonnet`

# Setting up Tekton

```bash
# Run this to setup tekton on our k8s.
kubecfg update internal-tekton.jsonnet

# Then monitor and wait:
# When both tekton-pipelines-controller and tekton-pipelines-webhook show 1/1 under the READY column, the setup is done.
kubectl get pods --namespace tekton-pipelines --watch

```

# Setting up Tekton Pipeline
Ensure Tekton is setup first (see above)

```bash
# Run this to setup tekton on our k8s.
kubecfg update test_pipeline.jsonnet

# Then monitor the pipeline like so.
kubectl get pipelineruns.tekton.dev --watch

# View the CI logs
kubectl logs --selector=tekton.dev/pipelineRun=test-run-run --all-containers -f --max-log-requests=8
```
