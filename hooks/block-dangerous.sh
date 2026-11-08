#!/usr/bin/env bash
# Block force-pushes and direct pushes to main/master.
input=$(cat)
if echo "$input" | grep -Eq 'push.*(--force|-f( |$))|push origin (main|master)'; then
  echo '{"permission":"deny","userMessage":"Blocked: force or direct push to main."}'
else
  echo '{"permission":"allow"}'
fi
