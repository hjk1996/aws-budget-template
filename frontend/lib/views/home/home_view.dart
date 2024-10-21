import 'package:flutter/material.dart';
import 'package:frontend/views/resource_list/resource_list_view.dart';

class HomewView extends StatefulWidget {
  const HomewView({super.key});

  @override
  State<HomewView> createState() => _HomewViewState();
}

class _HomewViewState extends State<HomewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ResourceListView.routeName),
              child: const Text("새로운 AWS Cloud 예산 생성"),
            )
          ],
        ),
      ),
    );
  }
}
