#!/usr/bin/env bash

# Exit if error
set -e

#error_repos=()

client_projects_path=("adu-test"
  "adyen-api"
  "archivefs"
#  "axon-server-se/axonserver"
  "bean-query"
  "CarStoreApi/account/account-web"
  "commons-validator"
#  "db/engine"
  "elasticsearch-maven-plugin"
  "flow"
  "geek-framework"
  "gerenciador-viagens"
  "huntfiles"
  "idworker"
  "jerry-core"
#  "jfinal"
  "JsonConfiguration"
  "kafka-keyvalue"
  "karate/karate-core"
#  "knetbuilder/ondex-base/core/marshal"
  "mirage/mirage-core"
  "Mixmicro-Components/llc-kits"
  "neo"
  "ninja/ninja-core"
  "OmegaTester"
  "Online_Train_Ticket_Reservation_System/Code"
  "PatentPublicData/Common"
  "pdf-converter"
  "pdf-util"
  "PLMCodeTemplate/source"
  "QLExpress"
  "reproducible-build-maven-plugin"
#  "rike/arago-rike-commons"
#  "roubsite/RoubSiteUtils"
#  "rpki-commons"
  "RuoYi-Vue-Multi-Tenant/multi-tenant-server"
#  "serritor"
#  "son-editor/son-validate-web"
  "tcpser4j"
  "twirl"
  "ucloud-java-sdk"
#  "UltraPlaytime"
  "wakatime-sync"
  "WxJava/weixin-java-mp"
  "webbit"
  "weblaf/modules/core"
  "ZingClient"
  "wechat-ssm"
  "base-starter"
)

current_dir="$PWD"

# Track number of repositories
no_repos=0

# For Maven build, use JDK 8, other versions may not work
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

for dir in "${client_projects_path[@]}" ; do
  project_dir="$current_dir/$dir"

  echo "INITIALISING: $project_dir"

  no_repos=$((no_repos+1))

  pushd "$project_dir" > /dev/null

  # Initialise git if not already done
  if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit"
  fi

  # Get all Maven dependencies, if fail, try offline
  mvn clean install -DskipTests || mvn -o clean install -DskipTests
#  if ! (mvn clean install -DskipTests || mvn -o clean install -DskipTests); then
#    error_repos+=("$project_dir")
#  fi

  popd > /dev/null

  # Copy linting jar into repository
  cp jd-cli.jar "$project_dir"
done

# Sanity check
echo "Number of repositories: $no_repos"

#echo "Repositories with errors:"
#echo "${error_repos[@]}"

echo "FINISHED INITIALISING ALL REPOSITORIES"