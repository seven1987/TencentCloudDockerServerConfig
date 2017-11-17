#!/bin/bash

set -xe

export REMOTE_HOST="root@123.206.175.60"
export REMOTE_ROOT="/home"
#(cd ${WORKSPACE}/devops/;chmod +x *.sh; ./test.sh)

SERVICE_NAME="ServerConfig"
TAR_NAME="${SERVICE_NAME}-${BUILD_ID}-`date +%y%m%d`"
TAR_GZ="${TAR_NAME}.tar.gz"

REMOTE_PATH="${REMOTE_ROOT}/jenkins_git"
cd ${WORKSPACE}
rm -rf *.tar.gz

echo $BUILD_ID>"../build_id.txt"
echo $GIT_COMMIT>"../git_commit.txt"

#find ../DnfData -name '*.sh'|xargs chmod +x
#find ../DnfData -name '*.sh' -or -name "Dockerfile"|xargs dos2unix

tar -czf ${TAR_GZ} -C  . \
    --exclude=.git* --exclude=.git \
    --exclude=*.tar.gz

(
    ssh ${REMOTE_HOST} sudo mkdir -p ${REMOTE_PATH}
    scp ${WORKSPACE}/${TAR_GZ} ${REMOTE_HOST}:/tmp/
    ssh ${REMOTE_HOST} sudo mv /tmp/${TAR_GZ} ${REMOTE_PATH}/
)
(ssh ${REMOTE_HOST} "cd ${REMOTE_PATH};
    sudo mkdir ${TAR_NAME};
    sudo tar xzf ${TAR_GZ}  -C ${TAR_NAME};
    if [ ! -d "$SERVICE_NAME"]; then
        sudo ln -s ${TAR_NAME} ${SERVICE_NAME};
        (cd ${SERVICE_NAME}/DnfData/mysql; sudo docker-compose down; sudo docker-compose up -d --build)
    else
        (cd ${SERVICE_NAME}/DnfData/mysql; sudo docker-compose down;)
        sudo rm -rf ${SERVICE_NAME};
        sudo ln -s ${TAR_NAME} ${SERVICE_NAME};
        (cd ${SERVICE_NAME}/DnfData/mysql; sudo docker-compose up -d --build)
    fi
    ")