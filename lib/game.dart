import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

import 'innergrid.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Grid? _puzzled;
  Position? _caseSelected;

  _GameState() {
    generateGrid();
  }

  void updateValue(int val) {
    setState(() {
      if (_caseSelected != null) {
        log(_caseSelected!.grid!.toString());
        _puzzled!.cellAt(_caseSelected!).setValue(val);
      }
    });
  }

  void _handleInnerGridTap(Position? newState) {
    setState(() {
      _caseSelected = newState;
    });
  }

  void generateGrid() {
    {
      PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "winter");
      Puzzle puzzle = Puzzle(puzzleOptions);
      puzzle.generate().then((_) {
        setState(() {
          _puzzled = puzzle.board();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).floor().toDouble();
    rowBuilder({required int begin, required int offset}) =>
        List.generate(begin, (x) {
          var v = x + offset;
          return ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(Colors.blueAccent),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white)),
              onPressed: () => updateValue(v),
              child: Text((v).toString()));
        });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: <Widget>[
            SizedBox(
              width: 3 * boxSize,
              height: maxSize,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (x) {
                  return Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(9, (y) {
                        var colVar = (x % 3) * 3 + (y % 3);
                        var rowVar = ((x ~/ 3)) * 3 + ((y ~/ 3));
                        var pos = Position(row: rowVar, column: colVar);
                        return InnerGrid(
                          value: _puzzled?.matrix()![rowVar][colVar].getValue(),
                          position: pos,
                          sz: boxSize,
                          onSelected: _handleInnerGridTap,
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: boxSize / 3,
                children: rowBuilder(begin: 5, offset: 1)),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: boxSize / 3,
                children: rowBuilder(begin: 4, offset: 6))
          ],
        ),
      ),
    );
  }
}
