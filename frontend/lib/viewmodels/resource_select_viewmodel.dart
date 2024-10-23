import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/dynamodb_repository.dart';
import 'package:frontend/events/resource_select_event.dart';
import 'package:frontend/utils/resources_name_mapping.dart';

class ResourceSelectViewModel extends ChangeNotifier {
  late final DynamodbRepository _repo;
  ResourceSelectViewModel({required DynamodbRepository repository}) {
    _repo = repository;
  }

  final StreamController<ResourceSelectEvent> _eventcontroller =
      StreamController<ResourceSelectEvent>.broadcast();

  StreamController<ResourceSelectEvent> get eventController => _eventcontroller;

  List<Object> _resourceList = [];
  List<Object> get resourceList => _resourceList;

  List<Object> _filteredResourceList = [];
  List<Object> get filteredResourceList => _filteredResourceList;

  ResourceSetting? _resourceSetting;
  // resourceSetting의 getter
  ResourceSetting? get resourceSetting => _resourceSetting;
  // resourceSetting의 setter
  set resourceSetting(ResourceSetting? newSetting) {
    _resourceSetting = newSetting;
  }

  int? _visibleSelectedIndex;
  int? get visibleSelectedIndex => _visibleSelectedIndex;
  set visibleSelectedIndex(int? index) {
    _visibleSelectedIndex = index;
    print(_visibleSelectedIndex);
    notifyListeners();
  }

  int? _absoluteIndex;
  int? get absoluteIndex => absoluteIndex;

  Map<String, int> columnUniqueCounts = {}; // 컬럼별 고유 값의 수를 저장하는 Map
  Map<String, List<String>> columnUniqueValues = {};

  Map<String, dynamic> _filterConditions = {}; // 여러 필터 조건을 저장
  Map<String, dynamic> get filterConditions =>
      _filterConditions; // 여러 필터 조건을 저장

  void setFilterCondition(String key, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      _filterConditions.remove(key); // 필터 값이 없으면 해당 조건 제거
    } else {
      _filterConditions[key] = value; // 필터 조건을 추가 또는 업데이트
    }
    _applyFilter();
    notifyListeners();
  }

  // 필터링 로직
  void _applyFilter() {
    if (_filterConditions.isEmpty) {
      _filteredResourceList = _resourceList; // 필터가 없을 때는 전체 데이터를 표시
    } else {
      _filteredResourceList = _resourceList.where((item) {
        final mapItem = item as Map<String, dynamic>;

        // 모든 필터 조건을 확인하여 일치하는지 체크
        return _filterConditions.entries.every((condition) {
          final key = condition.key;

          final numItemValue = num.tryParse(mapItem[key]!.toString());

          final numVal = num.tryParse(condition.value);

          if (numVal != null && numItemValue != null) {
            return numItemValue == numVal;
          } else {
            final filterValue = condition.value.toString().toLowerCase();
            final itemValue = mapItem[key]?.toString().toLowerCase() ?? '';
            return itemValue.contains(filterValue); // 필터 조건을 만족하는지 확인
          }
        });
      }).toList();
    }
  }

  // 각 컬럼의 고유 값 개수를 계산하는 함수
  void _calculateUniqueValueCounts() {
    Map<String, Set<dynamic>> uniqueValueSets = {}; // 각 컬럼의 고유 값 집합을 저장

    // 각 항목을 순회하면서 컬럼별 고유 값 집합을 생성
    for (var item in _resourceList) {
      final mapItem = item as Map<String, dynamic>;

      mapItem.forEach((key, value) {
        if (value != null) {
          // 각 컬럼별로 고유 값 집합을 관리
          uniqueValueSets.putIfAbsent(key, () => <dynamic>{});
          uniqueValueSets[key]!.add(value);
        }
      });
    }

    // 각 컬럼별 고유 값의 수를 계산하여 저장하고, 20개 미만일 경우 columnUniqueValues에 저장
    columnUniqueCounts = uniqueValueSets.map((key, value) {
      int uniqueCount = value.length;
      if (uniqueCount < 20) {
        columnUniqueValues[key] = value.map((v) => v.toString()).toList()
          ..sort((a, b) {
            // 숫자로 변환할 수 있으면 숫자로 비교, 아니면 문자열 비교
            final numA = num.tryParse(a);
            final numB = num.tryParse(b);
            if (numA != null && numB != null) {
              return numA.compareTo(numB); // 숫자 비교
            } else {
              return a.compareTo(b); // 문자열 비교
            }
          }); // 20개 미만일 경우 고유 값을 저장
      } else {
        columnUniqueValues.remove(key); // 20개 이상인 경우 값 삭제 (필요 없는 경우)
      }
      return MapEntry(key, uniqueCount);
    });
  }

  void _sortResourceList(List<String> columnOrder) {
    _resourceList.sort((a, b) {
      final mapA = a as Map<String, dynamic>;
      final mapB = b as Map<String, dynamic>;

      // 각 컬럼 기준으로 우선 순위 정렬 수행
      for (var column in columnOrder) {
        final valueA = mapA[column];
        final valueB = mapB[column];

        if (valueA is Comparable && valueB is Comparable) {
          final comparison = valueA.compareTo(valueB);
          if (comparison != 0) {
            return comparison; // 이 컬럼에서 정렬 결정이 내려지면 그 결과 반환
          }
        }
      }
      return 0; // 모든 컬럼의 값이 같으면 0 반환 (동일함)
    });
  }

  Future<void> fetchResources(String resourceName) async {
    final result = await _repo.fetchResources(resourceName);
    result.fold((error) {
      _eventcontroller.sink.add(ResourceSelectEvent.error(error.message));
    }, (data) {
      _resourceList = data;
      _sortResourceList(resourceSetting!.sortOrder);
      _calculateUniqueValueCounts(); // 데이터를 가져온 후 고유 값 개수 계산
    });
    notifyListeners();
  }
}
