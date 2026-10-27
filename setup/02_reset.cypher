// Wipes all data (keeps constraints and index). Run, then re-run the ingestion workflow.
MATCH (n) DETACH DELETE n;
