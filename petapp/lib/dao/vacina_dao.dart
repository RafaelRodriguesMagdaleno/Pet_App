import '../models/vacina.dart';
import 'banco_helper.dart';

class VacinaDAO {
  static Future<int> incluirVacina(Vacina vacina) async {
    final banco = await BancoHelper.abrirBanco();
    return await banco.insert('vacinas', vacina.toMap());
  }

  // Retorna todas as vacinas ordenadas por data
  static Future<List<Vacina>> obterVacinas() async {
    final banco = await BancoHelper.abrirBanco();
    final maps = await banco.query('vacinas', orderBy: 'data');
    return maps.map((map) => Vacina.fromMap(map)).toList();
  }

  static Future<bool> excluirVacina(int id) async {
    final banco = await BancoHelper.abrirBanco();
    try {
      await banco.delete('vacinas', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (erro) {
      print('Erro ao excluir vacina: $erro');
      return false;
    }
  }
}
