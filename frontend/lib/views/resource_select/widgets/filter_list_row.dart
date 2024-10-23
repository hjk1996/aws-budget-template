import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/resource_select_viewmodel.dart';
import 'package:provider/provider.dart';

class FilterListRow extends StatefulWidget {
  const FilterListRow({super.key});

  @override
  State<FilterListRow> createState() => _FilterListRowState();
}

class _FilterListRowState extends State<FilterListRow> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceSelectViewModel>(
      builder: (context, vm, child) => SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 횡스크롤 가능하도록 설정
        child: Row(
          children: vm.filterConditions.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Chip(
                label: Text('${entry.key}: ${entry.value}'),
                deleteIcon: const Icon(Icons.cancel),
                onDeleted: () {
                  vm.setFilterCondition(entry.key, null);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
