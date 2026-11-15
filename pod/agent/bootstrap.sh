#!/bin/bash
# Set up the agent pod (run once after create, and again after a pod restart):
#   ssh root@IP -p PORT 'bash -s' < bootstrap.sh
set -eu
A=/workspace/agent
mkdir -p $A/logs
command -v tmux > /dev/null || { apt-get update -q > /dev/null && apt-get install -y -q tmux jq > /dev/null; }
if ! [ -x /root/.local/bin/claude ]; then curl -fsSL https://claude.ai/install.sh | bash > $A/logs/install.txt 2>&1; fi
# keys: Anthropic from the pod env (RunPod secret), RunPod account key from the volume
umask 077
{ tr '\0' '\n' < /proc/1/environ | grep -E '^ANTHROPIC_API_KEY=' | sed 's/^/export /'
  echo 'export PATH=/root/.local/bin:$PATH IS_SANDBOX=1 CLAUDE_CONFIG_DIR=/workspace/agent/.claude'
  echo 'export DISABLE_AUTOUPDATER=1'
} > /root/agent.env
grep -q ANTHROPIC_API_KEY /root/agent.env || { echo "no ANTHROPIC_API_KEY in pod env"; exit 1; }
grep -q agent.env /root/.bashrc || echo 'source /root/agent.env' >> /root/.bashrc
mkdir -p /root/.ssh && cp $A/.ssh_key /root/.ssh/runpod_ed25519 && chmod 600 /root/.ssh/runpod_ed25519
printf 'Host *\n  IdentityFile /root/.ssh/runpod_ed25519\n  StrictHostKeyChecking accept-new\n  ServerAliveInterval 60\n' > /root/.ssh/config
[ -d /root/repo ] || git clone -q $A/repo.bundle /root/repo
source /root/agent.env
claude --version
echo "ok"
