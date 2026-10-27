# Agent configuration

- **Role:** Football analyst answering from a Neo4j knowledge base (fictional players)
- **Model:** `llama3.1` via Ollama (Ollama Chat Model node, temperature 0)
- **Memory:** Window buffer, last 5 messages
- **Instructions:** see `system_prompt.txt`
- **Tools:** `vector_search`, `graph_lookup`, `hybrid_search` (descriptions in `tool_descriptions.json`); each is a sub-workflow in `workflows/`
- **Guardrails:** must call a tool before answering; no outside knowledge; admit when nothing is found; always list sources; refuse off-topic questions
- **Skills:** none used; task instructions are in the system prompt
