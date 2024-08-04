{{/*
Expand the name of the chart.
*/}}
{{- define "hello-world-nginx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hello-world-nginx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- printf "%s-%s" .Values.environment .Release.Name  | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .Values.environment .Release.Name $name  | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hello-world-nginx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hello-world-nginx.labels" -}}
{{ include "hello-world-nginx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/part-of: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hello-world-nginx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-world-nginx.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hello-world-nginx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hello-world-nginx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}