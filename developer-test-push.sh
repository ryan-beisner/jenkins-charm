#!/bin/bash -uex
# Push a build to a personal cs namespace and make it available

CHARM_NAME="$(awk '/^name:/ { print $2 }' < metadata.yaml)"
CS_INDIVIDUAL="$(charm whoami | awk '/^User:/{ print $2 }')"
CHARM_REF="$(charm push build/builds/$CHARM_NAME cs:~$CS_INDIVIDUAL/$CHARM_NAME | awk '/url:/{ print $2 }')"
ORIGIN="$(git remote get-url origin)"

stat build/builds/$CHARM_NAME
charm release $CHARM_REF
charm grant $CHARM_REF --acl read everyone
charm set $CHARM_REF bugs-url=$ORIGIN \
                     homepage=$ORIGIN

# Example output:
#  rbeisner@rby:~/git/jenkins-charm⟫ ./dev-push.sh
#  ++ awk '/^name:/ { print $2 }'
#  + CHARM_NAME=jenkins
#  ++ charm whoami
#  ++ awk '/^User:/{ print $2 }'
#  + CS_INDIVIDUAL=1chb1n
#  ++ charm push build/builds/jenkins 'cs:~1chb1n/jenkins'
#  ++ awk '/url:/{ print $2 }'
#  + CHARM_REF='cs:~1chb1n/jenkins-3'
#  ++ git remote get-url origin
#  + ORIGIN=https://github.com/ryan-beisner/jenkins-charm
#  + stat build/builds/jenkins
#    File: build/builds/jenkins
#    Size: 4096            Blocks: 8          IO Block: 4096   directory
#  Device: 3dh/61d Inode: 14288095    Links: 10
#  Access: (0755/drwxr-xr-x)  Uid: ( 1000/rbeisner)   Gid: ( 1000/rbeisner)
#  Access: 2017-04-12 15:41:44.715264467 -0500
#  Modify: 2017-04-12 15:41:44.695264356 -0500
#  Change: 2017-04-12 15:41:44.695264356 -0500
#   Birth: -
#  + charm release 'cs:~1chb1n/jenkins-3'
#  url: cs:~1chb1n/jenkins-3
#  channel: stable
#  + charm grant 'cs:~1chb1n/jenkins-3' --acl read everyone
#  + charm set 'cs:~1chb1n/jenkins-3' bugs-url=https://github.com/ryan-beisner/jenkins-charm homepage=https://github.com/ryan-beisner/jenkins-charm

