# Pet App 🐶

Um aplicativo Flutter para gerenciar informações de pets, incluindo cadastro de animais, controle de vacinas, agendamento de consultas veterinárias e dados do perfil do proprietário.

## ✨ Funcionalidades

*   **Gerenciamento de Pets:** Adicione, visualize e remova seus animais de estimação.
*   **Controle de Vacinas:** Registre e acompanhe as vacinas de cada pet com um calendário interativo.
*   **Agendamento de Consultas:** Agende e visualize consultas veterinárias, associando-as a um pet específico.
*   **Perfil do Proprietário:** Mantenha suas informações de contato atualizadas.

## 📂 Estrutura do Projeto

O projeto segue uma estrutura modular para facilitar a organização e manutenção do código:

| Diretório / Arquivo | Descrição |
| :--- | :--- |
| **`lib/main.dart`** | O ponto de entrada do aplicativo. Inicializa o Flutter e carrega o widget principal `PetApp`. |
| **`lib/petapp.dart`** | Define a configuração global do app, como o tema visual (cores) e a tela inicial (`MeusPets`). |
| **`lib/models/`** | Contém as classes que definem os modelos de dados do aplicativo: `Pet`, `Vacina` e `Consulta`. Elas incluem métodos para converter os dados para o formato que o banco de dados entende (`fromMap` e `toMap`). |
| **`lib/dao/`** | Camada de acesso aos dados (Data Access Objects - DAOs). Aqui estão os arquivos que interagem diretamente com o banco de dados SQLite (`banco_helper.dart`, `consulta_dao.dart`, `perfil_dao.dart`, `pet_dao.dart`, `vacina_dao.dart`) para realizar operações de persistência (salvar, ler, atualizar, excluir). |
| **`lib/telas/`** | Contém as interfaces de usuário (UIs) de cada tela do aplicativo: `consultas.dart`, `meus_pets.dart`, `perfil.dart`, `vacinas.dart`. |
| **`lib/widgets/`** | Componentes visuais reutilizáveis. O `meu_drawer.dart` é o menu lateral de navegação que aparece em todas as telas principais do aplicativo. |

## 🚀 Pré-requisitos

Antes de começar, certifique-se de ter os seguintes softwares instalados em sua máquina:

*   **Git:** Para clonar o repositório do projeto.
*   **Flutter SDK:** O kit de desenvolvimento de software do Flutter.
*   **IDE:** Um ambiente de desenvolvimento integrado, como Visual Studio Code ou Android Studio.
*   **Emulador/Dispositivo:** Um emulador Android/iOS ou um dispositivo físico para testar o aplicativo.

## 💻 Instalação do Flutter SDK

Siga as instruções abaixo para instalar o Flutter SDK em seu sistema operacional. Para informações mais detalhadas e atualizadas, consulte a [documentação oficial do Flutter](https://docs.flutter.dev/install).

### 🌐 1. Baixar o Flutter SDK

1.  Acesse a página de [instalação do Flutter](https://docs.flutter.dev/install).
2.  Selecione seu sistema operacional (Windows, macOS ou Linux).
3.  Baixe o arquivo ZIP do Flutter SDK.
4.  Extraia o arquivo ZIP para um local de sua preferência (ex: `C:\src\flutter` no Windows, `~/development/flutter` no macOS/Linux).

### ⚙️ 2. Configurar o PATH

Adicione o diretório `bin` do Flutter ao seu PATH para poder executar comandos `flutter` de qualquer terminal.

*   **Windows:**
    1.  No menu Iniciar, pesquise por "env" e selecione "Editar as variáveis de ambiente do sistema".
    2.  Na janela "Propriedades do Sistema", clique em "Variáveis de Ambiente...".
    3.  Em "Variáveis de usuário para `<seu_usuário>`", selecione a variável `Path` e clique em "Editar...".
    4.  Clique em "Novo" e adicione o caminho completo para a pasta `bin` dentro do diretório onde você extraiu o Flutter (ex: `C:\src\flutter\bin`).
    5.  Clique em "OK" em todas as janelas para fechar.

*   **macOS/Linux:**
    1.  Abra um terminal.
    2.  Edite seu arquivo `rc` (ex: `$HOME/.zshrc` para Zsh, `$HOME/.bashrc` para Bash) com seu editor de texto preferido.
    3.  Adicione a seguinte linha (substitua `/path/to/flutter` pelo caminho real onde você extraiu o Flutter):
        ```bash
        export PATH="$PATH:/path/to/flutter/bin"
        ```
    4.  Salve o arquivo e feche o editor.
    5.  Execute `source ~/.zshrc` (ou `source ~/.bashrc`) para atualizar o terminal.

### ✅ 3. Verificar a Instalação

Abra um novo terminal e execute o comando:

```bash
flutter doctor
```

Este comando verifica seu ambiente e exibe um relatório. Ele listará as ferramentas instaladas e as que precisam ser configuradas. Preste atenção a quaisquer avisos ou erros e siga as instruções para resolvê-los.

### 🛠️ 4. Configuração Específica do Sistema Operacional

*   **Windows:**
    *   **Visual Studio:** Para desenvolver aplicativos Flutter para desktop Windows, você precisará do Visual Studio (diferente do VS Code). Instale o Visual Studio e certifique-se de incluir a carga de trabalho "Desenvolvimento para desktop com C++". [Guia de configuração para Windows](https://docs.flutter.dev/platform-integration/windows/setup).

*   **macOS:**
    *   **Xcode:** Para desenvolver aplicativos Flutter para iOS e macOS, você precisará do Xcode. Instale-o pela App Store. Após a instalação, configure as ferramentas de linha de comando do Xcode e aceite as licenças. [Guia de configuração para macOS](https://docs.flutter.dev/platform-integration/macos/setup).
    *   **CocoaPods:** Para plugins Flutter que usam código nativo do macOS, instale o CocoaPods. [Guia de instalação do CocoaPods](https://guides.cocoapods.org/syntax/podfile.html).

*   **Linux:**
    *   **Dependências:** Para desenvolver aplicativos Flutter para desktop Linux, instale os pacotes pré-requisitos. Em distribuições baseadas em Debian (como Ubuntu), use:
        ```bash
        sudo apt-get update -y && sudo apt-get upgrade -y
        sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev libstdc++-12-dev
        ```
        [Guia de configuração para Linux](https://docs.flutter.dev/platform-integration/linux/setup).

## 🚀 Configuração do Ambiente de Desenvolvimento (IDE)

Recomenda-se usar o **Visual Studio Code** ou **Android Studio** para o desenvolvimento Flutter.

### Visual Studio Code

1.  Instale o [Visual Studio Code](https://code.visualstudio.com/).
2.  Abra o VS Code, vá para a aba de Extensões (Ctrl+Shift+X ou Cmd+Shift+X).
3.  Pesquise e instale as extensões `Flutter` e `Dart`.

### Android Studio

1.  Instale o [Android Studio](https://developer.android.com/studio).
2.  Abra o Android Studio, vá em `File > Settings > Plugins` (ou `Android Studio > Preferences > Plugins` no macOS).
3.  Pesquise e instale os plugins `Flutter` e `Dart`.
4.  Reinicie o Android Studio.
5.  Configure um emulador Android através do AVD Manager (`Tools > Device Manager`).

## ▶️ Executando o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd petapp
    ```

2.  **Obtenha as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Conecte um dispositivo ou inicie um emulador:**
    Certifique-se de que um emulador Android/iOS esteja rodando ou que um dispositivo físico esteja conectado e reconhecido pelo Flutter (`flutter devices`).

4.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```

## 🗄️ Configuração do Banco de Dados (SQLite)

O **Pet App** utiliza o `sqflite` para persistência de dados local. A configuração do banco de dados é gerenciada principalmente pelo arquivo `lib/dao/banco_helper.dart`.

*   **`banco_helper.dart`**: Este arquivo é responsável por:
    *   Abrir ou criar o banco de dados (`petapp.db`).
    *   Definir a versão do esquema do banco.
    *   Criar todas as tabelas (`pets`, `vacinas`, `consultas`, `perfil`) na primeira inicialização do aplicativo.

Qualquer alteração na estrutura das tabelas deve ser feita neste arquivo, e a versão do banco deve ser incrementada para que as migrações sejam aplicadas corretamente.

## 📄 Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.
