import 'package:flutter/material.dart';
// Importa o DAO (Data Access Object)
import '../dao/pet_dao.dart';
// Importa o modelo de dados para Pet
import '../models/pet.dart';
import '../widgets/meu_drawer.dart';

// MeusPets - Esta tela principal lista todos os pets cadastrados

// A lista de pets é dinâmica e muda conforme o usuário adiciona ou exclui pets
class MeusPets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MeusPetsState();
  }
}

class _MeusPetsState extends State<MeusPets> {
  // Lista de pets
  List<Pet> _pets = [];
  // Controladores para os campos de texto do formulário de adição/edição de pet
  var _nomeController = TextEditingController();
  var _especieController = TextEditingController();
  var _racaController = TextEditingController();

  // Método para buscar todos os pets no banco de dados e atualizar a tela
  void _atualizarLista() async {
    // Aguarda a resposta do banco de dados antes de continuar
    final petsNoBanco = await PetDAO.obterPets();
    // Atualiza o estado com os novos dados
    setState(() {
      _pets = petsNoBanco;
    });
  }

  // Método para incluir um novo pet no banco de dados
  Future<void> _incluir(Pet pet) async {
    await PetDAO.incluirPet(pet); // Salva o pet no banco de dados
    _atualizarLista(); // Recarrega a lista para exibir o novo item
  }

  // Método para excluir um pet do banco de dados pelo seu ID
  Future<void> _excluir(int id) async {
    await PetDAO.excluirPet(id); // Remove o pet do banco de dados
    _atualizarLista(); // Recarrega a lista sem o item excluído
  }

  @override
  void initState() {
    super.initState();
    _atualizarLista(); // Carrega os pets assim que a tela é aberta
  }

  // Método para exibir o formulário de adição de pet
  void _mostrarFormulario(BuildContext context) {
    // Limpa os campos de texto antes de abrir o formulário
    _nomeController.clear();
    _especieController.clear();
    _racaController.clear();
    // Exibe um diálogo na tela.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Pet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto para o nome do pet
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome do pet',
                ),
              ),
              SizedBox(height: 12),
              // Campo de texto para a espécie do pet
              TextField(
                controller: _especieController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Espécie (ex: Cachorro)',
                ),
              ),
              SizedBox(height: 12),
              // Campo de texto para a raça do pet
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
            // O botão cancelar ele fecha o diálogo sem realizar nenhuma ação
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),

            // O botão adicionar ele valida os dados e salva o pet
            FilledButton(
              onPressed: () {
                //verifica se o nome do pet foi preenchido
                if (_nomeController.text.isEmpty) {
                  // Exibe uma mensagem de erro se o nome estiver vazio
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha o nome do pet')),
                  );
                  return; // Interrompe a função sem fechar o diálogo
                }
                // Cria um novo Pet com id=0 (o ID real será gerado pelo banco de dados)
                var pet = Pet(
                  id: 0,
                  nome: _nomeController.text,
                  especie: _especieController.text,
                  raca: _racaController.text,
                );

                _incluir(pet); // Salva o pet no banco e atualiza a lista na tela
                Navigator.pop(context); // Fecha o diálogo após salvar
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
        title: Text('Meus Pets 🐶'), // Título da barra
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Cor de fundo
      ),

      // menu lateral da aplicação.
      drawer: MeuDrawer(telaAtual: 'pets'),
      body: _pets.isEmpty
          ? Center(
              // Se a lista de pets estiver vazia, exibe uma mensagem de orientação
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: Colors.grey), // Ícone de pets
                  SizedBox(height: 16),
                  Text(
                    'Nenhum pet cadastrado ainda.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              // Se houver pets, exibe em uma lista
              itemCount: _pets.length, // Número de pets a serem exibidos
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(Icons.pets), // Ícone dentro do círculo
                  ),
                  title: Text(_pets[index].nome), // Nome do pet
                  subtitle: Text(
                    '${_pets[index].especie} · ${_pets[index].raca}', // Espécie e raça do pet
                  ),
                  trailing: IconButton.filled(
                    onPressed: () => _excluir(_pets[index].id), // Botão para excluir o pet
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
      // Botão para adicionar um novo pet.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context), // Chama o formulário ao ser pressionado
        child: Icon(Icons.add), // Ícone de adição
      ),
    );
  }
}
