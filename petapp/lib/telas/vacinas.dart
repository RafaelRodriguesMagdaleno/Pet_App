import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // biblioteca do calendário
import '../dao/vacina_dao.dart';
import '../dao/pet_dao.dart';
import '../models/vacina.dart';
import '../models/pet.dart';
import '../widgets/meu_drawer.dart';

class Vacinas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VacinasState();
  }
}

class _VacinasState extends State<Vacinas> {
  List<Vacina> _vacinas = []; // todas as vacinas do banco
  List<Pet> _pets = []; // todos os pets

  // o dia que o usuário tocou no calendário
  DateTime _diaSelecionado = DateTime.now();

  // controla se mostra mês inteiro, 2 semanas ou 1 semana
  CalendarFormat _formatoCalendario = CalendarFormat.month;

  var _nomeVacinaController = TextEditingController();
  String? _petIdSelecionado; // id do pet escolhido

  void _atualizarLista() async {
    final vacinasNoBanco = await VacinaDAO.obterVacinas();
    final petsNoBanco = await PetDAO.obterPets();
    setState(() {
      _vacinas = vacinasNoBanco;
      _pets = petsNoBanco;
    });
  }

  Future<void> _incluir(Vacina vacina) async {
    await VacinaDAO.incluirVacina(vacina);
    _atualizarLista();
  }

  Future<void> _excluir(int id) async {
    await VacinaDAO.excluirVacina(id);
    _atualizarLista();
  }

  // Filtra a lista _vacinas retornando só as que pertencem ao 'dia' informado.

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
    _atualizarLista(); // carrega vacinas e pets ao abrir a tela
  }

  void _mostrarFormulario(BuildContext context) {
    _nomeVacinaController.clear();
    _petIdSelecionado = _pets.isNotEmpty ? _pets[0].id.toString() : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Adicionar Vacina'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mostra qual dia foi selecionado no calendário
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

                  TextField(
                    controller: _nomeVacinaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome da vacina',
                    ),
                  ),
                  SizedBox(height: 12),
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
                        setStateDialog(() {
                          _petIdSelecionado = value;
                        });
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (_nomeVacinaController.text.isEmpty ||
                        _petIdSelecionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha todos os campos')),
                      );
                      return;
                    }
                    final pet = _pets.firstWhere(
                      (p) => p.id.toString() == _petIdSelecionado,
                    );

                    var vacina = Vacina(
                      id: 0,
                      petId: pet.id,
                      petNome: pet.nome,
                      nome: _nomeVacinaController.text,
                      data:
                          _diaSelecionado, // usa o dia selecionado no calendário
                    );
                    _incluir(vacina);
                    Navigator.pop(context);
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
    // Vacinas do dia selecionado
    final vacinasDoDia = _vacinasDoDia(_diaSelecionado);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vacinas 💉'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MeuDrawer(telaAtual: 'vacinas'),

      body: Column(
        children: [
          TableCalendar(
            // Intervalo de datas que o calendário permite navegar
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _diaSelecionado,
            calendarFormat: _formatoCalendario,
            selectedDayPredicate: (day) => isSameDay(day, _diaSelecionado),
            eventLoader: (day) => _vacinasDoDia(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _diaSelecionado = selectedDay; // atualiza o dia selecionado
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _formatoCalendario = format;
              });
            },
          ),
          Divider(),
          Expanded(
            child: vacinasDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma vacina neste dia.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: vacinasDoDia.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.vaccines, color: Colors.teal),
                        title: Text(vacinasDoDia[index].nome),
                        subtitle: Text('Pet: ${vacinasDoDia[index].petNome}'),
                        trailing: IconButton.filled(
                          onPressed: () => _excluir(vacinasDoDia[index].id),
                          icon: Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
