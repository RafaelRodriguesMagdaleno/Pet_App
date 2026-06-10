import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../dao/consulta_dao.dart';
import '../dao/pet_dao.dart';
import '../models/consulta.dart';
import '../models/pet.dart';
import '../widgets/meu_drawer.dart';

// Consultas — tela com calendário para agendar/ver consultas veterinárias.
class Consultas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConsultasState();
  }
}

class _ConsultasState extends State<Consultas> {
  List<Consulta> _consultas = [];
  List<Pet> _pets = [];

  DateTime _diaSelecionado = DateTime.now();
  CalendarFormat _formatoCalendario = CalendarFormat.month;

  var _veterinarioController = TextEditingController();
  var _motivoController = TextEditingController();
  String? _petIdSelecionado;

  void _atualizarLista() async {
    final consultasNoBanco = await ConsultaDAO.obterConsultas();
    final petsNoBanco = await PetDAO.obterPets();
    setState(() {
      _consultas = consultasNoBanco;
      _pets = petsNoBanco;
    });
  }

  Future<void> _incluir(Consulta consulta) async {
    await ConsultaDAO.incluirConsulta(consulta);
    _atualizarLista();
  }

  Future<void> _excluir(int id) async {
    await ConsultaDAO.excluirConsulta(id);
    _atualizarLista();
  }

  List<Consulta> _consultasDoDia(DateTime dia) {
    return _consultas
        .where(
          (c) =>
              c.data.year == dia.year &&
              c.data.month == dia.month &&
              c.data.day == dia.day,
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _mostrarFormulario(BuildContext context) {
    _veterinarioController.clear();
    _motivoController.clear();
    _petIdSelecionado = _pets.isNotEmpty ? _pets[0].id.toString() : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Agendar Consulta'),
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
                  // Campo do veterinário
                  TextField(
                    controller: _veterinarioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome do veterinário',
                    ),
                  ),
                  SizedBox(height: 12),
                  // Campo do motivo
                  TextField(
                    controller: _motivoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Motivo (opcional)',
                    ),
                  ),
                  SizedBox(height: 12),
                  // Dropdown para escolher o pet
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
                    // Veterinário é obrigatório; motivo e raça são opcionais
                    if (_veterinarioController.text.isEmpty ||
                        _petIdSelecionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Informe o veterinário e o pet'),
                        ),
                      );
                      return;
                    }

                    final pet = _pets.firstWhere(
                      (p) => p.id.toString() == _petIdSelecionado,
                    );

                    var consulta = Consulta(
                      id: 0,
                      petId: pet.id,
                      petNome: pet.nome,
                      veterinario: _veterinarioController.text,
                      data: _diaSelecionado,
                      motivo: _motivoController.text,
                    );
                    _incluir(consulta);
                    Navigator.pop(context);
                  },
                  child: Text('Agendar'),
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
    final consultasDoDia = _consultasDoDia(_diaSelecionado);

    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas 🩺'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MeuDrawer(telaAtual: 'consultas'),

      body: Column(
        children: [
          // Calendário
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _diaSelecionado,
            calendarFormat: _formatoCalendario,
            selectedDayPredicate: (day) => isSameDay(day, _diaSelecionado),
            // eventLoader: coloca ponto nos dias que têm consulta agendada
            eventLoader: (day) => _consultasDoDia(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _diaSelecionado = selectedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _formatoCalendario = format;
              });
            },
          ),

          Divider(),
          // Lista de consultas do dia selecionado
          Expanded(
            child: consultasDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma consulta neste dia.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: consultasDoDia.length,
                    itemBuilder: (context, index) {
                      final c = consultasDoDia[index];
                      return ListTile(
                        leading: Icon(
                          Icons.medical_services,
                          color: Colors.teal,
                        ),
                        title: Text('Dr(a). ${c.veterinario}'),
                        isThreeLine: c.motivo.isNotEmpty,
                        subtitle: Text(
                          'Pet: ${c.petNome}'
                          '${c.motivo.isNotEmpty ? '\nMotivo: ${c.motivo}' : ''}',
                        ),
                        trailing: IconButton.filled(
                          onPressed: () => _excluir(c.id),
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
