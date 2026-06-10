import '../models/pet.dart';
import 'banco_helper.dart';

class PetDAO {
  // Insere um novo pet no banco
  static Future<int> incluirPet(Pet pet) async {
    final banco = await BancoHelper.abrirBanco();
    // insert() retorna o id gerado automaticamente
    return await banco.insert('pets', pet.toMap());
  }

  // Busca todos os pets, ordenados por nome (A → Z)
  static Future<List<Pet>> obterPets() async {
    final banco = await BancoHelper.abrirBanco();
    final maps = await banco.query('pets', orderBy: 'nome');
    return maps.map((map) => Pet.fromMap(map)).toList();
  }

  // Atualiza os dados de um pet existente
  static Future<int> alterarPet(Pet pet) async {
    final banco = await BancoHelper.abrirBanco();
    return await banco.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  // Remove um pet do banco pelo id
  static Future<bool> excluirPet(int id) async {
    final banco = await BancoHelper.abrirBanco();
    try {
      await banco.delete('pets', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (erro) {
      print('Erro ao excluir pet: $erro');
      return false;
    }
  }
}
