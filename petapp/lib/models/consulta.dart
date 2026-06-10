class Consulta {
  int id;
  int petId; // id do pet que vai à consulta
  String petNome; // nome do pet (para facilitar a exibição)
  String veterinario; // nome do veterinário
  DateTime data; // data da consulta
  String motivo; // motivo da consulta (pode ficar vazio)

  Consulta({
    required this.id,
    required this.petId,
    required this.petNome,
    required this.veterinario,
    required this.data,
    required this.motivo,
  });
  // Construtor de fábrica para criar uma instância de Consulta a partir de um Map.
  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'], //Id da consulta
      petId: map['petId'], //Id do pet
      petNome: map['petNome'] ?? '', //Nome do pet
      veterinario: map['veterinario'] ?? '',//Nome do veterinario
      data: DateTime.parse(map['data']),//Data da consulta
      motivo: map['motivo'] ?? '',//Motivo da consulta
    );
  }

  // Converte para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'petNome': petNome,
      'veterinario': veterinario,
      'data': data.toIso8601String(),
      'motivo': motivo,
    };
  }
}
