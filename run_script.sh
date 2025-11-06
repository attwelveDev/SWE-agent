#!/usr/bin/env bash

docker run --rm -it --platform linux/amd64 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/aaronnguyen/Documents/Education/AustralianNationalUniversity/Year3/COMP3770/SWE-agent:/app \
  -v $(pwd)/keys.cfg:/app/keys.cfg \
  sweagent/swe-agent-run:latest \
  python run.py --image_name=sweagent/swe-ctf:latest \
  --model_name groq/llama4maverick \
  --ctf \
  --data_path Evaluation_Data/individual-call-chains/WxJava/WxJava_pu_0_vul_0_call_chain.json \
  --repo_path Evaluation_Data/client-apps/WxJava/weixin-java-mp \
  --config_file config/default_vulnerabilities.yaml \
  --per_instance_cost_limit 2.00 \
  --skip_existing=False