import 'package:flutter/material.dart';
import 'package:flutter_aula8_exer3/cao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Banco {
  late Future<Database> database;

  Future<Database> iniciaBanco() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = openDatabase(
      join(await getDatabasesPath(), 'petshop2.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE caes(id INTEGER PRIMARY KEY, nome TEXT, raca TEXT, idade INTEGER)',
        );
      },
      version: 1,
    );

    return database;
  }

  // Função que insere Cao na tabela caes
Future<void> insereCao(Future<Database> database, Cao cao) async {
  final db = await database;

  await db.insert(
    'caes',
    cao.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

  // Future<void> insereCao(Cao cao) async {
  //   final db = await database;
  //   print("entrou");
  //   await db?.insert(
  //     'caes',
  //     cao.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //       print("entrou222");

  // }

  // Future<List<Cao>> caes() async {
  //   final db = await database;

  //   final List<Map<String, Object?>>? mapasCaes = await db?.query('caes');

  //   return [
  //     for (final {
  //           'id': id as int,
  //           'nome': nome as String,
  //           'idade': idade as int,
  //         } in mapasCaes)
  //       Cao(id: id, nome: nome, idade: idade),
  //   ];
  // }

  // Future<List<Cao>> caes() async {
  //   final db = await database;

  //   // Consulta os registros da tabela 'caes'
  //   final List<Map<String, dynamic>>? mapasCaes = await db?.query('caes');

  //   // Retorna a lista de objetos 'Cao'
  //   return List.generate(mapasCaes?.length ?? 0, (i) {
  //     return Cao(
  //       id: mapasCaes![i]['id'] as int,
  //       nome: mapasCaes[i]['nome'] as String,
  //       idade: mapasCaes[i]['idade'] as int,
  //     );
  //   });
  // }

  Future<List<Cao>> caes(Future<Database> database) async {
  final db = await database;

  final List<Map<String, Object?>> mapasCaes = await db.query('caes');
  print('dentro da função ${mapasCaes.length}');
  return [
    for (final {
          'id': id as int,
          'nome': nome as String,
          'raca': raca as String,
          'idade': idade as int,
        } in mapasCaes)
      Cao(id: id, nome: nome, raca: raca, idade: idade),
  ];
}

  Future<void> atualizaCao(Cao cao) async {
    final db = await database;

    await db.update(
      'caes',
      cao.toMap(),
      where: 'id = ?',
      whereArgs: [cao.id],
    );
  }

  Future<void> apagaCao(int id) async {
    final db = await database;

    await db.delete(
      'caes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
