# Project guide

## Goal

This repository contains a Godot trading card game for a small friend group. The card names, art, and effects can use the group's inside jokes. The main product goals are fair, well-tested balance and satisfying matches. Multiplayer is hosted locally by one player so others can join over the local network.

## Current project shape

- Godot project, currently configured for Godot 4.7; `project.godot` starts `scenes/game.tscn`.
- `data/card_data.gd` defines the card resource and `data/cards/*.tres` holds card entries.
- `data/card_database.gd` loads the card resources.
- `scripts/main.gd` owns the current single-screen match and drag/drop flow.
- `scripts/player_state.gd` is currently a global singleton with one player's mana and a PLAYER/ENEMY turn enum.
- `scripts/card.gd` handles card visuals and mouse dragging.
- `scenes/game.tscn` is the current board UI.

## Engineering direction

- Keep rules and match state separate from UI so the same rules can run for host and clients.
- Treat the host as the authority for match state. Clients request actions; they do not decide or overwrite authoritative state.
- Design multiplayer for a locally hosted match (host plus LAN joiners), with a clear path to a host-only hot-seat/local mode if useful during development.
- Keep card definitions data-driven. Make costs, stats, keywords, and effects inspectable and tuneable without scattering card-specific balance values through UI code.
- Prefer small, testable rule functions and deterministic resolution. Record enough match/action information to reproduce balance issues.
- Avoid inventing final game rules or card balance values without grounding them in an agreed ruleset and playtesting.
- Hearthstone and Magic are inspirations for the rules, but the game has no land mechanic. Keep confirmed rules and proposals distinct in `docs/regras.md`; do not copy existing card designs as-is.
- Preserve the Portuguese language and the personal, humorous card identity where the project already uses them.
- Before changing existing behavior, inspect the relevant scenes/resources and keep changes consistent with the current Godot version and project structure.

## Current prototype limitations

- The current turn flow models one player followed by an automated enemy delay; it is not multiplayer yet.
- `PlayerState` is a singleton, so it cannot represent multiple independent players.
- Cards can be dragged to the player's field and spend mana, but combat, health, deck construction, win conditions, and authoritative networking are not implemented in the inspected prototype.
- The card database loads `.tres` resources from `data/cards/`.

## Working conventions

- Keep project documentation current when architecture or rules change.
- Do not add dependencies unless they solve a concrete need.
- Do not run tests or add test suites unless the user asks for verification/testing.
