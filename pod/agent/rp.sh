#!/bin/bash
# RunPod helper for the pod agent (full account key in /workspace/agent/.rpkey).
#   rp.sh balance                      account balance and current spend/h
#   rp.sh pods                         id name status $/h for every pod
#   rp.sh get ID                       full pod JSON (ssh: .runtime.ports public 22 mapping)
#   rp.sh ssh ID                       prints "IP PORT" of the direct SSH mapping (empty if not up)
#   rp.sh gpu NAME [DISK_GB]           1x RTX 5090 Secure EU-RO-1 with the volume ($1.19/h)
#   rp.sh cpu NAME FLAVOR VCPU         CPU pod EU-RO-1 with the volume (cpu3g $0.04/vCPU-h, cpu3m $0.055, cpu5g $0.046)
#   rp.sh stop ID | delete ID
set -euo pipefail
K=$(cat /workspace/agent/.rpkey)
R=https://rest.runpod.io/v1
H=(-H "Authorization: Bearer $K" -H 'Content-Type: application/json')
VOL=0k8glcv6lz
PUB=$(cat /workspace/agent/ssh_pub 2>/dev/null || true)
IMG=runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404
case ${1:-} in
  balance) curl -s "${H[@]}" -d '{"query":"query { myself { clientBalance currentSpendPerHr } }"}' https://api.runpod.io/graphql; echo ;;
  pods) curl -s "${H[@]}" $R/pods | python3 -c 'import json,sys
for p in json.load(sys.stdin): print(p["id"], p.get("name"), p.get("desiredStatus"), p.get("costPerHr"))' ;;
  get) curl -s "${H[@]}" $R/pods/${2:?id}; echo ;;
  ssh) curl -s "${H[@]}" $R/pods/${2:?id} | python3 -c 'import json,sys
p=json.load(sys.stdin); m=(p.get("portMappings") or {}); ip=p.get("publicIp")
if ip and m.get("22"): print(ip, m["22"])' ;;
  gpu) body=$(python3 - "$2" "${3:-300}" "$IMG" "$VOL" "$PUB" <<'EOF'
import json,sys
import os
n,d,img,vol,pub=sys.argv[1:]
gt=os.environ.get("GPU_TYPE","NVIDIA GeForce RTX 5090")
print(json.dumps({"name":n,"imageName":img,"cloudType":"SECURE","computeType":"GPU",
 "gpuTypeIds":[gt],"gpuCount":1,"dataCenterIds":["EU-RO-1"],
 "networkVolumeId":vol,"volumeMountPath":"/workspace","containerDiskInGb":int(d),
 "ports":["22/tcp"],"env":{"PUBLIC_KEY":pub}}))
EOF
)
       curl -s "${H[@]}" -d "$body" $R/pods; echo ;;
  cpu) body=$(python3 - "$2" "$3" "$4" "$IMG" "$VOL" "$PUB" <<'EOF'
import json,sys
n,f,v,img,vol,pub=sys.argv[1:]
print(json.dumps({"name":n,"imageName":img,"cloudType":"SECURE","computeType":"CPU",
 "cpuFlavorIds":[f],"vcpuCount":int(v),"dataCenterIds":["EU-RO-1"],
 "networkVolumeId":vol,"volumeMountPath":"/workspace","containerDiskInGb":40,
 "ports":["22/tcp"],"env":{"PUBLIC_KEY":pub}}))
EOF
)
       curl -s "${H[@]}" -d "$body" $R/pods; echo ;;
  stop) curl -s -X POST "${H[@]}" $R/pods/${2:?id}/stop; echo ;;
  delete) curl -s -X DELETE "${H[@]}" $R/pods/${2:?id} -w "%{http_code}\n" ;;
  *) sed -n 2,10p "$0"; exit 1 ;;
esac
