# Football analyst - hybrid RAG with Neo4j and n8n

## Case and agent role
Domain: football (10 fictional players, 4 clubs). Vectors answer "who plays like this?", the graph answers "who is connected to whom?". The agent is a football analyst that answers only from the knowledge base and cites its sources.

## How it fits together
```
players.json -> n8n ingestion -> Ollama (nomic-embed-text, 768 dim)
                              -> Neo4j: graph (Player, Club, Document) + vector index on Chunk
n8n chat -> Agent (llama3.1) -> tools: vector_search | graph_lookup | hybrid_search (sub-workflows -> Neo4j)
```

## Files
| What | Where |
|---|---|
| Data sample | `data/players.json` |
| Neo4j schema, reset, verify | `setup/*.cypher` |
| Docker setup | `docker-compose.yml` |
| Workflow JSON | `workflows/` (1 ingestion, 2-4 tools, 5 agent) |
| Agent prompt, model, tool descriptions | `agent/` |
| Example questions and assessment | `docs/example_questions.md` |
| Screenshots | `screenshots/` |

## Data model
- Nodes: `Player {name, position}`, `Club {name}`, `Chunk {id, text, embedding}`, `Document {name}`
- Relationships: `(Player)-[:PLAYS_FOR]->(Club)`, `(Player)-[:PREVIOUSLY_PLAYED_FOR]->(Club)`, `(Chunk)-[:DESCRIBES]->(Player)`, `(Chunk)-[:FROM_DOCUMENT]->(Document)`
- Index: vector index `playerChunks` on `Chunk.embedding` (768 dim, cosine)
- Chunking: one chunk per player description (already short and structured). Re-running ingestion is safe because `MERGE` on `Chunk.id` avoids duplicates.

## Setup
1. `ollama pull nomic-embed-text` and `ollama pull llama3.1` (Ollama runs on the host).
2. `docker compose up -d`
3. Open http://localhost:7474 (neo4j / password123) and run `setup/01_schema.cypher`.
4. Open http://localhost:5678, import the five files in `workflows/`.
5. In the agent workflow: select the matching sub-workflow in each of the three tools, and create an Ollama credential with base URL `http://host.docker.internal:11434`.
6. Run the ingestion workflow, then check with `setup/03_verify.cypher`.
7. Chat with the agent via the n8n chat.

## Extras implemented
Hybrid search (vector + graph in one Cypher query), source references in answers, n8n built-in chat interface.
Not implemented: evaluator agent, human-in-the-loop.

## Known limitations
No years in the data, so "shared a club" is not the same as "played together". Small local models sometimes call tools with wrong arguments.
