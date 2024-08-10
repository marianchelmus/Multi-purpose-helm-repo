# Generic App Helm Chart

## Overview

This Helm chart deploys a generic application along with optional Redis support on Kubernetes. The chart provides flexible configuration options to suit various environments and use cases.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.x+

## Installation

To install this Helm chart, use the following command:

```bash
helm install [RELEASE_NAME] ./path-to-your-chart
```

## Configuration

The chart can be customized using the values.yaml file. Below is a sample configuration with descriptions for each setting:

```yaml
    # Environment setting for your deployment
    environment: dev

    # Docker registry configuration for pulling images
    dockerConfigJson: <base64-encoded-docker-config-json>

    # ServiceMonitor settings for Prometheus
    serviceMonitor:
    name: service-monitor

    # Liveness and readiness probe configurations
    probes:
    liveness:
        initialDelaySeconds: 5
        periodSeconds: 10
        timeoutSeconds: 5
        failureThreshold: 3
    readiness:
        initialDelaySeconds: 5
        periodSeconds: 10
        timeoutSeconds: 5
        failureThreshold: 3

    # Secret settings for the application
    secret:
    name: super-secret
    key: password

    # Environment variables to be injected into the application
    envVariables:
    - name: APP_PORT
        value: "{{ .Values.appService.port }}"
    - name: SECRET_DECODED
        valueFrom: "secretKeyRef"

    # Resource requests and limits for the application
    resources:
    requests:
        cpu: "100m"
        memory: "256Mi"
    limits:
        cpu: "100m"
        memory: "256Mi"

    # Configuration for the main application service
    appService:
    enabled: true
    name: app
    port: 5000
    targetPort: 5000
    nodePort: 32701
    type: NodePort
    protocol: TCP
    loadBalancerIP: ""  # Leave empty to let MetalLB assign an IP

    # Configuration for the application deployment
    appDeployment:
    enabled: true
    name: app
    replicaCount: 1
    image:
        repository: registry.example.com
        name: generic-app-service
        tag: latest
    containerPort: 5000
    secretEnvName: env-secrets

    # Configuration for Redis deployment (optional)
    redisDeployment:
    enabled: true
    name: redis
    replicaCount: 1
    image:
        repository: redis
        tag: latest
    containerPort: 6379
    volumeMount:
        name: redis-config-volume
        mountPath: /usr/local/etc/redis/redis.conf
        subPath: redis.conf
        readOnly: true
    configMap:
        enabled: true
        name: redis-config

    # Configuration for Redis service (optional)
    redisService:
    enabled: true
    name: redis

    # Docker registry secret for pulling images
    imagePullSecret: regcred
```

## Notes

- Docker Configuration: Ensure that the dockerConfigJson value is base64-encoded.
- Secret Management: The chart uses Kubernetes secrets for sensitive information. Ensure secrets are created or configured properly.
- Redis Configuration: Redis deployment and service are optional. Set redisDeployment.enabled and redisService.enabled to true to enable Redis.

## Uninstallation

To uninstall the chart, use the following command:

```bash
helm uninstall [RELEASE_NAME]
```

Replace [RELEASE_NAME] with the name of your Helm release.