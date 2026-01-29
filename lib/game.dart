import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

import 'grid.dart';

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
  List<List<Cell>>? puzzled;

  void generateGrid() {
    {
      PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "winter");
      Puzzle puzzle = Puzzle(puzzleOptions);
      puzzle.generate().then((_) {
        puzzled = puzzle.board()?.matrix();
      });
    }
  }

  void setGrid() {
    setState(() {
      generateGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();
    setGrid();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 3 * boxSize,
              height: width,
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
                        var xp = ((x ~/ 3)) * 3 + ((y ~/ 3));
                        var yp = (x % 3) * 3 + (y % 3);
                        return InnerGrid(
                            s: puzzled?[xp][yp].getValue(), bx: boxSize);
                      }),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
