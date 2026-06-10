import 'package:flutter/material.dart';
import '../telas/meus_pets.dart';
import '../telas/vacinas.dart';
import '../telas/consultas.dart';
import '../telas/perfil.dart';

class MeuDrawer extends StatelessWidget {
  final String telaAtual;

  MeuDrawer({required this.telaAtual});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.pets, color: Colors.white, size: 52),
                SizedBox(height: 8),
                Text(
                  'Pet App 🐶',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Meus Pets'),
            selected: telaAtual == 'pets',
            onTap: () {
              Navigator.pop(context);
              if (telaAtual != 'pets') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MeusPets()),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.vaccines),
            title: Text('Vacinas'),
            selected: telaAtual == 'vacinas',
            onTap: () {
              Navigator.pop(context);
              if (telaAtual != 'vacinas') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Vacinas()),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Consultas'),
            selected: telaAtual == 'consultas',
            onTap: () {
              Navigator.pop(context);
              if (telaAtual != 'consultas') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Consultas()),
                );
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            selected: telaAtual == 'perfil',
            onTap: () {
              Navigator.pop(context);
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
