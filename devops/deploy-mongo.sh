#!/bin/bash

set -xe

#export REMOTE_HOST="root@123.206.175.60"
#export REMOTE_ROOT="/home/dnf"
#(cd ${WORKSPACE}/devops/;chmod +x *.sh; ./deploy-mongo.sh)

SERVICE_NAME="mongo"
RELATIVE_PATH="/dnf/mongo"
TAR_NAME="${SERVICE_NAME}-${BUILD_ID}-`date +%y%m%d`"
TAR_GZ="${TAR_NAME}.tar.gz"

REMOTE_PATH="${REMOTE_ROOT}"
cd ${WORKSPACE}/devops
rm -rf *.tar.gz

echo $BUILD_ID>"../build_id.txt"
echo $GIT_COMMIT>"../git_commit.txt"

#find ../dnf -name '*.sh'|xargs chmod +x
#find ../dnf -name '*.sh' -or -name "Dockerfile"|xargs dos2unix


if [ $rebuild == true ]; then
    tar -czf ${TAR_GZ} -C .. . \
        --exclude=.git* --exclude=.git \
        --exclude=devops/.git \
        --exclude=devops/*.tar.gz

    (
        ssh ${REMOTE_HOST} sudo mkdir -p ${REMOTE_PATH}
        scp ${WORKSPACE}/devops/${TAR_GZ} ${REMOTE_HOST}:/tmp/
        ssh ${REMOTE_HOST} sudo mv /tmp/${TAR_GZ} ${REMOTE_PATH}/
    )
    (ssh ${REMOTE_HOST} "cd ${REMOTE_PATH};
        sudo mkdir ${TAR_NAME};
        sudo tar xzf ${TAR_GZ}  -C ${TAR_NAME};
        if [ ! -d "$SERVICE_NAME" ]; then
            sudo ln -s ${TAR_NAME} ${SERVICE_NAME};
            (cd ${SERVICE_NAME}${RELATIVE_PATH}; mkdir db; sudo docker-compose down; sudo docker-compose up -d --build)
        else
            (cd ${SERVICE_NAME}${RELATIVE_PATH}; sudo docker-compose down;)
            sudo rm -rf ${SERVICE_NAME};
            sudo ln -s ${TAR_NAME} ${SERVICE_NAME};
            (cd ${SERVICE_NAME}${RELATIVE_PATH}; sudo docker-compose up -d --build)
        fi
        ")
else
	(ssh ${REMOTE_HOST} "cd ${REMOTE_PATH};
      (cd ${SERVICE_NAME}${RELATIVE_PATH}; ls)
            (sudo docker restart dnf_mongo_1);
     ")
fi