import os
import json

CURRENT_DIR_PATH = os.path.dirname(os.path.realpath(__file__))
OUTPUT_DIR_PATH = os.path.join(CURRENT_DIR_PATH, 'individual-call-chains')

client_projects_path = [
    "adu-test",
    "adyen-api",
    "archivefs",
    "axon-server-se/axonserver",
    "base-starter",
    "bean-query",
    "CarStoreApi/account/account-web",
    "commons-validator",
    "db/engine",
    "elasticsearch-maven-plugin",
    "flow",
    "geek-framework",
    "gerenciador-viagens",
    "huntfiles",
    "idworker",
    "jerry-core",
    "jfinal",
    "JsonConfiguration",
    "kafka-keyvalue",
    "karate/karate-core",
    "knetbuilder/ondex-base/core/marshal",
    "mirage/mirage-core",
    "Mixmicro-Components/llc-kits",
    "neo",
    "ninja/ninja-core",
    "OmegaTester",
    "Online_Train_Ticket_Reservation_System/Code",
    "PatentPublicData/Common",
    "pdf-converter",
    "pdf-util",
    "PLMCodeTemplate/source",
    "QLExpress",
    "reproducible-build-maven-plugin",
    "rike/arago-rike-commons",
    "roubsite/RoubSiteUtils",
    "rpki-commons",
    "RuoYi-Vue-Multi-Tenant/multi-tenant-server",
    "serritor",
    "son-editor/son-validate-web",
    "tcpser4j",
    "twirl",
    "ucloud-java-sdk",
    "UltraPlaytime",
    "wakatime-sync",
    "webbit",
    "weblaf/modules/core",
    "wechat-ssm",
    "WxJava/weixin-java-mp",
    "ZingClient"
]


def get_root_name(file_path: str):
    return file_path.split("/")[0]


def load_json(file_path):
    with open(file_path, "r") as f:
        return json.load(f)


def main():
    print(f"Total number of projects: {len(client_projects_path)}")
    print('Current dir path:', CURRENT_DIR_PATH)

    os.makedirs(OUTPUT_DIR_PATH, exist_ok=True)

    for project_path in client_projects_path:
        project_root_name = get_root_name(project_path)

        os.makedirs(os.path.join(OUTPUT_DIR_PATH, project_root_name), exist_ok=True)

        public_chain_list = load_json(os.path.join(CURRENT_DIR_PATH, "groundtruth", project_path, 'public-call-chains.json'))
        private_chain_list = load_json(os.path.join(CURRENT_DIR_PATH, "groundtruth", project_path, 'private-call-chains.json'))

        for chain_list in [public_chain_list, private_chain_list]:
            pu_pr_identifier = "pu" if chain_list == public_chain_list else "pr"

            for chain_idx, chain in enumerate(chain_list):
                call_chain = chain["chain"]

                for vul_idx, vul in enumerate(chain["vuls"]):
                    chain_data = {
                        "name": project_root_name,
                        "vul": vul,
                        "chain": call_chain
                    }

                    output_file_name = f"{project_root_name}_{pu_pr_identifier}_{chain_idx}_vul_{vul_idx}_call_chain.json"

                    with open(os.path.join(OUTPUT_DIR_PATH, project_root_name, output_file_name), "w") as f:
                        json.dump(chain_data, f, indent=4)


if __name__ == '__main__':
    main()
