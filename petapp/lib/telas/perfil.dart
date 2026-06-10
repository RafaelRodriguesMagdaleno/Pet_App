import 'package:flutter/material.dart';
import '../dao/perfil_dao.dart';
import '../widgets/meu_drawer.dart';

class Perfil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<Perfil> {
  var _nomeController = TextEditingController();
  var _telefoneController = TextEditingController();
  var _emailController = TextEditingController();

  // Busca o perfil salvo no banco e preenche os campos de texto.
  void _carregarPerfil() async {
    final dados = await PerfilDAO.obterPerfil();
    setState(() {
      _nomeController.text = dados['nome'] ?? '';
      _telefoneController.text = dados['telefone'] ?? '';
      _emailController.text = dados['email'] ?? '';
    });
  }

  // Lê o que está nos campos e salva no banco.
  Future<void> _salvarPerfil() async {
    await PerfilDAO.salvarPerfil(
      _nomeController.text,
      _telefoneController.text,
      _emailController.text,
    );

    // mensagem rápida que aparece na parte inferior da tela
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Perfil salvo com sucesso!')));
  }

  @override
  void initState() {
    super.initState();
    _carregarPerfil(); // carrega o perfil salvo ao abrir a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil 👤'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MeuDrawer(telaAtual: 'perfil'),

      // adiciona espaçamento ao redor do conteúdo
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 52),
            ),
            SizedBox(height: 24),

            // Campo: Nome
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 12),

            // Campo: Telefone
            // abre o teclado numérico no celular
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Telefone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            SizedBox(height: 12),

            // Campo: E-mail
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress, // teclado com @ e .com
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            SizedBox(height: 24),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _salvarPerfil,
                icon: Icon(Icons.save),
                label: Text('Salvar Perfil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
