import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// [CustomGrid]
///
/// Componente de Stepper Customizavel
class CustomGrid extends StatelessWidget {
  final int? columns;
  final List<Widget> content;
  final double? spacing;

  const CustomGrid(
      {Key? key, this.columns, this.spacing = 16.0, required this.content})
      : super(key: key);

  _contentView() {
    if (columns != null && columns! > 0) {
      return StaggeredGrid.count(
          crossAxisCount: columns!,
          mainAxisSpacing: spacing!,
          crossAxisSpacing: spacing!,
          children: content);
    } else {
      return Wrap(spacing: spacing!, runSpacing: spacing!, children: content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _contentView());
  }
}

/// [GridItem]
///
/// Componente que agrupa uma label e um value em uma Column.
///
/// Normalmente utilizado em conjunto com [CustomGrid] e [CustomExpansionTile].
class GridItem extends StatelessWidget {
  const GridItem({
    Key? key,
    required this.label,
    required this.value,
    this.labelStyle = const TextStyle(
      fontSize: 11,
      color: Color.fromRGBO(164, 164, 172, 1),
    ),
    this.valueStyle = const TextStyle(
      fontSize: 14,
      color: Color.fromRGBO(0, 0, 17, 1),
    ),
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  }) : super(key: key);

  /// Texto acima do [value].
  final String label;

  /// Texto abaixo do [label].
  final String value;

  /// Estilização do [label].
  final TextStyle? labelStyle;

  /// Estilização do [value].
  final TextStyle? valueStyle;

  /// Padding do conteúdo como um todo.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
