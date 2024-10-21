import 'package:flutter/material.dart';

class ResourceSelectView extends StatefulWidget {
  static const routeName = "resource-select";

  final String subCategory;

  const ResourceSelectView({super.key, required this.subCategory});

  @override
  State<ResourceSelectView> createState() => _ResourceSelectViewState();
}

class _ResourceSelectViewState extends State<ResourceSelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
