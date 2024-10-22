import 'package:flutter/material.dart';
import 'package:frontend/utils/resources_name_mapping.dart';

class ResourceSelectView extends StatefulWidget {
  static const routeName = "resource-select";

  final ResourceName resourceName;

  const ResourceSelectView({super.key, required this.resourceName});

  @override
  State<ResourceSelectView> createState() => _ResourceSelectViewState();
}

class _ResourceSelectViewState extends State<ResourceSelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resourceName.showName),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
