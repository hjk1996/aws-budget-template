import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_select_event.freezed.dart';

@freezed
abstract class ResourceSelectEvent with _$ResourceSelectEvent {
  const factory ResourceSelectEvent.error(String e) =
      ResourceSelectEventError;
}
