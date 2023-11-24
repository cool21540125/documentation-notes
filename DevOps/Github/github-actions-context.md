

Context 種類

- github context
    - 整個 workflow run
- env context
    - workflow 裡頭設定的 `env`
- vars context
    - Github Org, Repo, Env Level 設定的 variables
- runner context
- steps context
- jobs context
    - 只能用來給 reusable workflows, 並且只能用來給 reusable workflow 設定 outputs
- job context
    - currently running job 的 info
- secrets context
- strategy context
- matrix context
- needs context
    - `needs.<job_id>.result`
        - success
        - failure
        - cancelled
        - skipped
    `needs.<job_id>.outputs.<output name>`
        
- inputs context
