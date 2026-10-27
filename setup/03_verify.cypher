MATCH (n) RETURN labels(n)[0] AS label, count(*) AS count;
MATCH (n)-[r]->(m) RETURN n, r, m;
SHOW INDEXES YIELD name, type, state WHERE type = 'VECTOR';
