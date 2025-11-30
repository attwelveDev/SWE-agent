# Summary of Changes

* `Evaluation_Data`
  * Contains repositories from Magneto
  * `client_apps`
    * `init_repo.sh`; in all repositories,
      * Initialise git
      * Build Maven to install dependencies 
      * Copy in linting jar `jd-cli.jar`
  * `individual-call-chains`
    * Individual `.json` files for all call chains for each repository
  * `create_call_chain_json_files.py`
    * Create individual call chains into `individual-call-chains` from all the repositories
* `trajectories`
  * `root`
    * All runs for all 4 LLMs (DeepSeek-R1, gpt4, gpt4o, groq/llama4maverick)
    * `analyse_stats.py`
      * Get stats for all call chains of a single LLM (specified in the script)
* `config`
  * `commands`; new/edited commands:
    * `debug_java.sh`
    * `decompile.sh`
    * `edit_linting.sh`
* `run_all_repos.sh`
  * Run all repos for a single LLM