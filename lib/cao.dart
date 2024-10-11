class Cao {
  final int? id;
  final String nome;
  final String raca;
  final int idade;

  Cao({
    required this.id,
    required this.nome,
    required this.raca,
    required this.idade,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'raca': raca,
      'idade': idade,
    };
  }

  @override
  String toString() {
    return 'Cao{id: $id, nome: $nome, idade: $idade}';
  }
}
