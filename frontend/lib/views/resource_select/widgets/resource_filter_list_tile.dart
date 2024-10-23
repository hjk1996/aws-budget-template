import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/resource_select_viewmodel.dart';
import 'package:frontend/views/resource_select/resource_select_view.dart';
import 'package:provider/provider.dart';

class ResourceFilterListTile extends StatefulWidget {
  final String column;
  const ResourceFilterListTile({super.key, required this.column});

  @override
  State<ResourceFilterListTile> createState() => _ResourceFilterListTileState();
}

class _ResourceFilterListTileState extends State<ResourceFilterListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.column,
        textAlign: TextAlign.center, // 텍스트를 중간에 정렬
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () async {
        String? filterValue;

        final uniqueCount = context
            .read<ResourceSelectViewModel>()
            .columnUniqueCounts[widget.column];

        filterValue = await showDialog(
          context: context,
          builder: (context) => uniqueCount! < 20
              ? SelectionDialog(column: widget.column)
              : InputDialog(column: widget.column),
        );

        context
            .read<ResourceSelectViewModel>()
            .setFilterCondition(widget.column, filterValue);

        Navigator.of(context).pop(widget.column);
      },
    );
  }
}

class InputDialog extends StatefulWidget {
  final String column;
  const InputDialog({super.key, required this.column});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  String? inputValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter value for ${widget.column}'),
      content: TextField(
        onChanged: (value) {
          inputValue = value; // 입력된 값을 저장
        },
        decoration: const InputDecoration(
          hintText: 'Enter a value',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 팝업 닫기
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(inputValue); // 팝업 닫기
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class SelectionDialog extends StatelessWidget {
  final String column;

  const SelectionDialog({super.key, required this.column});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceSelectViewModel>(
      builder: (context, vm, child) {
        return AlertDialog(
          title: Text('Select a value for $column'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: vm.columnUniqueValues[column]!.map((value) {
                return ListTile(
                  title: Text(value),
                  onTap: () {
                    Navigator.of(context).pop(value); // 팝업 닫기
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
