# Product Catalog (iOS)
 
App iOS em SwiftUI que consome [DummyJSON](https://dummyjson.com/products), guarda o catálogo localmente e permite listar, pesquisar e ver detalhe de produtos. Inclui um formulário validado. Tem dois modos de execução independentes.
 
## Requisitos
 
- Xcode 26.2+
- iOS 17.0+
- Internet no primeiro arranque do modo catálogo
Sem dependências externas: basta abrir `ProductCatalog.xcodeproj`.
 
## Como executar
 
Escolher um scheme e carregar em ⌘R.
 
- `Catalog-Beta`: modo catálogo, build Debug. Abre a lista e o detalhe.
- `Catalog-Prod`: modo catálogo, build Release. Abre a lista e o detalhe.
- `Form-Beta`: modo formulário, build Debug. Abre só o formulário.
- `Form-Prod`: modo formulário, build Release. Abre só o formulário.

 
## O que foi implementado
 
**Catálogo**
- Descarrega da API só no primeiro arranque e guarda em disco. Se o download for interrompida, recomeça.
- Lista com título, rating e ícone por escalão (< 3, 3 a 4, > 4), paginada no scroll.
- Pesquisa em tempo real por nome e descrição: sem distinção de maiúsculas ou acentos, termos em qualquer ordem.
- Detalhe com título, preço, desconto, stock, rating e imagem principal.
**Formulário**
- Nome, email (regex), número (só dígitos), código promocional (maiúsculas e hífenes, 3 a 7 caracteres, sem acentos), data de entrega (nem segunda-feira nem data futura) e avaliação (Mau a Excelente).
## Arquitetura
 
Clean Architecture com MVVM (`@Observable`). As dependências apontam para o domínio.
 
```
App/           ProductCatalogApp, RootView, AppDependencies
Domain/        Modelos, protocolos, FormValidator (Swift puro)
Data/          API, DTO, repositório, armazenamento em ficheiro
Presentation/  Views e ViewModels
```
 
### Como os ficheiros comunicam
 
`ProductCatalogApp` cria uma única `AppDependencies` e entrega-a ao `RootView`. `AppDependencies` é a raiz de composição: é o único sítio que conhece as classes concretas e as liga.
 
**Catálogo**
 
Presentation:
- `ProductListView` e `ProductDetailView` mostram o estado e enviam ações (pesquisar, scroll, selecionar).
- `RemoteImage` e `RatingIcon` são componentes reutilizáveis.
- `ProductListViewModel` guarda o estado, a pesquisa e a paginação. Só conhece o protocolo `ProductRepository`.
Domain:
- `ProductRepository` é o protocolo. O domínio não sabe de onde vêm.
- `Product` é o modelo usado por todas as camadas.
Data:
- `DefaultProductRepository` implementa o protocolo e decide a origem: ficheiro local se existir, senão API.
- `ProductAPI` e os DTOs fazem o pedido HTTPS e a descodificação. Convertem para `Product`.
- `ProductStoring`, `ProductFileStore` e `StoredProduct` guardam e leem o catálogo em disco, com o seu próprio modelo.
Fluxo: `View → ViewModel → ProductRepository → DefaultProductRepository → (ProductFileStore, senão ProductAPI)`. Os dados vão pelo mesmo caminho e a View redesenha-se sozinha porque o ViewModel é `@Observable`.
 
**Formulário**
 
`OrderFormView → OrderFormViewModel → FormValidator`. O validador (Domain) devolve um `FormFieldError` tipado, e o ViewModel traduz-o em texto com `FormFieldError+Message`. `FormField` e `DeliveryRating+Title` descrevem os campos e as opções do ecrã.
 
**Modos de execução:** um só target, quatro configurações (`Debug`, `Release`, `Debug-Form`, `Release-Form`). As `-Form` definem a flag `FORM_ENABLED`, e o `RootView` escolhe o ecrã com `#if FORM_ENABLED`. Cada modo tem bundle id e nome próprios.
 
## Decisões técnicas
 
- **Sem bibliotecas externas**: a plataforma cobre tudo o que é preciso.
- **MVVM com Observation e async/await**: fluxo reativo simples. Acesso ao ficheiro isolado num `actor`.
- **Persistência em JSON**: o catálogo escreve-se uma vez e lê-se inteiro. Escrita atómica, ficheiro versionado, inválido ou vazio é descartado e só se guarda depois de o download estar completo. Está atrás de um protocolo, por isso é trocável.
- **Paginação na UI, não na fonte de dados**: a API é descarregada em páginas de 50 só para obter tudo e guardar uma vez, e a partir daí o catálogo completo está em memória. O `ProductListViewModel` mantém a lista completa (`products`) e um contador (`displayedCount`). A lista mostra só os primeiros `displayedCount` resultados, e cada linha que aparece pede mais (`loadMoreIfNeeded`) quando está perto do fim. Assim:
  - a lista nunca cria milhares de linhas de uma vez;
  - a pesquisa corre sempre sobre o catálogo completo e volta à primeira página a cada alteração;
  - o detalhe procura o produto na lista completa, por isso a seleção não se perde ao filtrar;
  - não há pedidos de rede ao fazer scroll.
- **`RemoteImage` próprio em vez de `AsyncImage`**: em navegação um `onDisappear` cancelava o carregamento.
- **Validação pura no domínio** (`FormValidator`), com relógio e calendário injetados para testes especificos.
- **Erros do formulário só após submeter** Data e avaliação têm valor por omissão (hoje e "Muito Bom").
- **Código promocional**: o limite de 3 a 7 conta os hífenes.
 
## Testes
 
Swift Testing, com testes parametrizados e dobles de teste. Cobrem o validador, o view model do formulário, o armazenamento em ficheiro e o repositório (primeiro download, arranques seguintes sem rede, falhas).
 
