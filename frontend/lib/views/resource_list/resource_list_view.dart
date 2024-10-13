import 'package:flutter/material.dart';

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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
    );
  }
}
