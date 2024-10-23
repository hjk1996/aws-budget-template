import 'package:dio/dio.dart';
import 'package:frontend/data/dynamodb_repository.dart';
import 'package:frontend/viewmodels/resource_select_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<ChangeNotifierProvider> providers = [];

Future<List<ChangeNotifierProvider>> initProviders() async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  final dynamodb = DynamodbRepository(dio: dio, prefs: prefs);
  final resourceSelectViewmodel = ResourceSelectViewModel(repository: dynamodb);
  final resourceSelectProvider =
      ChangeNotifierProvider(create: (context) => resourceSelectViewmodel);

  return [
    resourceSelectProvider,
  ];
}
