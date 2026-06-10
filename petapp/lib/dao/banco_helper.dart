import 'package:sqflite/sqflite.dart' as sql;

class BancoHelper {
  // Cria todas as tabelas quando o banco é gerado pela primeira vez
  static Future<void> criarTabelas(sql.Database database) async {
    // Tabela de Pets
    await database.execute("""
      CREATE TABLE pets(
        id       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome     TEXT NOT NULL,
        especie  TEXT,
        raca     TEXT
      );
    """);

    // Tabela de Vacinas — petId referencia o id do pet dono da vacina
    await database.execute("""
      CREATE TABLE vacinas(
        id       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        petId    INTEGER NOT NULL,
        petNome  TEXT NOT NULL,
        nome     TEXT NOT NULL,
        data     TEXT NOT NULL
      );
    """);

    // Tabela de Consultas veterinárias
    await database.execute("""
      CREATE TABLE consultas(
        id           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        petId        INTEGER NOT NULL,
        petNome      TEXT NOT NULL,
        veterinario  TEXT NOT NULL,
        data         TEXT NOT NULL,
        motivo       TEXT
      );
    """);

    // Tabela de Perfil — armazena apenas 1 linha (dados do dono dos pets)
    await database.execute("""
      CREATE TABLE perfil(
        id        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome      TEXT,
        telefone  TEXT,
        email     TEXT
      );
    """);
  }

  // Abre o banco (ou cria se for a primeira vez)
  static Future<sql.Database> abrirBanco() async {
    return sql.openDatabase(
      'petapp.db',
      version: 1,
      // onCreate só é chamado UMA VEZ: quando o arquivo ainda não existe
      onCreate: (db, version) async {
        await criarTabelas(db);
      },
    );
  }
}
