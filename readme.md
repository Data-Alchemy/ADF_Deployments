# Azure Data Factory (ADF) Deployment Pipeline using ADF CLI

This is a readme file explaining the pipeline for deploying Azure Data Factory (ADF) using the ADF CLI. The pipeline consists of 4 stages: Artifact collection,Dev , Test and Prod. The pipeline is triggered when there are applicable changes to the deployment artifacts, as determined by the `DEPLOY_ARTIFACTS` variable.

![solution][solution_diagram]
## Pipeline Structure

The pipeline is structured as follows:

### Stage: CollectArtifacts

This stage collects the deployment artifacts required for ADF deployment. It performs the following steps:

1. Checks out the source code repository.
2. Runs a script to collect and stage the deployment artifacts.
3. Publishes the artifacts to the pipeline for further stages to consume.

### Stage: Dev

This stage is responsible for deploying the ADF to the Dev environment. It depends on the CollectArtifacts stage and is only triggered if there are applicable changes to the deployment artifacts. It performs the following steps:

1. Downloads the deployment artifacts from the pipeline.
2. Replaces any environment variables to match Dev
3. Uses the Azure CLI task to deploy the ADF using the ADF CLI.
4. The ADF CLI deployment script is executed, passing the necessary parameters for deployment.

### Stage: Test

This stage is responsible for deploying the ADF to the Nonprod environment. It performs similar steps as the Dev stage:

1. Downloads the deployment artifacts from the pipeline.
2. Replaces any environment variables to match Dev
3. Uses the Azure CLI task to deploy the ADF using the ADF CLI.
4. The ADF CLI deployment script is executed, passing the necessary parameters for deployment.

### Stage: Prod

This stage is responsible for deploying the ADF to the Nonprod environment. It performs similar steps as the Non Prod stage:

1. Downloads the deployment artifacts from the pipeline.
2. Replaces any environment variables to match Dev
3. Uses the Azure CLI task to deploy the ADF using the ADF CLI.
4. The ADF CLI deployment script is executed, passing the necessary parameters for deployment.


## Prerequisites

Before running this pipeline, ensure that you have done the following :

1. In Azure Data Factory (ADF) created a feature branch ex: Feature/My_Change
2. Made changes to your feature branch
3. Created a pull request from feature branch to adf_publish to merge your changes and trigger the deployment

## Pipeline Variables

The following pipeline variables are required:

- `DEPLOY_ARTIFACTS`: Set to `0` if no applicable changes were made, otherwise set to `1` to trigger the deployment stages.
- `Dev_service_connection`: Azure Resource Manager service connection name for the Dev environment.
- `non_prod_service_connection`: Azure Resource Manager service connection name for the Nonprod environment.
- Other parameters specific to your ADF deployment, such as `SourceResourceGroupName`, `SourceDataFactoryName`, etc.



## Note

If your pipeline resources are not following standard naming convention ie: dev, test, prod for the resource you are targeting you will need to go to the deployment stop the current run of the pipeline and override the replacement parameters and deploy one stage at a time.

to track all branches you will need to run 

```
for branch in $(git branch -r | grep -v HEAD); do
  git branch --track ${branch##*/} $branch
done
```

Happy deploying!

[solution_diagram]:https://lucid.app/publicSegments/view/9096220c-cf05-4c07-957c-388e8a17089a/image.png