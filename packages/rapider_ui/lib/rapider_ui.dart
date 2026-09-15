import 'package:flutter/material.dart';

// Basic UI component stubs for POC
class RapiderCard extends StatelessWidget {
  final Widget child;
  const RapiderCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}

class RapiderButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const RapiderButton({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class RapiderDataGrid extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final void Function(int rowIndex)? onRowTap;

  const RapiderDataGrid({
    super.key, 
    required this.columns, 
    required this.rows,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
      rows: rows.asMap().entries.map((entry) {
        final idx = entry.key;
        final row = entry.value;
        return DataRow(
          cells: row.map((c) => DataCell(
            Text(c), 
            onTap: onRowTap != null ? () => onRowTap!(idx) : null
          )).toList(),
        );
      }).toList(),
    );
  }
}
