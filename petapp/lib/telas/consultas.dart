import 'package:flutter/material.dart';
// Importa o pacote table_calendar para exibir um calendário interativo
import 'package:table_calendar/table_calendar.dart';
// Importa os DAOs (Data Access Objects) para interagir com o banco de dados para Consultas e Pets
import '../dao/consulta_dao.dart';
import '../dao/pet_dao.dart';
// Importa os modelos de dados para Consulta e Pet
import '../models/consulta.dart';
import '../models/pet.dart';
// Importa o widget personalizado MeuDrawer
import '../widgets/meu_drawer.dart';

//Esta tela é responsável por exibir um calendário para agendar e visualizar consultas veterinárias
class Consultas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConsultasState();
  }
}

class _ConsultasState extends State<Consultas> {
  // Lista de todas as consultas
  List<Consulta> _consultas = [];
  // Lista de todos os pets
  List<Pet> _pets = [];
  // Variável que armazena o dia atualmente selecionado no calendário, que começa com a data atual
  DateTime _diaSelecionado = DateTime.now();
  // Formato de exibição do calendário
  CalendarFormat _formatoCalendario = CalendarFormat.month;
  // Controladores para os campos de texto do formulário de agendamento de consulta
  var _veterinarioController = TextEditingController();
  var _motivoController = TextEditingController();
  // ID do pet selecionado
  String? _petIdSelecionado;

  // Método para atualizar as listas de consultas e pets
  void _atualizarLista() async {
    // Obtém todas as consultas
    final consultasNoBanco = await ConsultaDAO.obterConsultas();
    // Obtém todos os pets
    final petsNoBanco = await PetDAO.obterPets();
    // Atualiza o estado do widget com os novos dados
    setState(() {
      _consultas = consultasNoBanco;
      _pets = petsNoBanco;
    });
  }

  // Método para incluir uma nova consulta no banco de dados
  Future<void> _incluir(Consulta consulta) async {
    await ConsultaDAO.incluirConsulta(consulta);
    _atualizarLista(); // Atualiza a lista após a inclusão
  }

  // Método para excluir uma consulta do banco de dados pelo seu ID
  Future<void> _excluir(int id) async {
    await ConsultaDAO.excluirConsulta(id);
    _atualizarLista(); // Atualiza a lista após a exclusão
  }

  // Retorna uma lista de consultas agendadas para um dia específico
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
    _atualizarLista(); // Carrega os dados iniciais do banco
  }

  // Método para exibir o formulário de agendamento de consulta
  void _mostrarFormulario(BuildContext context) {
    // Limpa os campos de texto do formulário
    _veterinarioController.clear();
    _motivoController.clear();
    // Define o pet selecionado como o primeiro da lista, caso tenha algum cadastrado
    _petIdSelecionado = _pets.isNotEmpty ? _pets[0].id.toString() : null;
    // Exibe um diálogo na tela
    showDialog(
      context: context,
      builder: (context) {
        // Usa StatefulBuilder para permitir que o diálogo tenha seu próprio estado interno
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Agendar Consulta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exibe o dia selecionado no calendário
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
                  // Campo de texto para o nome do veterinário
                  TextField(
                    controller: _veterinarioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome do veterinário',
                    ),
                  ),
                  SizedBox(height: 12),
                  // Campo de texto para o motivo da consulta
                  TextField(
                    controller: _motivoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Motivo (opcional)',
                    ),
                  ),
                  SizedBox(height: 12),
                  // Aqui você escolhe o pet, exibido apenas se houver pets cadastrados
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
                // Botão para cancelar o agendamento da consulta
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                // Botão para agendar a consulta
                FilledButton(
                  onPressed: () {
                    //Verifica se o nome do veterinário e o pet foram informados
                    if (_veterinarioController.text.isEmpty ||
                        _petIdSelecionado == null) {
                      // Exibe uma mensagem de erro se a validação falhar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Informe o veterinário e o pet'),
                        ),
                      );
                      return;
                    }

                    // Encontra o Pet correspondente ao ID selecionado
                    final pet = _pets.firstWhere(
                      (p) => p.id.toString() == _petIdSelecionado,
                    );

                    // Cria uma nova Consulta com os dados do formulário
                    var consulta = Consulta(
                      id: 0, // O ID será gerado automaticamente pelo banco
                      petId: pet.id,
                      petNome: pet.nome,
                      veterinario: _veterinarioController.text,
                      data: _diaSelecionado,
                      motivo: _motivoController.text,
                    );
                    _incluir(consulta); // Inclui a consulta no banco de dados
                    Navigator.pop(context); // Fecha o diálogo
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

  // O método build descreve a interface do usuário desta tela
  @override
  Widget build(BuildContext context) {
    // Obtém as consultas agendadas para o dia selecionado
    final consultasDoDia = _consultasDoDia(_diaSelecionado);

    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas 🩺'), // Título da barra
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Cor de fundo
      ),
      drawer: MeuDrawer(telaAtual: 'consultas'),
      body: Column(
        children: [
          // Widget TableCalendar para exibir o calendário
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1), // Primeiro dia disponível no calendário
            lastDay: DateTime.utc(2030, 12, 31), // Último dia disponível no calendário
            focusedDay: _diaSelecionado, // O dia que o calendário deve focar inicialmente
            calendarFormat: _formatoCalendario,
            selectedDayPredicate: (day) => isSameDay(day, _diaSelecionado),
            // eventLoader é a função que retorna a lista de consultas para um determinado dia
            eventLoader: (day) => _consultasDoDia(day),
            //Chamado quando um dia é selecionado no calendário
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _diaSelecionado = selectedDay; // Atualiza o dia selecionado
              });
            },
            //Chamado quando o formato do calendário é alterado (ex: de mês para semana)
            onFormatChanged: (format) {
              setState(() {
                _formatoCalendario = format; // Atualiza o formato do calendário
              });
            },
          ),

          Divider(),
          // Lista de consultas para o dia selecionado.
          Expanded(
            child: consultasDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma consulta neste dia.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ) // Exibe uma mensagem se não houver consultas
                : ListView.builder(
                    itemCount: consultasDoDia.length, // Número de consultas a serem exibidas
                    itemBuilder: (context, index) {
                      final c = consultasDoDia[index]; // Consulta atual
                      return ListTile(
                        leading: Icon(
                          Icons.medical_services,
                          color: Colors.teal,
                        ), // Ícone de serviço médico.
                        title: Text('Dr(a). ${c.veterinario}'), // Nome do veterinário.
                        isThreeLine: c.motivo.isNotEmpty, // Define se o subtítulo terá três linhas
                        subtitle: Text(
                          'Pet: ${c.petNome}'
                          '${c.motivo.isNotEmpty ? '\nMotivo: ${c.motivo}' : ''}',
                        ), // Nome do pet e motivo da consulta
                        trailing: IconButton.filled(
                          onPressed: () => _excluir(c.id), // Botão para excluir a consulta
                          icon: Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Botão para adicionar uma nova consulta.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context), // Chama o formulário ao ser pressionado
        child: Icon(Icons.add), // Ícone de adição
      ),
    );
  }
}
