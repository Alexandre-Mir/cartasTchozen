# Direção inicial das regras

Este documento separa decisões confirmadas de ideias que ainda precisam ser escolhidas. A meta é usar Hearthstone e Magic como referências de ritmo, variedade e decisões táticas, mantendo regras próprias para o grupo.

## Confirmado

- É um TCG para partidas multiplayer hospedadas localmente.
- As cartas usam piadas internas e referências do grupo.
- Hearthstone e Magic são inspirações para as regras.
- O jogo não terá terrenos.
- Balanceamento e satisfação das partidas são objetivos centrais.

## Direção em avaliação

Sem terrenos, a partida precisa de uma fonte de recurso que não dependa de comprar cartas de recurso. Uma opção simples para testar é aumentar o limite de mana automaticamente a cada turno até um teto e restaurar a mana disponível no início do turno. Isso reduz partidas travadas por compras ruins e torna os custos das cartas comparáveis. Ainda não é uma regra aprovada.

O modelo atual de cartas já comporta custos, criaturas com ataque/vida e feitiços, mas esses campos ainda não definem as regras de jogo. Efeitos escritos nas descrições também não são executados pelo protótipo.

## Decisões pendentes

- Mana: crescimento automático ou limite fixo; valor inicial, teto e momento de recarga.
- Baralho: tamanho, quantidade máxima de cópias e composição mínima.
- Compra: mão inicial, compra por turno, mulligan e limite de mão.
- Turno: ordem das fases e quem começa.
- Combate: quais permanentes podem atacar, quando ficam prontas, como o defensor escolhe bloqueadores e como dano é resolvido.
- Partida: vida inicial, condições de vitória e empate, e o que ocorre quando o baralho acaba.
- Efeitos: palavras-chave, duração, prioridades e ordem de resolução.
- Interação: ações permitidas fora do próprio turno e possibilidade de resposta do oponente.

## Princípios de implementação e balanceamento

- Definir cada regra com precisão suficiente para que host e clientes resolvam a mesma ação do mesmo jeito.
- O host valida ações e mantém o estado oficial da partida.
- Manter identidade de carta, custo, estatísticas e efeitos estruturados como dados, sem fazer a lógica depender do texto de ambientação.
- Mudar uma variável de balanceamento por vez e registrar a versão das regras usada em cada sessão de teste.
- Usar as referências como inspiração; nomes, textos e efeitos finais devem refletir o grupo e não exigir reproduzir cartas existentes.

## Mesa e compra confirmadas em 13/10/2026

- Cada participante começa com um deck de 60 cartas e uma mão de 7; limite de mão: 7.
- O deck fica com 53 cartas após a distribuição inicial.
- No início de cada turno, compra até 2 cartas, limitada pelas vagas na mão e pelas cartas restantes no deck. A distribuição inicial não recebe compra adicional.
- Jogador: cemitério à esquerda e deck à direita. Oponente: deck à esquerda e cemitério à direita da tela.
- Cartas nos campos dos dois participantes mostram as faces. Deck e cemitério mostram o verso; a mão do jogador local mostra faces e a mão adversária permanece oculta.
- O cemitério tem área e estado separados, mas ainda não existe regra de envio de cartas a ele.
- Deck vazio interrompe a compra; condição de vitória/derrota por esgotamento continua pendente.

### Limitações desta versão
O protótipo repete as definições disponíveis para preencher os decks de 60 e embaralha cada deck. Isto não estabelece um limite de cópias nem implementa construção de deck.
O turno adversário continua sendo uma espera automática; a compra adversária já respeita as mesmas regras, mas não há IA, combate ou multiplayer.
As faces usam as artes, a moldura Card.png e a fonte Beleren-Bold.ttf originais. O verso continua provisório, pois ainda não há um asset dedicado para ele.
