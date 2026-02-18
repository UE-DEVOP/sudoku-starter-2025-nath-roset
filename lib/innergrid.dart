import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InnerGrid extends StatefulWidget {
  final Position position;
  final double sz;

  // int? value = 0;
  final ValueChanged<Position?> onSelected;
  final Puzzle? model;

  const InnerGrid(
      {super.key,
      required this.model,
      required this.position,
      required this.sz,
      // required this.value,
      required this.onSelected});

  @override
  State<InnerGrid> createState() => _InnerGridState();
}

class _InnerGridState extends State<InnerGrid> {
  bool _selected = false;

  void _handleTap() {
    setState(() {
      _selected = !_selected;
    });
    if (_selected) {
      widget.onSelected(widget.position);
    } else {
      widget.onSelected(null);
    }
  }

  Text _getValueFromModel() {
    var rowVal = widget.position.grid!.x.toInt();
    var colVar = widget.position.grid!.y.toInt();
    int? val = widget.model?.board()?.matrix()![rowVal][colVar].getValue();
    if (val != 0) {
      return Text(val.toString());
    } else {
      val = widget.model?.solvedBoard()?.matrix()![rowVal][colVar].getValue();
      return Text(val.toString(),
          style: const TextStyle(color: Colors.black12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.sz,
        height: widget.sz,
        decoration: BoxDecoration(
          color: _selected
              ? Colors.blueAccent.shade100.withAlpha(100)
              : Colors.transparent,
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: InkWell(
            onTap: _handleTap,
            child: Center(
              child: _getValueFromModel(),
            )));
  }

  @override
  String toString({DiagnosticLevel? minLevel}) {
    return 'InnerGrid{value: yes, position: ${widget.position.grid}, isSelected: ${_selected}';
  }
}
