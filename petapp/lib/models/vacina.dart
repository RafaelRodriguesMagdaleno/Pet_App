class Vacina {
  int id;
  int petId; // id do pet a quem pertence essa vacina
  String petNome; // nome do pet (guardamos aqui para facilitar a exibição)
  String nome; // nome da vacina (ex: "Antirrábica")
  DateTime data; // data em que foi aplicada

  Vacina({
    required this.id,
    required this.petId,
    required this.petNome,
    required this.nome,
    required this.data,
  });
// Construtor de fábrica para criar uma instância de Vacina a partir de um Map.
  factory Vacina.fromMap(Map<String, dynamic> map) {
    return Vacina(
      id: map['id'],
      petId: map['petId'],
      petNome: map['petNome'] ?? '',
      nome: map['nome'] ?? '',
      data: DateTime.parse(
        map['data'],
      ), // converte o texto "2025-06-01" em DateTime
    );
  }
// Converte a instância atual de Vacina para um Map<String, dynamic>.
  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'petNome': petNome,
      'nome': nome,
      'data': data.toIso8601String(),
    };
  }
}
