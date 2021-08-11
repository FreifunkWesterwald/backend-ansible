#!/usr/bin/env sh

socat "TCP6-LISTEN:$LISTEN_PORT,max-children=$MAX_CHILDREN,fork" \
      EXEC:"sudo /usr/local/bin/wgkex_handler.sh"