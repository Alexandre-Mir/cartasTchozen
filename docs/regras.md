# Dire��o inicial das regras

Este documento separa decis�es confirmadas de ideias que ainda precisam ser escolhidas. A meta � usar Hearthstone e Magic como refer�ncias de ritmo, variedade e decis�es t�ticas, mantendo regras pr�prias para o grupo.

## Confirmado

- � um TCG para partidas multiplayer hospedadas localmente.
- As cartas usam piadas internas e refer�ncias do grupo.
- Hearthstone e Magic s�o inspira��es para as regras.
- O jogo n�o ter� terrenos.
- Balanceamento e satisfa��o das partidas s�o objetivos centrais.

## Dire��o em avalia��o

Sem terrenos, a partida precisa de uma fonte de recurso que n�o dependa de comprar cartas de recurso. Uma op��o simples para testar � aumentar o limite de mana automaticamente a cada turno at� um teto e restaurar a mana dispon�vel no in�cio do turno. Isso reduz partidas travadas por compras ruins e torna os custos das cartas compar�veis. Ainda n�o � uma regra aprovada.

O modelo atual de cartas j� comporta custos, criaturas com ataque/vida e feiti�os, mas esses campos ainda n�o definem as regras de jogo. Efeitos escritos nas descri��es tamb�m n�o s�o executados pelo prot�tipo.

## Decis�es pendentes

- Mana: crescimento autom�tico ou limite fixo; valor inicial, teto e momento de recarga.
- Baralho: tamanho, quantidade m�xima de c�pias e composi��o m�nima.
- Compra: m�o inicial, compra por turno, mulligan e limite de m�o.
- Turno: ordem das fases e quem come�a.
- Combate: quais permanentes podem atacar, quando ficam prontas, como o defensor escolhe bloqueadores e como dano � resolvido.
- Partida: vida inicial, condi��es de vit�ria e empate, e o que ocorre quando o baralho acaba.
- Efeitos: palavras-chave, dura��o, prioridades e ordem de resolu��o.
- Intera��o: a��es permitidas fora do pr�prio turno e possibilidade de resposta do oponente.

## Princ�pios de implementa��o e balanceamento

- Definir cada regra com precis�o suficiente para que host e clientes resolvam a mesma a��o do mesmo jeito.
- O host valida a��es e mant�m o estado oficial da partida.
- Manter identidade de carta, custo, estat�sticas e efeitos estruturados como dados, sem fazer a l�gica depender do texto de ambienta��o.
- Mudar uma vari�vel de balanceamento por vez e registrar a vers�o das regras usada em cada sess�o de teste.
- Usar as refer�ncias como inspira��o; nomes, textos e efeitos finais devem refletir o grupo e n�o exigir reproduzir cartas existentes.

## Mesa e compra confirmadas em 13/10/2026

- Cada participante come�a com um deck de 60 cartas e uma m�o de 7; limite de m�o: 7.
- O deck fica com 53 cartas ap�s a distribui��o inicial.
- No in�cio de cada turno, compra at� 2 cartas, limitada pelas vagas na m�o e pelas cartas restantes no deck. A distribui��o inicial n�o recebe compra adicional.
- Jogador: cemit�rio � esquerda e deck � direita. Oponente: deck � esquerda e cemit�rio � direita da tela.
- Cartas nos campos dos dois participantes mostram as faces. Deck e cemit�rio mostram o verso; a m�o do jogador local mostra faces e a m�o advers�ria permanece oculta.
- O cemit�rio tem �rea e estado separados, mas ainda n�o existe regra de envio de cartas a ele.
- Deck vazio interrompe a compra; condi��o de vit�ria/derrota por esgotamento continua pendente.

### Limita��es desta vers�o
O prot�tipo repete as defini��es dispon�veis para preencher os decks de 60 e embaralha cada deck. Isto n�o estabelece um limite de c�pias nem implementa constru��o de deck.
O turno advers�rio continua sendo uma espera autom�tica; a compra advers�ria j� respeita as mesmas regras, mas n�o h� IA, combate ou multiplayer.
As faces usam as artes, a moldura Card.png e a fonte Beleren-Bold.ttf originais. O verso continua provis�rio, pois ainda n�o h� um asset dedicado para ele.
