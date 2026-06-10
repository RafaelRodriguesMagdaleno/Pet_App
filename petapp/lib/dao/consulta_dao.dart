import '../models/consulta.dart';
import 'banco_helper.dart';

// ConsultaDAO: operações de banco para a tabela consultas.
class ConsultaDAO {

  static Future<int> incluirConsulta(Consulta consulta) async {
    final banco = await BancoHelper.abrirBanco();
    return await banco.insert('consultas', consulta.toMap());
  }

  // Retorna todas as consultas ordenadas por data
  static Future<List<Consulta>> obterConsultas() async {
    final banco = await BancoHelper.abrirBanco();
    final maps = await banco.query('consultas', orderBy: 'data');
    return maps.map((map) => Consulta.fromMap(map)).toList();
  }
// Método para excluir uma consulta específica do banco de dados pelo seu ID
  static Future<bool> excluirConsulta(int id) async {
    final banco = await BancoHelper.abrirBanco();
    try {
      await banco.delete('consultas', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (erro) {
      print('Erro ao excluir consulta: $erro');
      return false;
    }
  }
}
