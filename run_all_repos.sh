#!/usr/bin/env bash

# Exit if error
set -e

client_projects_path=(
  "adu-test"
  "adyen-api"
  "archivefs"
#  "bean-query"
  "CarStoreApi/account/account-web"
  "commons-validator"
  "elasticsearch-maven-plugin"
  "flow"
  "geek-framework"
  "gerenciador-viagens"
  "huntfiles"
  "idworker"
#  "jerry-core"
  "JsonConfiguration"
  "kafka-keyvalue"
  "karate/karate-core"
  "mirage/mirage-core"
  "Mixmicro-Components/llc-kits"
#  "neo"
  "ninja/ninja-core"
  "OmegaTester"
  "Online_Train_Ticket_Reservation_System/Code"
  "PatentPublicData/Common"
  "pdf-converter"
#  "pdf-util"
  "PLMCodeTemplate/source"
#  "QLExpress"  # issue with git
  "reproducible-build-maven-plugin"
  "RuoYi-Vue-Multi-Tenant/multi-tenant-server"
#  "tcpser4j"
  "twirl"
  "ucloud-java-sdk"
  "wakatime-sync"
  "WxJava/weixin-java-mp"
#  "webbit"
#  "weblaf/modules/core"
  "ZingClient"
#  "wechat-ssm"
  "base-starter"
)

#current_dir="$PWD"

# Track number of repositories
no_repos=0

for dir in "${client_projects_path[@]}" ; do
  repo_path="Evaluation_Data/client-apps/$dir"

  echo "RUNNING: $repo_path"

  no_repos=$((no_repos+1))

  no_call_chains=0
  client_project_root=$(echo "$dir" | cut -d "/" -f 1)
  call_chains_dir="Evaluation_Data/individual-call-chains/$client_project_root"
  if [ -d "$call_chains_dir" ]; then
    for data_path in "Evaluation_Data/individual-call-chains/$client_project_root"/*".json" ; do
      if [ -f "$data_path" ]; then
        no_call_chains=$((no_call_chains+1))

        echo "CALL_CHAIN: $data_path"

        docker run --rm -it --platform linux/amd64 \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v /Users/aaronnguyen/Documents/Education/AustralianNationalUniversity/Year3/COMP3770/SWE-agent:/app \
          -v $(pwd)/keys.cfg:/app/keys.cfg \
          sweagent/swe-agent-run:latest \
          python run.py --image_name=sweagent/swe-ctf:latest \
          --model_name grok-4-fast-reasoning \
          --ctf \
          --data_path "$data_path" \
          --repo_path "$repo_path" \
          --config_file config/default_vulnerabilities.yaml \
          --per_instance_cost_limit 2.00 \
          --skip_existing=True
      fi
    done
  fi

  echo "Number of call chains: $no_call_chains"
done

# Sanity check
echo "Number of repositories: $no_repos"

echo "FINISHED RUNNING ALL REPOSITORIES"