CREATE OR REPLACE EXTERNAL TABLE `fantasy-transfer-monitor.analytics.elements`
  OPTIONS (
    format ="JSON",
    uris = ["gs://transfer-data-raw/elements/*"]
    );
