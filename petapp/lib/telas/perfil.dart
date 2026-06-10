import 'package:flutter/material.dart';
// Importa o DAO (Data Access Object)
import '../dao/perfil_dao.dart';
import '../widgets/meu_drawer.dart';

//Esta tela permite ao usuário visualizar e editar suas informações de perfil
class Perfil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<Perfil> {
  // Controladores para os campos de texto do formulário de perfil
  var _nomeController = TextEditingController();
  var _telefoneController = TextEditingController();
  var _emailController = TextEditingController();

  // Método para carregar os dados do perfil salvo no banco de dados e preencher os campos de texto
  void _carregarPerfil() async {
    // Obtém os dados do perfil do banco de dados através do PerfilDAO
    final dados = await PerfilDAO.obterPerfil();
    // Atualiza os dados carregados
    setState(() {
      // Preenche os controladores de texto com os dados do perfil
      _nomeController.text = dados['nome'] ?? '';
      _telefoneController.text = dados['telefone'] ?? '';
      _emailController.text = dados['email'] ?? '';
    });
  }

  // Método para salvar as informações do perfil no banco de dados ele lê os valores dos campos de texto e os passa para o PerfilDAO
  Future<void> _salvarPerfil() async {
    // Chama o método salvarPerfil do DAO, passando os textos dos controladores
    await PerfilDAO.salvarPerfil(
      _nomeController.text,
      _telefoneController.text,
      _emailController.text,
    );

    // Exibe uma mensagem temporária para informar ao usuário que o perfil foi salvo com sucesso
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Perfil salvo com sucesso!')));
  }

  @override
  void initState() {
    super.initState();
    _carregarPerfil(); // Carrega o perfil salvo assim que a tela é aberta
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior da aplicação
      appBar: AppBar(
        title: Text('Perfil 👤'), // Título da barra
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Cor de fundo
      ),
      drawer: MeuDrawer(telaAtual: 'perfil'),

      // Corpo principal da tela
      body: Padding(
        padding: EdgeInsets.all(16), // Adiciona um espaçamento de 16 pixels em todas as direções
        child: Column(
          children: [
            // Avatar circular para representar o usuário
            CircleAvatar(
              radius: 48, // Raio do círculo
              backgroundColor: Theme.of(context).colorScheme.primaryContainer, // Cor de fundo do avatar
              child: Icon(Icons.person, size: 52), // Ícone de pessoa dentro do avatar
            ),
            SizedBox(height: 24), // Espaçamento vertical

            // Campo de texto para o Nome
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), // Borda do campo de texto
                labelText: 'Nome', // Rótulo do campo
                prefixIcon: Icon(Icons.person_outline), // Ícone à esquerda do texto
              ),
            ),
            SizedBox(height: 12), // Espaçamento vertical

            // Campo de texto para o Telefone
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone, // Define o teclado para o tipo telefônico
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Telefone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            SizedBox(height: 12), // Espaçamento vertical

            // Campo de texto para o E-mail
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress, // Define o teclado para o tipo de e-mail
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            SizedBox(height: 24), // Espaçamento vertical

            // Botão Salvar Perfil
            SizedBox(
              width: double.infinity, // Ocupa a largura máxima disponível
              child: FilledButton.icon(
                onPressed: _salvarPerfil, // Chama o método _salvarPerfil ao ser pressionado
                icon: Icon(Icons.save), // Ícone de salvar
                label: Text('Salvar Perfil'), // Texto do botão
              ),
            ),
          ],
        ),
      ),
    );
  }
}
