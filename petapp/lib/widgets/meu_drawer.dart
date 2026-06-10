import 'package:flutter/material.dart';
//Aqui importamos as telas das aplicações que serão acessíveis
import '../telas/meus_pets.dart';
import '../telas/vacinas.dart';
import '../telas/consultas.dart';
import '../telas/perfil.dart';

//Aqui é StatelessWidget, por que o seu conteudo é estático, mas as ações de navegação mudam o estado da aplicação
class MeuDrawer extends StatelessWidget {
  //Esta variável serve para identificar qual tela está atualmente ativa
  final String telaAtual;
// Construtor que requer a especificação da tela atual.
  MeuDrawer({required this.telaAtual});
  // O método build descreve a interface do usuário
  @override
  Widget build(BuildContext context) {
    // Retorna um painel que desliza horizontalmente da borda de um Scaffold.
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove o preenchimento padrão do ListView.
        children: [
          //Exibindo o título da aplicação e um ícone.
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, // Cor de fundo do cabeçalho
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo à esquerda.
              mainAxisAlignment: MainAxisAlignment.end, // Alinha o conteúdo para a parte inferior.
              children: [
                Icon(Icons.pets, color: Colors.white, size: 52), // Ícone de pets.
                SizedBox(height: 8), // Espaçamento vertical.
                Text(
                  'Pet App 🐶', // Título da aplicação.
                  style: TextStyle(
                    color: Colors.white, // Cor do texto.
                    fontSize: 22, // Tamanho da fonte.
                    fontWeight: FontWeight.bold, // Negrito.
                  ),
                ),
              ],
            ),
          ),
          // Item da lista para a tela 'Meus Pets'.
          ListTile(
            leading: Icon(Icons.pets), // Ícone do item.
            title: Text('Meus Pets'), // Título do item.
            selected: telaAtual == 'pets', // Define se o item está selecionado.
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer.
              // Navega para a tela MeusPets se ela não for a tela atual
              if (telaAtual != 'pets') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MeusPets()),
                );
              }
            },
          ),
          // Item da lista para a tela Vacinas.
          ListTile(
            leading: Icon(Icons.vaccines), // Ícone do item.
            title: Text('Vacinas'), // Título do item.
            selected: telaAtual == 'vacinas', // Define se o item está selecionado.
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer.
              // Navega para a tela Vacinas se ela não for a tela atual
              if (telaAtual != 'vacinas') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Vacinas()),
                );
              }
            },
          ),
          // Item da lista para a tela Consultas.
          ListTile(
            leading: Icon(Icons.calendar_month), // Ícone do item.
            title: Text('Consultas'), // Título do item.
            selected: telaAtual == 'consultas', // Define se o item está selecionado.
            onTap: () {
              Navigator.pop(context);
              // Navega para a tela Consultas se ela não for a tela atual.
              if (telaAtual != 'consultas') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Consultas()),
                );
              }
            },
          ),
          Divider(), // Um divisor visual entre os itens.
          // Item da lista para a tela Perfil.
          ListTile(
            leading: Icon(Icons.person), // Ícone do item.
            title: Text('Perfil'), // Título do item.
            selected: telaAtual == 'perfil', // Define se o item está selecionado.
            onTap: () {
              Navigator.pop(context);
              // Navega para a tela Perfil se ela não for a  tela atual.
              if (telaAtual != 'perfil') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Perfil()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
