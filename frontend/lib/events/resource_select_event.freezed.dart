// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resource_select_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResourceSelectEvent {
  String get e => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String e) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String e)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String e)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResourceSelectEventError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResourceSelectEventError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResourceSelectEventError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ResourceSelectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResourceSelectEventCopyWith<ResourceSelectEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResourceSelectEventCopyWith<$Res> {
  factory $ResourceSelectEventCopyWith(
          ResourceSelectEvent value, $Res Function(ResourceSelectEvent) then) =
      _$ResourceSelectEventCopyWithImpl<$Res, ResourceSelectEvent>;
  @useResult
  $Res call({String e});
}

/// @nodoc
class _$ResourceSelectEventCopyWithImpl<$Res, $Val extends ResourceSelectEvent>
    implements $ResourceSelectEventCopyWith<$Res> {
  _$ResourceSelectEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResourceSelectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? e = null,
  }) {
    return _then(_value.copyWith(
      e: null == e
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResourceSelectEventErrorImplCopyWith<$Res>
    implements $ResourceSelectEventCopyWith<$Res> {
  factory _$$ResourceSelectEventErrorImplCopyWith(
          _$ResourceSelectEventErrorImpl value,
          $Res Function(_$ResourceSelectEventErrorImpl) then) =
      __$$ResourceSelectEventErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String e});
}

/// @nodoc
class __$$ResourceSelectEventErrorImplCopyWithImpl<$Res>
    extends _$ResourceSelectEventCopyWithImpl<$Res,
        _$ResourceSelectEventErrorImpl>
    implements _$$ResourceSelectEventErrorImplCopyWith<$Res> {
  __$$ResourceSelectEventErrorImplCopyWithImpl(
      _$ResourceSelectEventErrorImpl _value,
      $Res Function(_$ResourceSelectEventErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResourceSelectEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? e = null,
  }) {
    return _then(_$ResourceSelectEventErrorImpl(
      null == e
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ResourceSelectEventErrorImpl implements ResourceSelectEventError {
  const _$ResourceSelectEventErrorImpl(this.e);

  @override
  final String e;

  @override
  String toString() {
    return 'ResourceSelectEvent.error(e: $e)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResourceSelectEventErrorImpl &&
            (identical(other.e, e) || other.e == e));
  }

  @override
  int get hashCode => Object.hash(runtimeType, e);

  /// Create a copy of ResourceSelectEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResourceSelectEventErrorImplCopyWith<_$ResourceSelectEventErrorImpl>
      get copyWith => __$$ResourceSelectEventErrorImplCopyWithImpl<
          _$ResourceSelectEventErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String e) error,
  }) {
    return error(e);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String e)? error,
  }) {
    return error?.call(e);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String e)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(e);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResourceSelectEventError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResourceSelectEventError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResourceSelectEventError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ResourceSelectEventError implements ResourceSelectEvent {
  const factory ResourceSelectEventError(final String e) =
      _$ResourceSelectEventErrorImpl;

  @override
  String get e;

  /// Create a copy of ResourceSelectEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResourceSelectEventErrorImplCopyWith<_$ResourceSelectEventErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
