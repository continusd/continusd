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
