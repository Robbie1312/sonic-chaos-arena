#!/bin/bash
# Sonic Chaos Arena - Mac launcher. Starts a tiny local web server (so the game's recorder works) and opens the game.
# Leave this window open while you play; close it to stop the server.
cd "$(dirname "$0")"
PORT=8765
GAME="sonic-chaos-arena.html"
if /usr/bin/python3 -c "" >/dev/null 2>&1; then
  /usr/bin/python3 -m http.server $PORT --bind 127.0.0.1 >/dev/null 2>&1 &
  SERVER=$!
  trap "kill $SERVER 2>/dev/null" EXIT
  sleep 1
  open -a "Google Chrome" "http://localhost:$PORT/$GAME" 2>/dev/null || open "http://localhost:$PORT/$GAME"
  echo "Sonic Chaos Arena is running at http://localhost:$PORT/$GAME"
  echo "Keep this window open while you play. Close it when you're done."
  wait $SERVER
else
  # no Python: just open the game file directly (everything works except the Shift + R recorder)
  open -a "Google Chrome" "$GAME" 2>/dev/null || open "$GAME"
fi
