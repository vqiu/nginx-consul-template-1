{{ range services }} {{ if ne .Name "consul" }} {{ $service := service .Name }} {{ range $i, $s := service .Name }} {{ if eq $i 0 }} {{ $upstream := .NodeMeta.upstream }}
upstream {{ $upstream }} {
    zone {{ $upstream }} 64k;
    keepalive 32;
    {{ range $service }}
    server {{.Address}}:{{.Port}} max_fails=3 fail_timeout=10 weight=1;{{ end }}
}{{ end }}{{ end }}{{ end }}{{ end }}
