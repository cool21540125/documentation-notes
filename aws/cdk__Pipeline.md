
# [CodePipeline](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.pipelines.CodePipeline.html)

- This is a Pipeline with its engine property set to CodePipelineEngine
- `synth: IFileSetProducer` (此為 CDK Cloud Assembly 的 build step (IFileSetProducer))
    - IFileSetProducer 的實作如下 (都會生成 cdk.out 資料夾):
        - ShellStep
        - CodeBuildStep
        - CodePipelineFileSet
        - ConfirmPermissionsBroadening
        - FileSet
        - ManualApprovalStep

```ts
// init
new CodePipeline(scope: Construct, id: string, props: CodePipelineProps);


// Case A : Original API (別鳥它)
const pp = new pipelines.CdkPipeline(this, 'Pipeline', {
  selfMutating: false,
  cloudAssemblyArtifact: ew codepipeline.Artifact()
});


// Case B : Modern API (用它就是了)
const pp = new pipelines.CodePipeline(this, 'Pipeline', {
  selfMutation: false,
  // example ShellStep
  synth: new pipelines.ShellStep('Synth', {
    input: CodePipelineSource.codeCommit(repository, "main"),
    installCommands: ["npm install -g aws-cdk"],
    commands: [ "npm ci", "npm run build" ],
  }),
  // example CodeBuildStep
  synth: new pipelines.CodeBuildStep(`Synth`, {
    input: CodePipelineSource.codeCommit(repository, "main"),
    installCommands: ["npm install -g aws-cdk"],
    commands: [ "npm ci", "npm run build" ],
  }),
});
```


# [CodePipelineProps](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.pipelines.CodePipelineProps.html)

```ts

```
