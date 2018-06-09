# Carlota Presente

Ferramenta para detectar e avaliar candidaturas laranjas.

## Critérios

1.	Possuir um e-mail válido -> TSE Base Candidatos
2.	Ter apresentado proposta de governo -> Não disponivel p/ Legislativo
3.	Essa proposta ter um conteúdo real -> Não disponivel p/ Legislativo
4.	Movimentação de receitas de campanha -> TSE Prestação de Contas Parcial/Final
5.	Movimentação de despesas de campanha -> TSE Prestação de Contas Parcial/Final
6.	Possuir outros doadores além do partido e dela própria -> TSE Prestação de Contas Parcial/Final
7.	Receber repasses do partido -> TSE Prestação de Contas Parcial/Final
8.	Eventual transferência desses repasses para candidaturas ->  TSE Prestação de Contas Parcial/Final
9.	Apresentação dos extratos por conta partidária ->  TSE Extrato de Campanha
10.	Deferimento da candidatura -> TSE Base Candidatos
11.	Perfil no Facebook -> TSE Base Candidatos
12.	Atividades no Facebook -> API Facebook
13.	Seguidores no Facebook -> **Não pode ser mensurado diretamente** Usar engajamento em posts no lugar?
14.	Perfil no Twitter -> API Twitter
15.	Atividades no Twitter -> API Twitter Sugestão: Integrar com script de analise de bot.
16.	Seguidores no Twitter -> API Twitter
17.	Perfil no Instagram -> Crawler na pagina do Instagram
18.	Atividades no Instagram -> Crawler na pagina do Instagram
19.	Seguidores no Instagram -> Crawler na pagina do Instagram
20.	Notícias sobre a candidatura durante o período eleitoral -> Bing News Search API

Após as eleições:
21.	A quantidade de votos recebidos -> TSE Base de Resultados Eleitorais
22.	A apresentação de prestação de contas -> TSE Base de Prestação de Contas Final

## Bot Carlota Presente

http://twitter.com/carlotapresente

Posta tweets alertando Partido e Órgão Público sobre as candidaturas laranjas detectadas.

Formato:

POST:
{{partido_uf}} você sabia que existem {{no_candidaturas}} detectadas como possivelmente laranjas pelo nosso bot? {{procurador_uf}} você pode ajudar a investigar?

https://developer.twitter.com/en/docs/tweets/post-and-engage/overview



## Módulos p/ Desenvolvimento

**Ferramentas de Extração de Dados TSE**

* Importador de Dados do TSE

**Ferramentas de Extração de dados das Redes Sociais**

* Importador de dados da página no FB
* Importador de dados do perfil no twitter
* Importador de dados do perfil no instagram

**App**

* Algoritmo de classificação de candidaturas baseada nos Critérios
* Ferramenta de visualização das candidaturas laranjas p/
  * Partido
  * Raça
  * UF


## Fontes de Dados

**TSE**
http://www.tse.jus.br/eleicoes/estatisticas/repositorio-de-dados-eleitorais-1/repositorio-de-dados-eleitorais

**Facebook**
https://developers.facebook.com/docs/graph-api/using-graph-api/v1.0#search


**Twitter**
https://developer.twitter.com/en/docs/accounts-and-users/follow-search-get-users/api-reference/get-users-lookup

**Instagram**
https://www.instagram.com/{{account}}/
Acesso via crawler.

**Bing**
https://azure.microsoft.com/pt-br/services/cognitive-services/bing-news-search-api/
