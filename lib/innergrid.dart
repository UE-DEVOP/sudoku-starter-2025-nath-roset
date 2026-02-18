import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InnerGrid extends StatefulWidget {
  final Position position;
  int? value = 0;
  final double sz;
  final ValueChanged<Position?> onSelected;

  InnerGrid(
      {super.key,
      required this.position,
      required this.sz,
      required this.value,
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
              child: Text(widget.value == 0 || widget.value == null
                  ? ""
                  : widget.value.toString())),
        ));
  }

  @override
  String toString({DiagnosticLevel? minLevel}) {
    return 'InnerGrid{value: ${widget.value}, position: ${widget.position.grid}, isSelected: ${_selected}';
  }
}
