import 'package:flutter/material.dart';
import 'package:frontend/utils/resources_name_mapping.dart';
import 'package:frontend/views/resource_list/widgets/sub_category_bottom_sheet_item.dart';

class SubCategoryListWidget extends StatefulWidget {
  final String mainCategory;
  final List<ResourceSetting> subCategoryList;

  const SubCategoryListWidget(
      {super.key, required this.mainCategory, required this.subCategoryList});

  @override
  State<SubCategoryListWidget> createState() => _SubCategoryListWidgetState();
}

class _SubCategoryListWidgetState extends State<SubCategoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4, // 카드에 그림자 추가
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 둥근 모서리 적용
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.mainCategory,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // 텍스트를 굵게
                  color: Colors.black87, // 색상 변경
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 아이콘 버튼을 원형으로
                  color: Colors.blue, // 배경색 추가
                ),
                child: IconButton(
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.subCategoryList.map((resourceName) {
                          return SubCategoryBottomSheetListItem(
                              resourceName: resourceName);
                        }).toList(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.white, // 아이콘 색상을 흰색으로 변경
                  iconSize: 28, // 아이콘 크기 약간 조정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
