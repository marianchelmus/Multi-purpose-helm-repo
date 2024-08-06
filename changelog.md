# Changelog

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