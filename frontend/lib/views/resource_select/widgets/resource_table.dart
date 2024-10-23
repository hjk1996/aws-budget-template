import 'package:flutter/material.dart';
import 'package:frontend/utils/resources_name_mapping.dart';
import 'package:frontend/viewmodels/resource_select_viewmodel.dart';
import 'package:provider/provider.dart';

class ResourceTable extends StatefulWidget {
  final ResourceSetting resourceSetting;
  const ResourceTable({super.key, required this.resourceSetting});

  @override
  State<ResourceTable> createState() => _ResourceTableState();
}

class _ResourceTableState extends State<ResourceTable> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceSelectViewModel>(
      builder: (context, vm, child) {
        return PaginatedDataTable(
          columns: [
            for (var c in widget.resourceSetting.columnsToDisplay)
              DataColumn(
                label: Text(
                  c,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // 컬럼 헤더의 색상 설정
                  ),
                ),
              ),
          ],
          source: _DataSource(
            context: context,
            resourceList: vm.filterConditions.isEmpty
                ? vm.resourceList
                : vm.filteredResourceList,
            columnsToDisplay: widget.resourceSetting.columnsToDisplay,
            selectedIndex: vm.visibleSelectedIndex,
            onSelectChanged: (index, selected) {
              vm.visibleSelectedIndex = selected == true ? index : null;
            },
          ),
          rowsPerPage: 10, // 한 페이지에 표시할 행 수
        );
      },
    );
  }
}

// DataSource 클래스를 사용해 데이터와 상태를 관리
class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<dynamic> resourceList;
  final List<String> columnsToDisplay;
  final int? selectedIndex;
  final void Function(int index, bool? selected) onSelectChanged;

  _DataSource({
    required this.context,
    required this.resourceList,
    required this.columnsToDisplay,
    required this.selectedIndex,
    required this.onSelectChanged,
  });

  @override
  DataRow getRow(int index) {
    final mapItem = resourceList[index] as Map<String, dynamic>;

    return DataRow(
      selected: selectedIndex == index, // 단일 선택 관리
      onSelectChanged: (bool? selected) {
        onSelectChanged(index, selected);
      },
      cells: columnsToDisplay.map((columnKey) {
        final cellValue = mapItem[columnKey];
        return DataCell(Text(cellValue != null ? cellValue.toString() : 'N/A'));
      }).toList(),
    );
  }

  @override
  int get rowCount => resourceList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedIndex != null ? 1 : 0;
}
