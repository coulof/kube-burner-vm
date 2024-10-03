#!/bin/bash
ITERATION=1


while [ $ITERATION -le 10 ]; do
  echo "Iteration $ITERATION"
  PROM=https://$(oc get route -n openshift-monitoring prometheus-k8s -o jsonpath="{.spec.host}") PROM_TOKEN=$(oc create token -n openshift-monitoring prometheus-k8s) QPS=1000 BURST=1000 ITERATIONS=$ITERATION OBJ_REPLICAS=$ITERATION kube-burner init  -c vm-dvclone-density.yml -e metrics-endpoint.yml
  mv collected-metrics collected-metrics-$ITERATION
  ITERATION=$((ITERATION+1))
  sleep 1
done
