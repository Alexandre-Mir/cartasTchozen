# Execução — plano 2026-10-14-combate.md

Base: 3c8f803, branch codex/melhorias-tcg limpo. Regras esclarecidas diretamente com o usuário; implementação inline.

Estado, identidade de cópias, declaração/defesa/resolução, apresentação 3D, seleção por viewport, IA e feitiços: concluídos.

Convenção local: AGENTS.md proíbe suítes de testes sem pedido explícito. Não criadas nem executadas; verificação feita com importação, execução e prévias temporárias do Godot.

Importação detectou uma inferência inválida em Main.blocked, corrigida para bool explícito. Execuções seguintes terminaram com exit 0 e sem erros de runtime. O editor avisou Safe save failed para suas configurações no ambiente restrito; importação de scripts/UIDs concluiu.

Prévia de combate executada em OpenGL e D3D12 Forward+: carta recém-entrada não atacou; no próximo turno atacou; cópias com mesma definição receberam IDs distintos. Cliques reais enviados ao viewport declararam três ataques. Ataque 5 derrotou uma defensora com vida 3, protegendo o alvo original; ataque 3 contra vida 3 preservou a carta; ataque direto reduziu vida 100→97. Uma fase adicional foi recusada. Ataque adversário aguardou defesa local, uma defensora sobreviveu, e o turno local retornou. Feitiço gastou mana 3→2, não entrou no campo e terminou no cemitério com aviso de efeito pendente.

Revisão independente somente leitura: nenhum achado crítico/importante. Observação menor sobre fim de partida após todos os ataques: esclarecido na spec que o conjunto confirmado resolve por completo, sem liberar novas interações, antes do encerramento por vida zero. Não há segunda rodada de combate depois da vitória.

Capturas de seleção, defesa e resultado conferidas; a mensagem central foi afastada da borda das cartas. Seleção de defesa pendente deve ser associada ou cancelada antes da confirmação. Fluxo normal de três turnos conferido separadamente para a entrada de cartas da IA, a oportunidade de defesa e o retorno local.

Sem push ou merge externo. Efeitos específicos e networking continuam pendentes.