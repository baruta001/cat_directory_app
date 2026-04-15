// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cat_breeds_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatBreedsState {

 List<CatBreed> get breeds; bool get isLoading; bool get isLoadingMore; bool get hasReachedMax; int get currentPage; String? get errorMessage;
/// Create a copy of CatBreedsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatBreedsStateCopyWith<CatBreedsState> get copyWith => _$CatBreedsStateCopyWithImpl<CatBreedsState>(this as CatBreedsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatBreedsState&&const DeepCollectionEquality().equals(other.breeds, breeds)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(breeds),isLoading,isLoadingMore,hasReachedMax,currentPage,errorMessage);

@override
String toString() {
  return 'CatBreedsState(breeds: $breeds, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasReachedMax: $hasReachedMax, currentPage: $currentPage, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CatBreedsStateCopyWith<$Res>  {
  factory $CatBreedsStateCopyWith(CatBreedsState value, $Res Function(CatBreedsState) _then) = _$CatBreedsStateCopyWithImpl;
@useResult
$Res call({
 List<CatBreed> breeds, bool isLoading, bool isLoadingMore, bool hasReachedMax, int currentPage, String? errorMessage
});




}
/// @nodoc
class _$CatBreedsStateCopyWithImpl<$Res>
    implements $CatBreedsStateCopyWith<$Res> {
  _$CatBreedsStateCopyWithImpl(this._self, this._then);

  final CatBreedsState _self;
  final $Res Function(CatBreedsState) _then;

/// Create a copy of CatBreedsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breeds = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasReachedMax = null,Object? currentPage = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
breeds: null == breeds ? _self.breeds : breeds // ignore: cast_nullable_to_non_nullable
as List<CatBreed>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CatBreedsState].
extension CatBreedsStatePatterns on CatBreedsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatBreedsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatBreedsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatBreedsState value)  $default,){
final _that = this;
switch (_that) {
case _CatBreedsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatBreedsState value)?  $default,){
final _that = this;
switch (_that) {
case _CatBreedsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CatBreed> breeds,  bool isLoading,  bool isLoadingMore,  bool hasReachedMax,  int currentPage,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatBreedsState() when $default != null:
return $default(_that.breeds,_that.isLoading,_that.isLoadingMore,_that.hasReachedMax,_that.currentPage,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CatBreed> breeds,  bool isLoading,  bool isLoadingMore,  bool hasReachedMax,  int currentPage,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CatBreedsState():
return $default(_that.breeds,_that.isLoading,_that.isLoadingMore,_that.hasReachedMax,_that.currentPage,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CatBreed> breeds,  bool isLoading,  bool isLoadingMore,  bool hasReachedMax,  int currentPage,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CatBreedsState() when $default != null:
return $default(_that.breeds,_that.isLoading,_that.isLoadingMore,_that.hasReachedMax,_that.currentPage,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CatBreedsState implements CatBreedsState {
  const _CatBreedsState({final  List<CatBreed> breeds = const [], this.isLoading = false, this.isLoadingMore = false, this.hasReachedMax = false, this.currentPage = 1, this.errorMessage}): _breeds = breeds;
  

 final  List<CatBreed> _breeds;
@override@JsonKey() List<CatBreed> get breeds {
  if (_breeds is EqualUnmodifiableListView) return _breeds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breeds);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasReachedMax;
@override@JsonKey() final  int currentPage;
@override final  String? errorMessage;

/// Create a copy of CatBreedsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatBreedsStateCopyWith<_CatBreedsState> get copyWith => __$CatBreedsStateCopyWithImpl<_CatBreedsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatBreedsState&&const DeepCollectionEquality().equals(other._breeds, _breeds)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_breeds),isLoading,isLoadingMore,hasReachedMax,currentPage,errorMessage);

@override
String toString() {
  return 'CatBreedsState(breeds: $breeds, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasReachedMax: $hasReachedMax, currentPage: $currentPage, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CatBreedsStateCopyWith<$Res> implements $CatBreedsStateCopyWith<$Res> {
  factory _$CatBreedsStateCopyWith(_CatBreedsState value, $Res Function(_CatBreedsState) _then) = __$CatBreedsStateCopyWithImpl;
@override @useResult
$Res call({
 List<CatBreed> breeds, bool isLoading, bool isLoadingMore, bool hasReachedMax, int currentPage, String? errorMessage
});




}
/// @nodoc
class __$CatBreedsStateCopyWithImpl<$Res>
    implements _$CatBreedsStateCopyWith<$Res> {
  __$CatBreedsStateCopyWithImpl(this._self, this._then);

  final _CatBreedsState _self;
  final $Res Function(_CatBreedsState) _then;

/// Create a copy of CatBreedsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breeds = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasReachedMax = null,Object? currentPage = null,Object? errorMessage = freezed,}) {
  return _then(_CatBreedsState(
breeds: null == breeds ? _self._breeds : breeds // ignore: cast_nullable_to_non_nullable
as List<CatBreed>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
