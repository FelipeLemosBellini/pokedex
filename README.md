# pokedex

### 1.Visão geral
 
*  O App Pokedex é um explorador de pokemons para os entusiastas desse universo, ele conta com filtros 
e buscas para encontrar o seu pokemon favorito.

#### Vídeo do app 
https://drive.google.com/file/d/10D9Em32LNbHE7Jod44365ZSFKfvOOlt5/view?usp=sharing

#### Implementações
* Mecanismo de busca por nome ou id do pokemon
* Filtragem por tipo de pokemon
* Ordenação por ordem alfabética ou id(crescente)
* Modal com detalhes do pokemon
* Opção de abrir um pokemon relacionado dentro do modal de outro pokemon


### Detalhes técnicos
Durante o desenvolvimento do projeto foi notado que a resposta da API de pokemons não permite passagem de parametro para filtro, então, para evitar o trabalho de realizar várias requisições que buscariam todos os pokemons todas as vezes que for solicitado, foi implementado um cache local que vai ser usado para salvar localmente os pokemons e pode ser útil no caso de não haver conexão com a internet, sendo possivel com um movimento de _refresh_ fazer a busca dos dados na API.

Alguns dados dos pokemons exibidos no Modal dos detalhes estão sendo gerados randomicamente pois não estão presentes na resposta da API fornecida

**Conectividade**: Para que o app continue funcionando mesmo sem acesso a internet foi implementado o cache dos pokemons, é realizado uma validação de conexão para isso e o consumo em diante é feito dos pokemons salvos localmente, podendo ser atualizado com o gesture de _**refresh**_ na tela principal.

**Snack Bar e avisos**: Foi adicionado alguns **SnackBars** para alertar o usuário falhas, respostas vazias e similares...

**Retry Logic**: Foi criado um interceptor que tenta refazer a requisição se ela entrar em alguns critérios de resposta

### 2. Stack Técnica
- Flutter: 3.32.0
- Dart: 3.8.0

#### Dependências principais:
- flutter_bloc: 9.1.1
- dio: ^5.9.0
- flutter_dotenv: ^6.0.0
- flutter_modular: ^6.4.1
- result_dart: ^2.1.1
- flutter_svg: ^2.2.2
- shared_preferences: ^2.5.3
- connectivity_plus: ^7.0.0

### 3. Arquitetura
Para o desenvolvimento do presente projeto foi abordado o uso do **Clean Architecture** e gerencimento da camada de apresentação baseando-se em eventos, 
apesar de ser um projeto pequeno, a forma que o projeto está apresentado busca trazer uma alta 
flexibilidade para sua continuidade uma vez que a filosofia baseada vem de principios básicos como inversão de dependencia, separação de responsabilidades e outros.

A estrutura atual do app conta com 3 camadas, (**Data**, **Domain** e **Presentation**)
<img width="1240" height="849" alt="UI" src="https://github.com/user-attachments/assets/680efd7d-360c-4bd3-a234-27aaaa9ba3be" />
<img width="667" height="245" alt="UI (1)" src="https://github.com/user-attachments/assets/fc934266-f018-4c29-840b-a8d0647939f1" />

### 3.1. Data

A camada da **Data** fica por conta das implementações relacionada aos dados, conta com **Classes DataSources** que são responsáveis por buscar o dado de X localidade.
USO: Obtenção de dados remoto e local.

Intermediário(Data/Domain) Para que os dados saiam de um DataSource é utilizado uma Classe Repository para armazenar lógicas relacionadas a infra/localidade do dado.
USO: Gerenciamento de onde viria os dados dos pokemons com ou sem internet.

### 3.2. Domain
A camada Domain fica responsável por definir regras de negócio usando UseCases e armazenar as DTOs(classes modelos -> pokemon.dart)
USO: Não foi julgado necessário o uso de UC pois não houveram regras de negócios que requisitasse estar dentro de um UC, os repositories só possuem lógicas relacionadas aos dados/localidade/infra como dito 

### 3.3. Presentation
A camada de apresentação é responsável por gerenciar a UI, foi utilizado o BLoC para criar estados bem definidos da tela e captar eventos de interação do usuário.
USO: Tela de listagem de pokemons e detalhes dos mesmos.


### 3.4. Gerenciamento de estado

Foi Utilizado o BLoC como gerenciador de estado, além de estar entre os pacotes recomendados o padrão BLoC é muito bom em separar responsabilidades de lógica e UI, apesar de ser um pouco mais trabalhoso o seu desenvolvimento, ele facilita o processo de manutenibilidade das features já que sua estrutura permite separar bem as chamadas por eventos, além de tornar fácil a emissão de um novo estado para a tela de forma robusta.

### 4. Instruções de Setup
#### Pré-requisitos
- Flutter SDK >= 3.32.0
- Dart SDK >= 3.8.0
- Android Studio / Xcode
- Java 17
- Cocoapods last-version

## Instalação
1. Clone o repositório
2. Execute `flutter pub get`

[//]: # (3. Configure [API keys, etc.])
4. Execute `flutter run`

### 5. Comandos de Execução
#### Executar aplicação
flutter run

#### Executar testes
flutter test

### 6. Justificativa de Pacotes

#### Modular
Além de ser um pacote recomendado ele foi extremamente útil já que ele faz o gerenciamento das dependencias e rotas do app, além disso caso o projeto crescesse ele seria um ótimo gerenciador pois consegue segregar em módulos, separando contextos, facilitando trabalho de times maiores simultanemanete e injetando modulos somente quando necessário ajudando no desempenho.

#### Bloc 
Conforme dito no 3.4, o BLoC um pacote recomendado, separa muito bem a lógica da UI, responsabilidades e contextos bem definidas graças aos eventos. 

#### Dio
Foi Escolhido o Dio como pacote para realizar as solicitações REST pois nos requisítos era necessário implementar Interceptors, o pacote é bem robusto para isso e é mais completo do que outros como o http.

#### flutter_dotenv
Mesmo se tratando de uma API open source **"eu quis trazer o pacote para armazenar a base url que o projeto consome pois acredito muito na proposta de segurança de esconder as URLs da aplicação"**, mas resolvi subi o arquivo no commit pela praticidade de quem for testar meu projeto.

#### result_dart
Sou muito adepto em trazer esses auxiliadores de tratamento de resposta pois são muito úteis para entender o erro, facilita a implementação da camada de apresentação saber oque deve ser feito para o usuário, fora que os tests unitários também ficam bem organizados também.

#### flutter_svg
O design possui alguns SVGs e esse pacote foi prático de apresenta-los.

#### shared_preferences
Foi desenvolvido a capacidade de armazenar localmente os pokemons e o pacote é prático de configurar. Foi descartado usar pacotes de banco de dados relacional por se tratar de poucos tipos de dados, se fosse mais dados diferentes talvez usaria algum banco de dados local.

#### connectivity_plus
Para decidir qual datasource iria trazer os dados precisei usar um pacote que me informasse o status de conectividade e esse me serviu bem. 

#### 

### Falta implementar:

paginação dos itens

google analytics
criar um diagrama
