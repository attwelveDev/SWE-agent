import os
import json

CURRENT_DIR_PATH = os.path.dirname(os.path.realpath(__file__))

def main():
    traj_dirs = os.path.join(CURRENT_DIR_PATH, 'root'
                             , 'groq'  # uncomment for Llama only
                             )

    num_trajs = 0
    total_cost_total = 0
    api_calls_total = 0
    last_actions = {}

    failed_edits_total = 0
    edits_total = 0

    for traj_parent in os.listdir(traj_dirs):
        # Get results for one model only
        if traj_parent.startswith('llama4maverick_'):  # Switch model names here; 'gpt4_', 'gpt4o_', 'DeepSeek-R1_', 'llama4maverick_'
            num_trajs_per_subdir = 0
            for file in os.listdir(os.path.join(traj_dirs, traj_parent)):
                if file.endswith('.traj'):
                    try:
                        with open(os.path.join(traj_dirs, traj_parent, file), 'r') as f:
                            traj = json.load(f)

                            num_trajs_per_subdir += 1
                            num_trajs += 1
                            total_cost_total += traj['info']['model_stats']['total_cost']
                            api_calls_total += traj['info']['model_stats']['api_calls']

                            last_action = traj['trajectory'][-1]['action']
                            # last_action = traj['info']['exit_status']

                            last_action = "submit\n" if last_action.endswith("submit\n") else last_action

                            if not last_action.endswith("submit\n"):
                                print(traj_parent)

                            if last_action not in last_actions:
                                last_actions[last_action] = 1
                            else:
                                last_actions[last_action] += 1

                            # Determine if action introduced syntax error
                            for action in traj['trajectory']:
                                if "action" in action.keys() and "observation" in action.keys():
                                    if action["action"].startswith("edit"):
                                        edits_total += 1

                                        if action["observation"].startswith(
                                            "Your proposed edit has introduced new syntax error(s)."):
                                            failed_edits_total += 1

                            # print(f"Total cost: {traj['info']['model_stats']['total_cost']}")
                            # print(f"API calls: {traj['info']['model_stats']['api_calls']}")

                    except Exception as e:
                        print(f"Error occurred for file {file}: {e}")

            # Print out call chains with not exactly one trajectory (likely 0)
            if num_trajs_per_subdir != 1:
                print(traj_parent, num_trajs_per_subdir)

    print("Total number of trajectories: ", num_trajs)
    print("Total cost average: ", total_cost_total / num_trajs)
    print("Total API calls: ", api_calls_total)
    print("API calls average: ", api_calls_total / num_trajs)
    print("Last actions stats: ", last_actions)
    print("Failed edits total: ", failed_edits_total)
    print("Edits total: ", edits_total)
    print("Rate of edits raising syntax errors: ", failed_edits_total / edits_total)

if __name__ == '__main__':
    main()