#!/bin/sh
for key in $GIT_SERV_PATH/root/*; do
  su git -c "gitosis-init < $key"
  chmod 755 $GIT_SERV_PATH/repos/gitosis-admin.git/hooks/post-update
  break
done

/usr/sbin/sshd -D
