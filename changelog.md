 - remove all hardcoded values
 - fix labels for all services / deployments / not sure what is creating the instance one, maybe argocd?... 
    service example:
      metadata:
        labels:
          app.kubernetes.io/component: backend
          app.kubernetes.io/instance: nginx
          app.kubernetes.io/name: hello-world
          app.kubernetes.io/part-of: nginx
          app.kubernetes.io/version: 1.16.0
    deployment example:
    metadata:
      labels:
        app.kubernetes.io/component: backend
        app.kubernetes.io/instance: nginx
        app.kubernetes.io/name: hello-world
        app.kubernetes.io/part-of: nginx
        app.kubernetes.io/version: 1.16.0
- add volumeMount readOnly type variable
- add conditionals for all services / deployments
- add tpl lookup for env variables
- add resources limitations in values.yaml