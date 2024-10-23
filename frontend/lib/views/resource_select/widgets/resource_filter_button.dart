import 'package:flutter/material.dart';
import 'package:frontend/utils/resources_name_mapping.dart';
import 'package:frontend/views/resource_select/widgets/resource_filter_list_tile.dart';

class ResourceFilterButton extends StatefulWidget {
  final ResourceSetting resourceSetting;
  const ResourceFilterButton({super.key, required this.resourceSetting});

  @override
  State<ResourceFilterButton> createState() => _ResourceFilterButtonState();
}

class _ResourceFilterButtonState extends State<ResourceFilterButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent, // 배경을 투명하게 설정
          context: context,
          builder: (context) => Container(
            color: Colors.blueGrey[100], // BottomSheet의 배경 색상 변경
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.resourceSetting.columnsToDisplay
                  .map((c) => ResourceFilterListTile(column: c))
                  .toList(),
            ),
          ),
        );
      },
      icon: const Icon(Icons.filter_list),
    );
  }
}
