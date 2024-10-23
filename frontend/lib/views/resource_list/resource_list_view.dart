import 'package:flutter/material.dart';
import 'package:frontend/utils/resources_name_mapping.dart';
import 'package:frontend/views/resource_list/widgets/sub_category_list.dart';

class ResourceListView extends StatefulWidget {
  static const routeName = "resource_list";

  const ResourceListView({super.key});

  @override
  State<ResourceListView> createState() => _ResourceListViewState();
}

class _ResourceListViewState extends State<ResourceListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: const [
            SubCategoryListWidget(
              mainCategory: "Computing",
              subCategoryList: ResouresNameMapping.computing,
            ),
            SubCategoryListWidget(
              mainCategory: "Backing",
              subCategoryList: ResouresNameMapping.backing,
            ),
          ],
        ),
      ),
    );
  }
}
