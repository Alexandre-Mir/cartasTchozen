# Execução — 2026-10-14-mesa-3d.md

Direção aprovada pelo usuário: mesa 3D de câmera fixa e interface 2D.
Decisão: execução inline, mantendo a autorização e as regras do protótipo.
Convenção local: não criar/rodar suítes de testes; usar execução, renderização e inspeção do Godot.
Estado inicial: branch limpo em 5e19a0b, sem alteração em arquivos de referência.
Interfaces: Board3D apresenta; Main valida regras; CardFaceCache apenas renderiza; CardZoom inspeciona dados.

## Resultado
- Mesa, câmera fixa, iluminação, decks físicos e cartas com faces renderizadas implementados; mãos/HUD continuam em 2D.
- Importação e execução verificadas no Godot 4.7.2. Renderizações OpenGL Compatibility e D3D12 Forward+ abriram sem erros de runtime.
- Prévia temporária executou distribuição inicial, uma jogada válida pelo controlador, retorno fora da mesa, clique direito pelo viewport, fechamento com Esc e passagem de turno. Retorno preservou 6 cartas e mana; novo turno terminou com 7 cartas, mana 3 e compra desbloqueada.
- Seleção de carta após redimensionar a janela retornou true. Capturas de campo e inspeção foram conferidas visualmente.
- Revisão independente somente leitura: nenhum achado crítico/importante. Ajuste menor aplicado: altura de seleção usa a transformação global da face, incluindo sua escala.
- Não foram criadas ou executadas suítes de testes, conforme AGENTS.md. Fluxo de soltura foi exercitado pelo controlador, sem automação do gesto físico completo de arraste.
- Cenário provisório, sem nova IA, combate ou regras. Sem push/merge externo.