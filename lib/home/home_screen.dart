import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _emojis = ['🍎', '🚗', '🐶', '🎲', '🚀', '🎵', '🍕', '🐱'];

  List<_CardModel> _cards = [];

  List<int> _selectedIndices = [];


  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final fullList = List<String>.from(_emojis)..addAll(_emojis);
    fullList.shuffle(Random());
    _cards = fullList.map((e) => _CardModel(value: e)).toList();
    setState(() {});
  }

  void _onCardTap(int index) {
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      final first = _cards[_selectedIndices[0]];
      final second = _cards[_selectedIndices[1]];

      if (first.value == second.value) {
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
    final gridSize = 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Memória'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
                  card.isFlipped || card.isMatched ? card.value : '',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _initializeCards,
        tooltip: "Reiniciar",
      ),
    );
  }
}

class _CardModel {
  final String value;
  bool isFlipped = false;
  bool isMatched = false;

  _CardModel({required this.value});
}