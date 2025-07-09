import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'conceitos.dart';
import 'lista_conceitos.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<_CardModel> _cards = [];

  List<int> _selectedIndices = [];


  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final fullList = List<Conceitos>.from(conceitos)..addAll(conceitos);
    fullList.shuffle(Random());
    _cards = [];

    for(var i = 0; i<=5; i++){
      _cards.add(_CardModel(value: fullList[i], texto: fullList[i].nome));
      _cards.add(_CardModel(value: fullList[i], texto: fullList[i].descricao));
    }
    _cards.shuffle(Random());
    setState(() {});
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = 3;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1,

      ),
      body: Padding(
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
                      ? Colors.white
                      : Colors.blueAccent,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _initializeCards,
        tooltip: "Reiniciar",
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _CardModel {
  final Conceitos value;
  bool isFlipped = false;
  bool isMatched = false;
  final String texto;
  _CardModel({required this.value, required this.texto });
}