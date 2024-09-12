
# launch ts

- 2023Q3

```jsonc
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",            // 一律填寫 node
            "request": "launch",       // `launch` the code from scratch / `attach` to connect to launched code
            "name": "Debug gen i18n",  // 
            "skipFiles": [
                "<node_internals>/**"  // debugging process excluded files
            ],
            "program": "${workspaceFolder}/gen-googlesheet-i18n/index.ts",  // executable
            "preLaunchTask": "tsc: build - tsconfig.json",
            "console": "internalConsole",
            "outFiles": [
                "${workspaceFolder}/**/*.js"
            ]
        }
    ]
}
```