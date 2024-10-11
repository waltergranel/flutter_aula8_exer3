import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aula8_exer3/banco.dart';
import 'package:flutter_aula8_exer3/cao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  late Banco banco = Banco();
  late Future<Database> database;

  @override
  void initState() {
    super.initState();
    database = banco.iniciaBanco();
    //banco.caes(database);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cadastro de Cães'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome:'),
            ),
            TextField(
              controller: racaController,
              decoration: const InputDecoration(labelText: 'Raça:'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: idadeController,
              decoration: const InputDecoration(labelText: 'Idade:'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                Cao cao = Cao(
                    id: null,
                    nome: nomeController.text,
                    raca: racaController.text,
                    idade: int.parse(idadeController.text));

                // Inserir o cão no banco de dados
                banco.insereCao(database, cao);

                // Navegar de volta para a tela principal após o cadastro
                Navigator.pop(context,
                    true); // Retorna 'true' para indicar que um cadastro foi feito
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
