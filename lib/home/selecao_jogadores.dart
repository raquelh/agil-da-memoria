import 'package:flutter/material.dart';

import 'jogador.dart';

class SelecaoJogadores extends StatefulWidget {
  final void Function(List<Jogador>) onConfirmar;

  const SelecaoJogadores({super.key, required this.onConfirmar});

  @override
  State<SelecaoJogadores> createState() => _SelecaoJogadoresState();
}

class _SelecaoJogadoresState extends State<SelecaoJogadores> {
  final TextEditingController _controller = TextEditingController();
  final List<Jogador> jogadores = [];

  void _adicionarJogador() {
    final nome = _controller.text.trim();
    if (nome.isNotEmpty && jogadores.length < 3) {
      setState(() {
        jogadores.add(Jogador(nome: nome));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Jogadores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome do Jogador',
                suffixIcon: Icon(Icons.person_add),
              ),
              onSubmitted: (_) => _adicionarJogador(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarJogador,
              child: const Text('Adicionar Jogador'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: jogadores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(jogadores[index].nome),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: jogadores.isNotEmpty
                  ? () => widget.onConfirmar(jogadores)
                  : null,
              child: const Text('Iniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}
