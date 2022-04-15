{{- define "k8s-rocker.container" }}
{{- /*
containers:
  'name':
    image:
    tag:
    policy: 'IfNotPresent'
    command: # startup command
    args: # startup args
    ports:
      'name':
        port:
        target:
        protocol: 'TCP'
    env:
      'name': # if raw is specified, mount valuefrom etc
        raw: {}
    health: # healthchecks
    mounts: # mounts
      volumes:
        'name':
          path:
      secrets:
      env: # TODO
      configmaps:
    affinity: # passed raw into the affinity block
*/}}
{{- $ := index . 0 }}
{{- $name:= index . 1 }}
{{- $container:= index . 2 }}
image: {{ required "container.image is required" $container.image }}
tag: {{ required "container.tag is required" $container.tag }}
imagePullPolicy: {{default "IfNotPresent" $container.policy }}
{{- /*

---- comannd and args
*/}}
{{- with $container.command }}
command:
  {{- range . }}
  - {{ . | quote }}
  {{- end }}
{{- end }}
{{- with $container.args }}
args:
  {{- range . }}
  - {{ . | quote }}
  {{- end }}
{{- end }}
{{- /*

---- ports
*/}}
{{- with $container.ports }}
ports:
{{- range $name, $port := . }}
  - name: {{ $name }}
    containerPort: {{ required "port.port is required" $port.port }}
    protocol: {{ default "TCP" $port.protocol }}
  {{- end }}
{{- end }}
{{- /*

---- env
*/}}
{{- with $container.env }}
  {{- range $name, $env := . }}
  {{- if (kindIs "map" $env ) }}
  - name: {{ $name}}{{ $env | toYaml | nindent 4}}
  {{- else }}
  - name: {{ $name}}
    value: {{ required "env value is required" $env }}
  {{- end }} {{/* end of kindIs */}}
  {{- end }}
{{- end }}
{{- /*

TODO: health, mounts, affinity
*/}}
{{- end }}{{/* end of k8s-rocker.container */}}