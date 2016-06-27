#!/bin/sh

error() {
  echo "error:invalid arguments"
  echo "usage)"
  echo "$ ./this_file update dir_of_Dockerfile zip_version [tag names...] "
  exit 1
}

case "$1" in
  update)

    if [ -n "$2" ] && [ ! -e "$2" ]; then
      error
    fi

    echo "replacing Dockerfile..."
    sed -i -e "s/ENV FESS_VERSION=.*/ENV FESS_VERSION=$3/" ${2}Dockerfile > /dev/null 2>&1
    echo "done."


    TAG=codelibs/fess:$4
    echo "building image $TAG from ${2}Dockerfile..."
    docker build --rm -t $TAG $2 > /dev/null 2>&1
    echo "done."
    echo "pushing $TAG..."
    docker push $TAG > /dev/null 2>&1
    echo "done."

    while [ "$5" != "" ]
    do
      echo "set tag from $TAG to codelibs/fess:$5"
      docker tag $TAG codelibs/fess:$5 > /dev/null 2>&1
      echo "done."
      echo "pushing codelibs/fess:$5"
      docker push codelibs/fess:$5 > /dev/null 2>&1
      echo "done."
      shift
    done
    echo "finish!"

    ;;
  push)
    while [ "$2" != "" ]
    do
      echo "pushing codelibs/fess:$2..."
      docker push codelibs/fess:$2 > /dev/null 2>&1
      echo "done!"
      shift
    done
    ;;
  *)
    error
    ;;
esac
