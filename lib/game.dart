import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  Point<int>? _caseSelected;
  Puzzle _puzzle = Puzzle(PuzzleOptions(patternName: "winter"));
  bool _isInit = false;

  _GameState() {
    generateGrid();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).floor().toDouble();
    if (!_isInit) {
      _puzzle.generate().then((_) => setState(() {
            _isInit = true;
          }));
    }
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
                        var rowY = (x % 3) * 3 + (y % 3);
                        var colX = ((x ~/ 3)) * 3 + ((y ~/ 3));
                        return InnerGrid(
                          sz: boxSize / 3,
                          selected: _caseSelected != null &&
                              _caseSelected!.x == colX &&
                              _caseSelected!.y == rowY,
                          value:
                              "${_puzzle.board()?.matrix()?[colX][rowY].getValue()}",
                          hint:
                              "${_puzzle.solvedBoard()?.matrix()?[colX][rowY].getValue()}",
                          onSelected: () => setState(() {
                            _caseSelected = Point(colX, rowY);
                          }),
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
                children: rowBuilder(begin: 4, offset: 6)),
            ElevatedButton(
              onPressed: resolve,
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.amber)),
              child: const Text("Resolve"),
            )
          ],
        ),
      ),
    );
  }

  void updateValue(int guess) {
    setState(() {
      if (_caseSelected != null) {
        var rightValue = _puzzle
            .solvedBoard()!
            .matrix()?[_caseSelected!.x][_caseSelected!.y]
            .getValue();
        if (guess != rightValue) {
          const snackBar = SnackBar(
            /// need to set following properties for best effect of awesome_snackbar_content
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              message: "Please try another one",
              title: 'Wrong value',
              contentType: ContentType.warning,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else {
          _puzzle
              .board()
              ?.matrix()?[_caseSelected!.x][_caseSelected!.y]
              .setValue(guess);
        }
      }
    });
    checkGameSolved();
  }

  void generateGrid() {
    {
      PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "winter");
      var puzzle = Puzzle(puzzleOptions);
      puzzle.generate().then((_) => setState(() {
            _puzzle = puzzle;
          }));
    }
  }

  void checkGameSolved() {
    for (int i = 0; i < 9 * 9; i++) {
      if (_puzzle.board()!.cellAt(Position(index: i)).getValue() !=
          _puzzle.solvedBoard()!.cellAt(Position(index: i)).getValue()) {
        return;
      }
    }
    context.go("/end");
  }

  void resolve() {
    setState(() {
      for (int i = 0; i < 9 * 9; i++) {
        _puzzle.board()!.cellAt(Position(index: i)).setValue(
            _puzzle.solvedBoard()!.cellAt(Position(index: i)).getValue());
      }
    });
    checkGameSolved();
  }
}
