import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InnerGrid extends StatelessWidget {
  int? value = 0;
  final Position position;
  final double sz;
  bool isSelected = false;

  InnerGrid(
      {super.key,
      required this.value,
      required this.position,
      required this.sz,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.shade100.withAlpha(100)
              : Colors.transparent,
          border: Border.all(color: Colors.black, width: 0.3),
        ),
        child: InkWell(
          onTap: () => {log(toString())},
          child: Center(
              child: Text(value == 0 || value == null ? "" : value.toString())),
        ));
  }

  @override
  String toString({DiagnosticLevel? minLevel}) {
    return 'InnerGrid{value: $value, position: ${position.grid}, isSelected: $isSelected}';
  }
}
