# fantasy-transfer-monitor

## Objective
Data pipeline to ETL fantasy data into object storage. Data will be used to monitor player transfers, identify trends in transfer behavior, etc.
Deployed on gcs with the arcticture below:

## Architecture
1) Cloud Scheduler job runs each day at 6:00 AM EST and initiates a Cloud Function via HTTP
2) Cloud Function queries the Preimer League Fantasy API at https://fantasy.premierleague.com/api/bootstrap-static/
3) Extracts data and stores a daily snapshot of the json, partitioned daily in cloud storage.
4) Event is triggered from Cloud Storage upload finalization to transform recent data and load into a fact table (also in cloud storage)

CI/CD using github actions to artifact registry.

![Blank diagram](https://github.com/nosnider/fantasy-transfer-monitor/assets/41028285/536d43aa-a0a9-491e-ade1-b93f1b321985)
