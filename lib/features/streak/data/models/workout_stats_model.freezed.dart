// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutStats {

 int get currentStreak; int get longestStreak; int get thisWeekCount; int get totalWorkouts; Set<DateTime> get workoutDates;
/// Create a copy of WorkoutStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutStatsCopyWith<WorkoutStats> get copyWith => _$WorkoutStatsCopyWithImpl<WorkoutStats>(this as WorkoutStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.thisWeekCount, thisWeekCount) || other.thisWeekCount == thisWeekCount)&&(identical(other.totalWorkouts, totalWorkouts) || other.totalWorkouts == totalWorkouts)&&const DeepCollectionEquality().equals(other.workoutDates, workoutDates));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,thisWeekCount,totalWorkouts,const DeepCollectionEquality().hash(workoutDates));

@override
String toString() {
  return 'WorkoutStats(currentStreak: $currentStreak, longestStreak: $longestStreak, thisWeekCount: $thisWeekCount, totalWorkouts: $totalWorkouts, workoutDates: $workoutDates)';
}


}

/// @nodoc
abstract mixin class $WorkoutStatsCopyWith<$Res>  {
  factory $WorkoutStatsCopyWith(WorkoutStats value, $Res Function(WorkoutStats) _then) = _$WorkoutStatsCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int longestStreak, int thisWeekCount, int totalWorkouts, Set<DateTime> workoutDates
});




}
/// @nodoc
class _$WorkoutStatsCopyWithImpl<$Res>
    implements $WorkoutStatsCopyWith<$Res> {
  _$WorkoutStatsCopyWithImpl(this._self, this._then);

  final WorkoutStats _self;
  final $Res Function(WorkoutStats) _then;

/// Create a copy of WorkoutStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? thisWeekCount = null,Object? totalWorkouts = null,Object? workoutDates = null,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,thisWeekCount: null == thisWeekCount ? _self.thisWeekCount : thisWeekCount // ignore: cast_nullable_to_non_nullable
as int,totalWorkouts: null == totalWorkouts ? _self.totalWorkouts : totalWorkouts // ignore: cast_nullable_to_non_nullable
as int,workoutDates: null == workoutDates ? _self.workoutDates : workoutDates // ignore: cast_nullable_to_non_nullable
as Set<DateTime>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutStats].
extension WorkoutStatsPatterns on WorkoutStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutStats value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutStats value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  int thisWeekCount,  int totalWorkouts,  Set<DateTime> workoutDates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutStats() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.thisWeekCount,_that.totalWorkouts,_that.workoutDates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  int thisWeekCount,  int totalWorkouts,  Set<DateTime> workoutDates)  $default,) {final _that = this;
switch (_that) {
case _WorkoutStats():
return $default(_that.currentStreak,_that.longestStreak,_that.thisWeekCount,_that.totalWorkouts,_that.workoutDates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int longestStreak,  int thisWeekCount,  int totalWorkouts,  Set<DateTime> workoutDates)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutStats() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.thisWeekCount,_that.totalWorkouts,_that.workoutDates);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutStats implements WorkoutStats {
  const _WorkoutStats({this.currentStreak = 0, this.longestStreak = 0, this.thisWeekCount = 0, this.totalWorkouts = 0, final  Set<DateTime> workoutDates = const {}}): _workoutDates = workoutDates;
  

@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  int thisWeekCount;
@override@JsonKey() final  int totalWorkouts;
 final  Set<DateTime> _workoutDates;
@override@JsonKey() Set<DateTime> get workoutDates {
  if (_workoutDates is EqualUnmodifiableSetView) return _workoutDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_workoutDates);
}


/// Create a copy of WorkoutStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutStatsCopyWith<_WorkoutStats> get copyWith => __$WorkoutStatsCopyWithImpl<_WorkoutStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.thisWeekCount, thisWeekCount) || other.thisWeekCount == thisWeekCount)&&(identical(other.totalWorkouts, totalWorkouts) || other.totalWorkouts == totalWorkouts)&&const DeepCollectionEquality().equals(other._workoutDates, _workoutDates));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,thisWeekCount,totalWorkouts,const DeepCollectionEquality().hash(_workoutDates));

@override
String toString() {
  return 'WorkoutStats(currentStreak: $currentStreak, longestStreak: $longestStreak, thisWeekCount: $thisWeekCount, totalWorkouts: $totalWorkouts, workoutDates: $workoutDates)';
}


}

/// @nodoc
abstract mixin class _$WorkoutStatsCopyWith<$Res> implements $WorkoutStatsCopyWith<$Res> {
  factory _$WorkoutStatsCopyWith(_WorkoutStats value, $Res Function(_WorkoutStats) _then) = __$WorkoutStatsCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int longestStreak, int thisWeekCount, int totalWorkouts, Set<DateTime> workoutDates
});




}
/// @nodoc
class __$WorkoutStatsCopyWithImpl<$Res>
    implements _$WorkoutStatsCopyWith<$Res> {
  __$WorkoutStatsCopyWithImpl(this._self, this._then);

  final _WorkoutStats _self;
  final $Res Function(_WorkoutStats) _then;

/// Create a copy of WorkoutStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? thisWeekCount = null,Object? totalWorkouts = null,Object? workoutDates = null,}) {
  return _then(_WorkoutStats(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,thisWeekCount: null == thisWeekCount ? _self.thisWeekCount : thisWeekCount // ignore: cast_nullable_to_non_nullable
as int,totalWorkouts: null == totalWorkouts ? _self.totalWorkouts : totalWorkouts // ignore: cast_nullable_to_non_nullable
as int,workoutDates: null == workoutDates ? _self._workoutDates : workoutDates // ignore: cast_nullable_to_non_nullable
as Set<DateTime>,
  ));
}


}

// dart format on
