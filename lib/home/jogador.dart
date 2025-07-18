class Jogador {
  String nome;
  int pontos;

  Jogador({required this.nome, this.pontos = 0});

  void adicionarPonto() {
    pontos++;
  }

  void resetarPontos() {
    pontos = 0;
  }

  @override
  String toString() {
    return 'Jogador{'
        'nome: $nome, '
        'pontos: $pontos}';
  }



}