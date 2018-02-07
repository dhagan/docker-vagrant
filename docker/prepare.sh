USERNAME=$1
PASSWORD=$2

if [ -z "$USERNAME" ] ; then
  echo -e "Usage: ./prepare.sh USERNAME PASSWORD"
  exit 1
fi

if [ -z "$PASSWORD" ] ; then
  echo -e "Usage: ./prepare.sh USERNAME PASSWORD"
  exit 1
fi

USERNAME="${USERNAME//@/%40}"
PASSWORD="${PASSWORD//@/%40}"

clone() {
    PROJECT_NAME=$1
    NAME=$2
    BRANCH=$3

    if [ ! -d $NAME ]; then
        REPO="https://${USERNAME}:${PASSWORD}@bitbucket.org/halfaker/${PROJECT_NAME}.git"
        git clone -b $BRANCH $REPO $NAME
        pushd $NAME
        git config core.fileMode false
        popd
    else
        echo "$PROJECT_NAME already exists, skipping..."
    fi
}
npminstall() {
    NAME=$1
    FOLDER=$2
    IMAGE=$3
    pushd $NAME/$FOLDER

    echo "Running NPM in $NAME/$FOLDER..."

    if [ ! -d "node_modules/" ]; then
        docker run -v `pwd`:/var/app tas/ng npm install
    else
        echo "node_modules/ already exists for $NAME, skipping..."
    fi

    popd
}

mkdir -p ./workspace

pushd ./docker-ng
docker build . -t tas/ng
popd

pushd ./docker-node8
docker build . -t tas/n8
popd

pushd ./workspace > /dev/null
clone mccf_esb_reporting reporting master
clone mccf_va_fhir_server fhir master
clone mccf_tas_api tascore-api master
clone mccf_tas_relay tas-relay master
clone mccf_tas_core tascore-ui master
popd > /dev/null

cp Dockerfile.nginx ./workspace
cp Dockerfile.tascore-ui ./workspace/tascore-ui/Dockerfile
cp nginx.conf ./workspace

pushd ./workspace > /dev/null
npminstall tascore-api src n8
npminstall tas-relay src n8
npminstall tascore-ui . ng
popd > /dev/null
