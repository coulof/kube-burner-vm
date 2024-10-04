#!/bin/bash
ITERATION=1
MAX_ITERATION=10
JOB="${JOB:-'vm-dvclone-density.yml'}"
while [ $ITERATION -le $MAX_ITERATION ]; do
  start_time=$(date +%s)
  echo "Iteration $ITERATION"
  PROM=https://$(oc get route -n openshift-monitoring prometheus-k8s -o jsonpath="{.spec.host}") \
  PROM_TOKEN=$(oc create token -n openshift-monitoring prometheus-k8s) \
  QPS=1000 BURST=1000 ITERATIONS=$ITERATION OBJ_REPLICAS=$ITERATION \
  kube-burner init  -c $JOB -e metrics-endpoint.yml
  
  mv collected-metrics collected-metrics-$ITERATION
  ITERATION=$((ITERATION+1))
  echo "Done iteration $ITERATION. Elapsed time: $(($(date +%s) - $start_time))s"
  sleep 1
done
