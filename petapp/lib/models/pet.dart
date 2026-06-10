class Pet {
  int id; // identificador único gerado pelo banco
  String nome;
  String especie;
  String raca;

  // Construtor: todos os campos são obrigatórios
  Pet({
    required this.id,
    required this.nome,
    required this.especie,
    required this.raca,
  });
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'], // pega o valor da chave 'id' do mapa
      nome: map['nome'] ?? '', // ?? '' evita null se o campo vier vazio
      especie: map['especie'] ?? '',
      raca: map['raca'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'especie': especie, 'raca': raca};
  }
}
