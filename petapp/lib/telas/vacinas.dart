import 'package:flutter/material.dart';
// Importa o pacote table_calendar para exibir um calendário interativo
import 'package:table_calendar/table_calendar.dart';
// Importa os DAOs (Data Access Objects) para interagir com Vacinas e Pets.
import '../dao/vacina_dao.dart';
import '../dao/pet_dao.dart';
import '../models/vacina.dart';
import '../models/pet.dart';
import '../widgets/meu_drawer.dart';

// Esssa tela permite ao usuário visualizar e agendar vacinas para seus pets usando um calendário
class Vacinas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VacinasState();
  }
}

class _VacinasState extends State<Vacinas> {
  // Lista de todas as vacinas
  List<Vacina> _vacinas = [];
  // Lista de todos os pets
  List<Pet> _pets = [];

  // Variável que armazena o dia atualmente selecionado no calendário
  DateTime _diaSelecionado = DateTime.now();

  // Formato de exibição do calendário (mês, semana, 2 semanas)
  CalendarFormat _formatoCalendario = CalendarFormat.month;

  // Controlador para o campo de texto do nome da vacina no formulário
  var _nomeVacinaController = TextEditingController();
  // ID do pet selecionado no formulário
  String? _petIdSelecionado;

  // Método para atualizar as listas de vacinas e pets
  void _atualizarLista() async {
    // Obtém todas as vacinas do banco de dados
    final vacinasNoBanco = await VacinaDAO.obterVacinas();
    // Obtém todos os pets do banco de dados
    final petsNoBanco = await PetDAO.obterPets();
    // Atualiza o estado do widget com os novos dados
    setState(() {
      _vacinas = vacinasNoBanco;
      _pets = petsNoBanco;
    });
  }

  // Método para incluir uma nova vacina no banco de dados
  Future<void> _incluir(Vacina vacina) async {
    await VacinaDAO.incluirVacina(vacina);
    _atualizarLista(); // Atualiza a lista após a inclusão
  }

  // Método para excluir uma vacina do banco de dados pelo seu ID
  Future<void> _excluir(int id) async {
    await VacinaDAO.excluirVacina(id);
    _atualizarLista(); // Atualiza a lista após a exclusão
  }

  // Filtra a lista _vacinas retornando apenas as que pertencem ao dia informado
  List<Vacina> _vacinasDoDia(DateTime dia) {
    return _vacinas
        .where(
          (v) =>
              v.data.year == dia.year &&
              v.data.month == dia.month &&
              v.data.day == dia.day,
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _atualizarLista(); // Carrega as vacinas e pets iniciais do banco
  }

  // Método para exibir o formulário de adição de vacina
  void _mostrarFormulario(BuildContext context) {
    // Limpa o campo de texto do nome da vacina
    _nomeVacinaController.clear();
    // Define o pet selecionado como o primeiro da lista, se houver pets cadastrados
    _petIdSelecionado = _pets.isNotEmpty ? _pets[0].id.toString() : null;

    // Exibe um diálogo
    showDialog(
      context: context,
      builder: (context) {
        // Usa StatefulBuilder para permitir que o diálogo tenha seu próprio estado interno
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Adicionar Vacina'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mostra o dia selecionado no calendário
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Data: ${_diaSelecionado.day}/${_diaSelecionado.month}/${_diaSelecionado.year}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Campo de texto para o nome da vacina
                  TextField(
                    controller: _nomeVacinaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome da vacina',
                    ),
                  ),
                  SizedBox(height: 12),
                  // Parte para escolher o pet, exibido apenas se houver pets cadastrados
                  if (_pets.isEmpty)
                    Text(
                      'Cadastre um pet primeiro.',
                      style: TextStyle(color: Colors.red),
                    )
                  else
                    DropdownButtonFormField<String>(
                      value: _petIdSelecionado,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pet',
                      ),
                      items: _pets.map((pet) {
                        return DropdownMenuItem(
                          value: pet.id.toString(),
                          child: Text(pet.nome),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Atualiza o estado do diálogo quando um pet é selecionado
                        setStateDialog(() {
                          _petIdSelecionado = value;
                        });
                      },
                    ),
                ],
              ),
              actions: [
                // Botão para cancelar a adição da vacina
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                // Botão para adicionar a vacina
                FilledButton(
                  onPressed: () {
                    // verifica se o nome da vacina e o pet foram informados
                    if (_nomeVacinaController.text.isEmpty ||
                        _petIdSelecionado == null) {
                      // Exibe uma mensagem de erro se a validação falhar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha todos os campos')),
                      );
                      return;
                    }
                    // Encontra o Pet correspondente ao ID selecionado
                    final pet = _pets.firstWhere(
                      (p) => p.id.toString() == _petIdSelecionado,
                    );

                    // Cria uma Vacina com os dados do formulário
                    var vacina = Vacina(
                      id: 0, // O ID será gerado automaticamente pelo banco
                      petId: pet.id,
                      petNome: pet.nome,
                      nome: _nomeVacinaController.text,
                      data:
                          _diaSelecionado, // Usa o dia selecionado no calendário
                    );
                    _incluir(vacina); // Inclui a vacina no banco de dados
                    Navigator.pop(context); // Fecha o diálogo
                  },
                  child: Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtém as vacinas agendadas para o dia selecionado
    final vacinasDoDia = _vacinasDoDia(_diaSelecionado);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vacinas 💉'), // Título da barra
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Cor de fundo
      ),
      // menu lateral da aplicação.
      drawer: MeuDrawer(telaAtual: 'vacinas'),

      // Corpo principal da tela
      body: Column(
        children: [
          // TableCalendar para exibir o calendário
          TableCalendar(
            // Intervalo de datas que o calendário permite navegar
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _diaSelecionado, // O dia que o calendário deve focar inicialmente
            calendarFormat: _formatoCalendario, // Formato atual do calendário
            selectedDayPredicate: (day) => isSameDay(day, _diaSelecionado),
            // Função que retorna a lista de vacinas para um determinado dia
            eventLoader: (day) => _vacinasDoDia(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _diaSelecionado = selectedDay; // Atualiza o dia selecionado
              });
            },
            // chamado quando o formato do calendário é alterado (ex: de mês para semana)
            onFormatChanged: (format) {
              setState(() {
                _formatoCalendario = format; // Atualiza o formato do calendário
              });
            },
          ),
          Divider(),
          // Lista de vacinas para o dia selecionado
          Expanded(
            child: vacinasDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma vacina neste dia.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ) // Exibe uma mensagem se não houver vacinas
                : ListView.builder(
                    itemCount: vacinasDoDia.length, // Número de vacinas a serem exibidas
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.vaccines, color: Colors.teal), // Ícone de vacina
                        title: Text(vacinasDoDia[index].nome), // Nome da vacina
                        subtitle: Text('Pet: ${vacinasDoDia[index].petNome}'), // Nome do pet associado
                        trailing: IconButton.filled(
                          onPressed: () => _excluir(vacinasDoDia[index].id), // Botão para excluir a vacina
                          icon: Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Botão para adicionar uma nova vacina
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context), // Chama o formulário ao ser pressionado
        child: Icon(Icons.add), // Ícone de adição
      ),
    );
  }
}
