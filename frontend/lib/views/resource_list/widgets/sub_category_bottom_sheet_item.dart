import 'package:flutter/material.dart';
import 'package:frontend/utils/resources_name_mapping.dart';
import 'package:frontend/views/resource_select/resource_select_view.dart';

class SubCategoryBottomSheetListItem extends StatelessWidget {
  final ResourceName resourceName;
  const SubCategoryBottomSheetListItem({super.key, required this.resourceName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
          "assets/icons/${resourceName.showName.toLowerCase()}.png"),
      title: Text(resourceName.showName),
      onTap: () {
        Navigator.pop(context); // 팝업 닫기
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceSelectView(
                resourceName: resourceName,
              ),
            ));
      },
    );
  }
}
