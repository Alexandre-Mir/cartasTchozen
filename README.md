# cartasTchozen

Um TCG em Godot para jogar com amigos, usando cartas inspiradas nas piadas internas do grupo. O objetivo é chegar a partidas justas, estratégicas e divertidas, com multiplayer hospedado localmente por um dos jogadores.

## Estado atual

O projeto é um protótipo de interface: mostra cartas carregadas de `data/cards/`, permite arrastá-las para o campo e desconta mana. O fluxo atual alterna entre um jogador e um turno simulado de inimigo. Ainda não há regras completas de combate, construção de baralho, condição de vitória ou rede multiplayer.

## Estrutura

- `scenes/game.tscn`: tabuleiro atual.
- `scenes/card.tscn` e `scripts/card.gd`: visual e interação de arrastar carta.
- `scripts/main.gd`: fluxo atual da partida e interface.
- `scripts/player_state.gd`: estado global provisório de mana e turno.
- `data/card_data.gd` e `data/cards/*.tres`: modelo e conteúdo das cartas.
- `data/card_database.gd`: carregamento das cartas.

Cada carta tem um `card_id` interno estável para identificar o recurso mesmo se o nome exibido mudar. O carregador valida IDs ausentes/repetidos e custos ou atributos negativos antes de indexar as cartas.

## Direção de desenvolvimento

As regras devem ficar separadas da interface e ser resolvidas de forma determinística. Para partidas em rede local, o host será a autoridade do estado da partida; os outros jogadores enviarão ações para validação. O balanceamento deve evoluir com regras explícitas, dados de cartas ajustáveis e partidas de teste reproduzíveis, sem sacrificar o humor e a identidade do grupo.

Consulte [AGENTS.md](AGENTS.md) para contexto e convenções de trabalho do projeto.

As regras confirmadas e as decisões pendentes estão em [docs/regras.md](docs/regras.md). Hearthstone e Magic são inspirações; o jogo não terá terrenos.

## MCP do Godot

O addon Godot MCP está em `addons/godot-mcp/` e habilitado em `project.godot`. Abra o projeto no Godot para iniciar a ponte do editor. O servidor MCP é configurado para o Codex neste repositório em `.codex/config.toml` e usa `npx`/Node.js para iniciar; pode ser necessário reiniciar a sessão do Codex depois da instalação.
