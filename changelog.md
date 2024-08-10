# Changelog

## 6th of August update

- **Remove frontend deployment/service**

- **Integrate secrets deployment**
  - two new secrets will be created - one that will be placed in env. vars and will be read when requesting backend and one for image secret used for backend deployment

- **Liveness / Readiness TCP probe**
  ```yaml
  livenessProbe:
    tcpSocket:
      port: {{ .Values.redisDeployment.containerPort }}
    initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds | default 30 }}
    periodSeconds: {{ .Values.probes.liveness.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.probes.liveness.timeoutSeconds | default 5 }}
    failureThreshold: {{ .Values.probes.liveness.failureThreshold | default 3 }}
  readinessProbe:
    tcpSocket:
      port: {{ .Values.redisDeployment.containerPort }}
    initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds | default 30 }}
    periodSeconds: {{ .Values.probes.readiness.periodSeconds | default 10 }}
    timeoutSeconds: {{ .Values.probes.readiness.timeoutSeconds | default 5 }}
    failureThreshold: {{ .Values.probes.readiness.failureThreshold | default 3 }}  
  ```

- **Change naming convension for all resources**
  ```bash
  root@mini-kube:~# kubectl get pods -n micisor
  NAME                                     READY   STATUS    RESTARTS   AGE
  micisor-dorna-backend-5dccd85d66-2rdnp   1/1     Running   0          6m58s
  micisor-dorna-redis-869dbcc597-qp4l8     1/1     Running   0          6m58s
  root@mini-kube:~# kubectl get svc -n micisor
  NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
  micisor-dorna-backend   NodePort    10.97.82.36     <none>        5000:32705/TCP   7m12s
  micisor-dorna-redis     ClusterIP   10.106.193.81   <none>        6379/TCP         7m11s
  root@mini-kube:~# kubectl get deployments -n micisor
  NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
  micisor-dorna-backend   1/1     1            1           7m14s
  micisor-dorna-redis     1/1     1            1           7m14s  
  ```
  - name is formed of {{environment}}-{{release-name}}-backend/redis-hash
    - environment is taken from values.yaml
    - release name is taken from helm chart deployment (this is the value available in instance in this label app.kubernetes.io/instance=dorna)
    - backend/redis are hardcoded values for the each deployment/service/configmap

- **Add redis config map and set command to load config file**

- **Add more conditionals, e.g. redisDeployment.configMap.enabled (default true)**
  - this conditional changes the way how redis is started, if volume is mounted, etc.

## 4th of August update

- **Removed Hardcoded Values:**
  - All hardcoded values have been removed from configurations.

- **Fixed Labels for All Services/Deployments:**
  - **Service Example:**
    ```yaml
    metadata:
      labels:
        app.kubernetes.io/component: backend
        app.kubernetes.io/instance: nginx
        app.kubernetes.io/name: hello-world
        app.kubernetes.io/part-of: nginx
        app.kubernetes.io/version: 1.16.0
    ```
  - **Deployment Example:**
    ```yaml
    metadata:
      labels:
        app.kubernetes.io/component: backend
        app.kubernetes.io/instance: nginx
        app.kubernetes.io/name: hello-world
        app.kubernetes.io/part-of: nginx
        app.kubernetes.io/version: 1.16.0
    ```

- **Added VolumeMount ReadOnly Type Variable:**
  - Added the `readOnly` field to `volumeMounts`:
    ```yaml
    volumeMounts:
      - name: {{ include "hello-world-nginx.fullname" . }}-{{ .Values.frontendDeployment.htmlVolume.name }}
        mountPath: {{ .Values.frontendDeployment.htmlVolume.mountPath }}
        readOnly: {{ .Values.frontendDeployment.htmlVolume.readOnly }}
    ```

- **Added Conditionals for All Services/Deployments:**
  - Implemented conditionals to handle different configurations.

- **Added `tpl` Lookup for Environment Variables:**
  - Used `tpl` to dynamically look up environment variables:
    ```yaml
    env:
      {{- range .Values.envVariables }}
      - name: {{ .name }}
        value: {{ tpl .value $ | quote }}
      {{- end }}
    ```

- **Added Resource Limitations in `values.yaml`:**
  - Added resource constraints to `values.yaml`:
    ```yaml
    resources:
      limits:
        cpu: {{ .Values.resources.limits.cpu }}
        memory: {{ .Values.resources.limits.memory }}
      requests:
        cpu: {{ .Values.resources.requests.cpu }}
        memory: {{ .Values.resources.requests.memory }}
    ```

    ```yaml
    resources:
      requests:
        cpu: "{{ .Values.resources.requests.cpu }}"
        memory: "{{ .Values.resources.requests.memory }}"        
      limits:
        cpu: "{{ .Values.resources.limits.cpu }}"
        memory: "{{ .Values.resources.limits.memory }}"
    ```