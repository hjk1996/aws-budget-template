import 'dart:async';

import 'package:frontend/viewmodels/resource_select_viewmodel.dart';
import 'package:frontend/views/resource_select/widgets/filter_list_row.dart';
import 'package:frontend/views/resource_select/widgets/resource_filter_button.dart';
import 'package:frontend/views/resource_select/widgets/resource_table.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/events/resource_select_event.dart';
import 'package:frontend/utils/resources_name_mapping.dart';

class ResourceSelectView extends StatefulWidget {
  static const routeName = "resource-select";

  final ResourceSetting resourceSetting;
  const ResourceSelectView({super.key, required this.resourceSetting});

  @override
  State<ResourceSelectView> createState() => _ResourceSelectViewState();
}

class _ResourceSelectViewState extends State<ResourceSelectView> {
  late final StreamSubscription<ResourceSelectEvent>? _eventSubscription;
  int? selectedIndex; // 선택된 행을 추적하기 위한 변수 (단일 선택)

  @override
  void initState() {
    super.initState();
    _eventSubscription =
        context.read<ResourceSelectViewModel>().eventController.stream.listen(
      (event) {
        event.whenOrNull(
          error: (e) {
            _showErrorSnackbar(context, e);
          },
        );
      },
    );

    context.read<ResourceSelectViewModel>().resourceSetting =
        widget.resourceSetting;
  }

  void _showErrorSnackbar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red, // 에러 메시지일 때 빨간색 배경
      duration: const Duration(seconds: 3), // 3초 후에 사라짐
    );

    // SnackBar를 ScaffoldMessenger를 통해 화면에 표시
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resourceSetting.showName),
      ),
      floatingActionButton: ResourceFilterButton(
        resourceSetting: widget.resourceSetting,
      ),
      body: FutureBuilder<void>(
        future: context
            .read<ResourceSelectViewModel>()
            .fetchResources(widget.resourceSetting.fieldValue),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // 로딩 중일 때 스피너 표시
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'), // 에러 발생 시 표시
            );
          }

          return Column(
            children: [
              const FilterListRow(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child:
                        ResourceTable(resourceSetting: widget.resourceSetting),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
