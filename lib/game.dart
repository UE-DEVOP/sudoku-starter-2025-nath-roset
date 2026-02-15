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
  Grid? puzzled;
  InnerGrid? selected;

  _GameState() {
    generateGrid();
  }

  void generateGrid() {
    {
      PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "winter");
      Puzzle puzzle = Puzzle(puzzleOptions);
      puzzle.generate().then((_) {
        setState(() {
          puzzled = puzzle.board();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();
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
                        var xp = ((x ~/ 3)) * 3 + ((y ~/ 3));
                        var yp = (x % 3) * 3 + (y % 3);
                        return InnerGrid(
                          value: puzzled?.matrix()![xp][yp].getValue(),
                          position: Position(row: yp, column: xp),
                          sz: boxSize,
                          isSelected: false,
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
                children: List.generate(5, (x) {
                  var v = x + 1;
                  return ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.blueAccent),
                          foregroundColor:
                              WidgetStatePropertyAll<Color>(Colors.white)),
                      onPressed: () {
                        selected = InnerGrid(
                            value: v,
                            position: selected!.position,
                            sz: boxSize,
                            isSelected: false);
                      },
                      child: Text((v).toString()));
                })),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 50.0,
                children: List.generate(4, (x) {
                  var v = x + 6;
                  return ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.blueAccent),
                          foregroundColor:
                              WidgetStatePropertyAll<Color>(Colors.white)),
                      onPressed: () {
                        selected = InnerGrid(
                            value: v,
                            position: selected!.position,
                            sz: boxSize,
                            isSelected: false);
                      },
                      child: Text((v).toString()));
                }))
          ],
        ),
      ),
    );
  }
}
