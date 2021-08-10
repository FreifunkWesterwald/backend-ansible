#!/usr/bin/env sh

socat "TCP-LISTEN:$LISTEN_PORT,bind=$LISTEN_IP,max-children=$MAX_CHILDREN,fork" \
      EXEC:"sudo /usr/local/bin/wgkex_handler.sh"