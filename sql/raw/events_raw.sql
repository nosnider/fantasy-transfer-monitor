CREATE OR REPLACE EXTERNAL TABLE `fantasy-transfer-monitor.analytics.events_raw`
  OPTIONS (
    format ="JSON",
    uris = ["gs://transfer-data-raw/events/*"]
    );
