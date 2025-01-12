#!/usr/bin/env bash

# requires curl & jq

# upstreamCommit <baseHash> <newHash>
# param: bashHash - the commit hash to use for comparing commits (baseHash...newHash)
# param: newHash - the commit hash to use for comparing commits

(
set -e
PS1="$"

paper=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/CDAGaming/Paper/compare/$1...$2 | jq -r '.commits[] | "CDAGaming/Paper@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')

updated=""
logsuffix=""
if [ ! -z "paper" ]; then
    logsuffix="$logsuffix\n\nPaper Changes:\n$paper"
    updated="Paper"
fi
disclaimer="Upstream has released updates that appear to apply and compile correctly"

log="${UP_LOG_PREFIX}Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -

) || exit 1
