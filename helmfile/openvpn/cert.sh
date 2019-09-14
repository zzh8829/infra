#!/bin/bash

# Check Initialization Status

POD_NAME=$(kubectl get pods -l type=openvpn -o jsonpath='{ .items[0].metadata.name }') && kubectl logs $POD_NAME --follow

# Generate Client Profile

KEY_NAME=${1:-KubeVPN-razerbook}
POD_NAME=$(kubectl get pods --namespace default -l type=openvpn -o jsonpath='{ .items[0].metadata.name }')
SERVICE_NAME=$(kubectl get svc --namespace default -l type=openvpn  -o jsonpath='{ .items[0].metadata.name }')
SERVICE_IP='openvpn.zihao.me'
kubectl --namespace default exec -it $POD_NAME /etc/openvpn/setup/newClientCert.sh $KEY_NAME $SERVICE_IP
kubectl --namespace default exec -it $POD_NAME cat /etc/openvpn/certs/pki/$KEY_NAME.ovpn > $KEY_NAME.ovpn
