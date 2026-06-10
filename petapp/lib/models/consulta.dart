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

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'],
      petId: map['petId'],
      petNome: map['petNome'] ?? '',
      veterinario: map['veterinario'] ?? '',
      data: DateTime.parse(map['data']),
      motivo: map['motivo'] ?? '',
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
