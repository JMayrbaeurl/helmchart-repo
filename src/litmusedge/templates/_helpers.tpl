{{/*
Expand the name of the chart.
*/}}
{{- define "litmusedge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "litmusedge.mds.name" -}}
{{- default .Chart.Name .Values.litmusEdgeSolutions.mds.mdsNameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "litmusedge.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
{{- define "litmusedge.mds.fullname" -}}
{{- if .Values.litmusEdgeSolutions.mds.mdsFullnameOverride }}
{{- .Values.litmusEdgeSolutions.mds.mdsFullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.litmusEdgeSolutions.mds.mdsNameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "litmusedge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "litmusedge.labels" -}}
helm.sh/chart: {{ include "litmusedge.chart" . }}
{{ include "litmusedge.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- define "litmusedge.mds.labels" -}}
helm.sh/chart: {{ include "litmusedge.chart" . }}
{{ include "litmusedge.mds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "litmusedge.selectorLabels" -}}
app.kubernetes.io/name: {{ include "litmusedge.name" . }}
app.kubernetes.io/instance: {{ include "litmusedge.name" . }}-instance
{{- end }}
{{- define "litmusedge.mds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "litmusedge.mds.name" . }}
app.kubernetes.io/instance: {{ include "litmusedge.mds.name" . }}-instance
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "litmusedge.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "litmusedge.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}