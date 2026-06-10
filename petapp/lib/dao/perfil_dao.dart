import 'banco_helper.dart';

class PerfilDAO {
  // Busca o perfil salvo. Se não existe ainda, retorna campos vazios.
  static Future<Map<String, String>> obterPerfil() async {
    final banco = await BancoHelper.abrirBanco();
    final lista = await banco.query('perfil');

    if (lista.isEmpty) {
      return {'nome': '', 'telefone': '', 'email': ''};
    }

    final dados = lista.first;
    return {
      'nome': dados['nome']?.toString() ?? '',
      'telefone': dados['telefone']?.toString() ?? '',
      'email': dados['email']?.toString() ?? '',
    };
  }

  // Salva o perfil insere se não existe, atualiza se já existe
  static Future<void> salvarPerfil(
    String nome,
    String telefone,
    String email,
  ) async {
    final banco = await BancoHelper.abrirBanco();
    final valores = {'nome': nome, 'telefone': telefone, 'email': email};
    final lista = await banco.query('perfil');

    if (lista.isEmpty) {
      await banco.insert('perfil', valores);
    } else {
      final id = lista.first['id'] as int;
      await banco.update('perfil', valores, where: 'id = ?', whereArgs: [id]);
    }
  }
}
