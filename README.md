# Brasileirão App (iOS)

Este diretório contém o código-fonte do aplicativo iOS "Brasileirão", desenvolvido para acompanhar jogos de futebol. O aplicativo consome dados de uma API backend (cujo código está no diretório `api/` deste repositório) e oferece funcionalidades offline.

## ✨ Funcionalidades (MVP)

* **Listagem de Jogos:** Exibe uma lista de jogos com nomes dos times, escudos, placar, data e horário.
* **Detalhe do Jogo:** Ao tocar em um jogo, exibe informações mais detalhadas da partida, incluindo os lances formatados.
* **Persistência Offline:** A lista de jogos e seus detalhes estão disponíveis offline, utilizando SwiftData.
* **Atualização de Dados:** Capacidade de atualizar a lista de jogos via "Pull-to-Refresh" para buscar as últimas informações da API.
* **Carregamento de Imagens:** Carregamento assíncrono e cache dos escudos dos times usando Kingfisher.

## 📐 Arquitetura e Tecnologias

O aplicativo é construído utilizando a arquitetura **MVVM (Model-View-ViewModel)**, que promove a separação de preocupações e facilita a manutenção e testabilidade do código.

* **Linguagem:** Swift
* **Framework UI:** SwiftUI
* **Persistência de Dados:** SwiftData
* **Requisições de Rede:** URLSession
* **Carregamento de Imagens:** Kingfisher (via Swift Package Manager)

## ⚙️ Configuração e Execução Local

Siga os passos abaixo para configurar e rodar o aplicativo iOS em seu dispositivo ou simulador.

### Pré-requisitos

* **Xcode 15.0 ou superior:** Necessário para desenvolver e compilar o aplicativo.
* **macOS Sonoma (14.0) ou superior:** Para compatibilidade com o Xcode 15+ e SwiftData.
* **Dispositivo/Simulador iOS 17.0 ou superior:** SwiftData requer iOS 17+.
* **API Backend Rodando:** Certifique-se de que a API do Brasileirão (localizada em `api/` neste repositório) esteja em execução em `http://localhost:8080`.

### Instalação

1.  **Clone o Repositório Principal:**
    Se você ainda não clonou o repositório principal:
    ```bash
    git clone [URL_DO_SEU_REPOSITORIO]
    ```
2.  **Navegue até o diretório do Projeto iOS:**
    ```bash
    cd [caminho_do_seu_repositorio]/ios-app/BrasileiraoApp
    ```
    (Ou o nome da pasta do seu projeto Xcode)
3.  **Abra o Projeto no Xcode:**
    Clique duas vezes no arquivo `.xcodeproj` ou `.xcworkspace` (se gerado) ou abra o Xcode e vá em `File > Open...` e selecione a pasta do projeto.
4.  **Instalar Dependências (Kingfisher):**
    O Kingfisher é gerenciado via Swift Package Manager (SPM). O Xcode deve baixar e resolver as dependências automaticamente ao abrir o projeto. Se não o fizer, vá em `File > Packages > Resolve Package Versions`.

### Executando o Aplicativo

1.  **Selecione um Simulador ou Dispositivo:** Na barra de ferramentas do Xcode, escolha um simulador (`iPhone 15 Pro`, por exemplo) ou conecte um dispositivo físico. Certifique-se de que ele esteja rodando **iOS 17.0 ou superior**.
2.  **Rode a Aplicação:** Clique no botão "Run" (o ícone de play) na barra de ferramentas do Xcode, ou use `Command + R`.

## ⚠️ **Consideração Importante: App Transport Security (ATS) Exception**

Ao tentar carregar os escudos dos times fornecidos pela `s.glbimg.com`, foi encontrado o erro **"The resource could not be loaded because the App Transport Security policy requires the use of a secure connection."**

* **Problema:** O iOS (a partir do iOS 9) exige por padrão que todas as conexões de rede usem HTTPS (`https://`) por motivos de segurança. Os URLs dos escudos da Globo.com fornecidos no desafio são HTTP (`http://`).
* **Solução para o Desafio (Workaround):** Para permitir o carregamento dessas imagens HTTP durante o desenvolvimento para este desafio, uma exceção de App Transport Security (ATS) foi adicionada à configuração do projeto (que é incorporada no `Info.plist` gerado).
    * A exceção permite que o aplicativo se conecte de forma insegura ao domínio `s.glbimg.com`.
    * Essa configuração pode ser encontrada em: **Project Navigator > Nome do Projeto (Target) > Aba "Info" > "App Transport Security Settings" > "Exception Domains" > `s.glbimg.com`**.
* **Como seria corrigido em um ambiente de produção:**
    1.  **Opção Recomendada (Ideal):** A forma correta e segura de resolver isso em um aplicativo de produção seria garantir que as URLs das imagens sejam fornecidas via **HTTPS**. Isso envolveria solicitar à fonte dos dados que forneça URLs HTTPS, ou usar um serviço de proxy/CDN que possa servir as imagens via HTTPS a partir da fonte HTTP original.
    2.  **Opção Alternativa (Se HTTPS Direto não for possível):** Se não for possível obter as imagens via HTTPS, uma API backend poderia baixar essas imagens, armazená-las em um servidor seguro (ex: AWS S3, Cloudinary) e então fornecer URLs HTTPS dessas imagens armazenadas para o aplicativo iOS. Esta abordagem centraliza o risco de segurança no backend e permite que o frontend se comunique sempre via HTTPS.

## 📚 Ideias para Melhorias Futuras

* **Implementação de Testes:** Adicionar testes de unidade e UI para as Views, ViewModels e serviços.
* **Design de UI/UX:** Aprimorar o design visual das telas, animações e interações do usuário.
* **Cache de Dados (Mais Robusto):** Otimizar o uso do SwiftData para caching de rede, garantindo que o aplicativo sempre exiba os dados mais recentes de forma eficiente.
* **Tratamento de Erros Avançado:** Melhorar a exibição de erros na UI e a recuperação de falhas de rede.
* **Otimização de Performance:** Profiling para identificar e resolver gargalos de desempenho.
* **Notificações Push:** Integrar com notificações para alertar sobre início de jogos, gols, etc.
* **Widgets na Tela Inicial:** Criar widgets para exibir placares rápidos na tela de início do iOS.
* **Modo Escuro (Dark Mode):** Implementar suporte completo ao modo escuro.

---