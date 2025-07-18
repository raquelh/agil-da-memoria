class Carta {
  final String termo;
  final String descricao;
  bool revelada;
  bool combinada;

  Carta(
      {required this.termo,
      required this.descricao,
      this.revelada = false,
      this.combinada = false});
}
