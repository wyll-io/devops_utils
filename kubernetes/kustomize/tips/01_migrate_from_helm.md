```
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm fetch \
--untar \
--untardir charts \
nginx-stable/nginx-ingress

helm template \
--output-dir base \
--namespace ingress \
--values values.yaml \
ingress-controller \
charts/nginx-ingress

mv base/nginx-ingress/templates/* base/nginx-ingress && rm -rf base/nginx-ingress/templates

cat <<EOF > base/nginx-ingress/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: ingress
EOF

cd base/nginx-ingress

kustomize create --autodetect

cd ../..

kubectl apply -k base/nginx-ingress

```