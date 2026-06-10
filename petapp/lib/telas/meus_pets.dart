import 'package:flutter/material.dart';
import '../dao/pet_dao.dart';
import '../models/pet.dart';
import '../widgets/meu_drawer.dart';

// tela principal, lista todos os pets cadastrados.
// a lista de pets muda quando o usuário adiciona ou exclui.

class MeusPets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MeusPetsState();
  }
}

class _MeusPetsState extends State<MeusPets> {
  List<Pet> _pets = []; // lista de pets carregada do banco
  var _nomeController = TextEditingController();
  var _especieController = TextEditingController();
  var _racaController = TextEditingController();

  // Busca todos os pets no banco e atualiza a tela.

  void _atualizarLista() async {
    // await: espera o banco responder antes de continuar
    final petsNoBanco = await PetDAO.obterPets();
    setState(() {
      _pets = petsNoBanco;
    });
  }

  Future<void> _incluir(Pet pet) async {
    await PetDAO.incluirPet(pet); // salva no banco
    _atualizarLista(); // recarrega a lista para mostrar o novo item
  }

  Future<void> _excluir(int id) async {
    await PetDAO.excluirPet(id); // remove do banco
    _atualizarLista(); // recarrega a lista sem o item excluído
  }

  @override
  void initState() {
    super.initState();
    _atualizarLista(); // carrega os pets assim que a tela abre
  }

  void _mostrarFormulario(BuildContext context) {
    // Limpa os campos antes de abrir o formulário
    _nomeController.clear();
    _especieController.clear();
    _racaController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Pet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome do pet',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _especieController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Espécie (ex: Cachorro)',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _racaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Raça',
                ),
              ),
            ],
          ),
          actions: [
            // Botão Cancelar: fecha o dialog sem fazer nada
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),

            // Botão Adicionar: valida e salva o pet
            FilledButton(
              onPressed: () {
                // Validação: nome é obrigatório
                if (_nomeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha o nome do pet')),
                  );
                  return; // interrompe sem fechar o dialog
                }
                // Cria o objeto Pet com id=0 (o banco vai gerar o id real)
                var pet = Pet(
                  id: 0,
                  nome: _nomeController.text,
                  especie: _especieController.text,
                  raca: _racaController.text,
                );

                _incluir(pet); // salva no banco e atualiza a lista
                Navigator.pop(context); // fecha o dialog após salvar
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pets 🐶'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      drawer: MeuDrawer(telaAtual: 'pets'),
      body: _pets.isEmpty
          ? Center(
              // Tela vazia: ícone + texto de orientação
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum pet cadastrado ainda.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(Icons.pets),
                  ),
                  title: Text(_pets[index].nome),
                  subtitle: Text(
                    '${_pets[index].especie} · ${_pets[index].raca}',
                  ),
                  trailing: IconButton.filled(
                    onPressed: () => _excluir(_pets[index].id),
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
