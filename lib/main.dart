import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_aula8_exer3/banco.dart';
import 'package:flutter_aula8_exer3/cadastro.dart';
import 'package:flutter_aula8_exer3/cao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Adicionado para FFI

void main() {
  // Inicializa o sqflite corretamente para plataformas que precisam do FFI
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Usando sqflite_common_ffi para plataformas desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP Cães',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de Cães'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  late Banco banco;
  late Future<Database> database;
  late Future<List<Cao>> caesList;

  void initState() {
    super.initState();
    atualizarLista();
  }

  void atualizarLista() {
    banco = Banco(); // Instancia o banco
    database = banco.iniciaBanco(); // Inicia o banco de dados
    caesList = banco.caes(database); // Carrega a lista de cães
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Cao>>(
        future: caesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum cão cadastrado.'));
          } else {
            final List<Cao> caes = snapshot.data!;

            print('qtd: ${caes.length}');
            return ListView.builder(
              itemCount: caes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.pets),
                  title:
                      Text('${caes[index].nome} (Raça: ${caes[index].raca}) - (Idade: ${caes[index].idade})'),
                );
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar Cão',
        onPressed: () async {
         
          // Navega para a tela de cadastro e aguarda o resultado
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Cadastro()),
          );

          // Se o resultado for true, significa que um novo cão foi cadastrado
          if (result == true) {
            setState(() {
              atualizarLista(); // Atualiza a lista de cães
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}