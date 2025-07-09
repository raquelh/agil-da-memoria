class Conceitos {
  final String nome;
  final String descricao;
  int id;

  Conceitos({required this.nome, required this.descricao, required this.id});

  @override
  String toString() {
    return 'Conceitos{'
        'nome: $nome, '
        'descricao: $descricao}';
  }
}


