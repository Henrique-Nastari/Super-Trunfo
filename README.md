# super_trunfo

Projeto Super Trunfo referente a parte da nota da primeira unidade da disciplina de Programação de Dispositivos Móveis do curso de Tecnologia em Análise e Desenvolvimento de Sistemas da Universidade Federal do Rio Grande do Norte - UFRN.

## Sobre a Atividade:

Implementar um aplicativo para consumir uma API gerada com os dados do seguinte repositório:
    - https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json

## Passos:
    
    - Baixe o arquivo JSON e execute um servidor local com os seus dados simuladndo uma API Rest.
    - Utiliza a biblioteca "https://www.npmjs.com/package/json-server".

## Tela Inicial:

### - Herois:
        Abre a tela de listagem dos heróis.

### - Card Diário:
        Abre a tela de encontro diário para obtenção de novas cartas.

### - Minhas Cartas:
        Abre a tela Minhas Cartas.

### - Batalhar:
        Abre a tela de batalha de cartas estilo Super Trunfo.

## Tela de Heróis: 

    - Lista todos os heróis em uma PagedListView utilizando a biblioteca infinite_scroll_pagination.
    - Ao invocar a API o aplicativo deve salvar em cache todas as informações no banco de dados.
    -Se o aplicativo estiver sem internet, o aplicativo deve exibir informações com base no cache do banco de dados.
    - Os cards devem conter informações como nome, powerstarts e appearance dos heróis (não precisa ser tudo).
    - Exiba a imagem miniatura de cada herói no card. Um toque no card deve levar para a tela de detalhes do herói.

## Tela Detalhes do Herói:

    - Exibe a imagem do herói em alta resolução.
    - Exibe todos os detalhes do herói que questão disponíveis na API.
    - As informações devem ir da API ou do cache local.
    - Utilize a biblioteca cached_network_image para fazer cache das imagens.
    - Utilize a biblioteca primer_progress_bar para exibir uma progress bar de cada powerstat.

## Tela Card Diário:

    - Uma vez por dia apresenta uma carta de herói aleatório diferente. No estilo super trunfo. Deve conter apenas nome, imagem e power stats.
    - Utilize o banco de dados ou shared_preferences para guardar informações sobre o dia e o herói sorteado.
    - Adicione um botão adicionar à biblioteca que adiciona o herói sorteado minhas cartas.
        - Se o usuário tiver 15 cartas ele não poderá obter uma nova. Apresente uma mensagem de erro.

## Telas Minhas Cartas:

    - Exibe cards sobre os até 15 cartas obtidas.
    - Um toque no card leva o usuário para a página de detalhes.

## Tela Detalhe Minhas Cartas:

    - Exibe a carta o herói em todos os detalhes.
    - As informações devem ir da API ou do cache local.
    - Botão Abandonar remove a carta da lista de minhas artas.
        - Exiba uma caixa de diálogo para que o usuário confirme a ação. Use a biblioteca awesome_dialog.
    - Utilize a biblioteca cached_network_image para fazer cache das imagens.

## Tela Batalhar:

    - Batalha estilo super trunfo com um amigo. Suas cartas vs as do seu amigo.
    - Cada jogador terá até 15 cartas salvas em seu próprio app.
    - As cartas são organizadas em ordem aleatória pelo app.
    - Cada carta possui os mesmos atributos comparáveis (ex: força, velocidade, defesa, etc).
    - Os jogadores não compartilham cartas; cada um vê apenas a tela do app do outro jogador.

## Como Batalhar:

### Começo do Round
    - Ambos os jogadores revelam a primeira carta da fila no seu celular. Não deixe seu amigo ver a sua tela!

### Escolha o Atributo:
    - Um jogador escolhe um dos atributos da sua carta para competir (vocês podem alternar quem escolhe a cada round ou decidir por sorteio no início).

### Comparação:
    - Ambos comparam esse atributo com a carta correspondente do adversário.

### Determinar o vencedor:
    - Quem tiver o maior valor no atributo escolhido, vence o round.
    - Se houver empate, a rodada pode ser considerada empate.

    - O vencedor deve apertar o botão "Venci o round" no seu celular.
    - O perdedor deve apertar o botão "Perdi o round".
    - Em caso de empate, ambos apertam "Empate" (se houver essa opção).

    - Esses botões servem apenas para controlar o andamento do jogo, passando para a próxima carta da fila.

    - Após o botão ser pressionado, o jogo automaticamente mostra a próxima carta da fila para cada jogador.
    - O processo se repete até que todas as cartas tenham sido utilizadas.

### Fim do Jogo:

- O jogo termina quando:
    - Todas as 15 cartas foram utilizadas. Então, cada jogador informa quantas rodadas venceu. Quem tiver vencido mais rounds, vence o jogo!
    Em caso de empate, os jogadores podem considerar uma rodada de desempate ou aceitar o empate.