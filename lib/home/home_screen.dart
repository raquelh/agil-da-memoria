import 'dart:async';
import 'dart:math';

import 'package:agil_memoria/home/jogador.dart';
import 'package:agil_memoria/home/selecao_jogadores.dart';
import 'package:flutter/material.dart';

import 'conceitos.dart';
import 'lista_conceitos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool carregando = false;
  int jogadorAtual = 0;
  List<_CardModel> _cards = [];

  List<int> _selectedIndices = [];

  List<Jogador> jogadores = [];

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards({bool recomecar = false}) {
    final fullList = List<Conceitos>.from(conceitos)..addAll(conceitos);
    fullList.shuffle(Random());
    _cards = [];
    carregando = true;
    for (var i = 0; i <= 5; i++) {
      _cards.add(_CardModel(
        value: fullList[i],
        texto: fullList[i].nome,
        isFlipped: true,
      ));
      _cards.add(_CardModel(
        value: fullList[i],
        texto: fullList[i].descricao,
        isFlipped: true,
      ));
    }
    _cards.shuffle(Random());
    setState(() {});

    if (jogadores.isEmpty || recomecar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelecaoJogadores(
              onConfirmar: (j) {
                Navigator.pop(context);
                jogadores = j;
                Timer(Duration(seconds: 7), () {
                  for (var i = 0; i < _cards.length; i++) {
                    setState(() {
                      _cards[i].isFlipped = false;
                    });
                  }
                  carregando = false;
                });
              },
            ),
          ),
        );
      });
    }
  }

  void _onCardTap(int index) {
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      _CardModel first = _cards[_selectedIndices[0]];
      _CardModel second = _cards[_selectedIndices[1]];

      if (first.value.id == second.value.id) {
        setState(() {
          first.isMatched = true;
          second.isMatched = true;
          jogadores[jogadorAtual].adicionarPonto();
        });
        _selectedIndices.clear();
      } else {
        Timer(Duration(seconds: 1), () {
          setState(() {
            first.isFlipped = false;
            second.isFlipped = false;
            _selectedIndices.clear();
          });
        });
      }

      setState(() {
        Timer(Duration(seconds: 1), () {
          jogadorAtual = (jogadorAtual + 1) % jogadores.length;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff282A2C),
        toolbarHeight: 1,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (jogadores.isNotEmpty)
            Container(
              width: double.infinity,
              color: Color(0xff282A2C),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Placar',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: jogadores.map((j) {
                      return Text('${j.nome} - ${j.pontos} pontos',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ));
                    }).toList(),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 10,
          ),
          if (jogadores.isNotEmpty)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: RichText(
                text: TextSpan(
                  text: 'Vez de ',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(
                        text: ' ${jogadores[jogadorAtual].nome}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              ),
            ),
          if (carregando)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Iniciando',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: GridView.builder(
                itemCount: _cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (_, index) {
                  final card = _cards[index];
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: card.isFlipped || card.isMatched
                            ? Color(0xFF81C784)
                            : Color(0xFF7986CB),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        card.isFlipped || card.isMatched ? card.texto : '',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _initializeCards(recomecar: true),
        tooltip: "Reiniciar",
        child: Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}

class _CardModel {
  final Conceitos value;
  bool isFlipped;
  bool isMatched = false;
  final String texto;

  _CardModel(
      {required this.value, required this.texto, this.isFlipped = false});
}
