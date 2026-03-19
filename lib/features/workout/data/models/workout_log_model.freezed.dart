// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseSet {

 double get weightKg; int get reps;
/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseSetCopyWith<ExerciseSet> get copyWith => _$ExerciseSetCopyWithImpl<ExerciseSet>(this as ExerciseSet, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseSet&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.reps, reps) || other.reps == reps));
}


@override
int get hashCode => Object.hash(runtimeType,weightKg,reps);

@override
String toString() {
  return 'ExerciseSet(weightKg: $weightKg, reps: $reps)';
}


}

/// @nodoc
abstract mixin class $ExerciseSetCopyWith<$Res>  {
  factory $ExerciseSetCopyWith(ExerciseSet value, $Res Function(ExerciseSet) _then) = _$ExerciseSetCopyWithImpl;
@useResult
$Res call({
 double weightKg, int reps
});




}
/// @nodoc
class _$ExerciseSetCopyWithImpl<$Res>
    implements $ExerciseSetCopyWith<$Res> {
  _$ExerciseSetCopyWithImpl(this._self, this._then);

  final ExerciseSet _self;
  final $Res Function(ExerciseSet) _then;

/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weightKg = null,Object? reps = null,}) {
  return _then(_self.copyWith(
weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseSet].
extension ExerciseSetPatterns on ExerciseSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseSet value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseSet value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double weightKg,  int reps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
return $default(_that.weightKg,_that.reps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double weightKg,  int reps)  $default,) {final _that = this;
switch (_that) {
case _ExerciseSet():
return $default(_that.weightKg,_that.reps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double weightKg,  int reps)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
return $default(_that.weightKg,_that.reps);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseSet extends ExerciseSet {
  const _ExerciseSet({required this.weightKg, required this.reps}): super._();
  

@override final  double weightKg;
@override final  int reps;

/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseSetCopyWith<_ExerciseSet> get copyWith => __$ExerciseSetCopyWithImpl<_ExerciseSet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseSet&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.reps, reps) || other.reps == reps));
}


@override
int get hashCode => Object.hash(runtimeType,weightKg,reps);

@override
String toString() {
  return 'ExerciseSet(weightKg: $weightKg, reps: $reps)';
}


}

/// @nodoc
abstract mixin class _$ExerciseSetCopyWith<$Res> implements $ExerciseSetCopyWith<$Res> {
  factory _$ExerciseSetCopyWith(_ExerciseSet value, $Res Function(_ExerciseSet) _then) = __$ExerciseSetCopyWithImpl;
@override @useResult
$Res call({
 double weightKg, int reps
});




}
/// @nodoc
class __$ExerciseSetCopyWithImpl<$Res>
    implements _$ExerciseSetCopyWith<$Res> {
  __$ExerciseSetCopyWithImpl(this._self, this._then);

  final _ExerciseSet _self;
  final $Res Function(_ExerciseSet) _then;

/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weightKg = null,Object? reps = null,}) {
  return _then(_ExerciseSet(
weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Exercise {

 String get name; List<ExerciseSet> get sets; String? get note;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.sets, sets)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(sets),note);

@override
String toString() {
  return 'Exercise(name: $name, sets: $sets, note: $note)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String name, List<ExerciseSet> sets, String? note
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? sets = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<ExerciseSet>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<ExerciseSet> sets,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.name,_that.sets,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<ExerciseSet> sets,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.name,_that.sets,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<ExerciseSet> sets,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.name,_that.sets,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _Exercise extends Exercise {
  const _Exercise({required this.name, required final  List<ExerciseSet> sets, this.note}): _sets = sets,super._();
  

@override final  String name;
 final  List<ExerciseSet> _sets;
@override List<ExerciseSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

@override final  String? note;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._sets, _sets)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_sets),note);

@override
String toString() {
  return 'Exercise(name: $name, sets: $sets, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String name, List<ExerciseSet> sets, String? note
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? sets = null,Object? note = freezed,}) {
  return _then(_Exercise(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<ExerciseSet>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$WorkoutEntry {

 String get id; String get date; String get type; String? get day; String? get notes; List<Exercise> get exercises; DateTime? get createdAt;
/// Create a copy of WorkoutEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutEntryCopyWith<WorkoutEntry> get copyWith => _$WorkoutEntryCopyWithImpl<WorkoutEntry>(this as WorkoutEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.day, day) || other.day == day)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,type,day,notes,const DeepCollectionEquality().hash(exercises),createdAt);

@override
String toString() {
  return 'WorkoutEntry(id: $id, date: $date, type: $type, day: $day, notes: $notes, exercises: $exercises, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WorkoutEntryCopyWith<$Res>  {
  factory $WorkoutEntryCopyWith(WorkoutEntry value, $Res Function(WorkoutEntry) _then) = _$WorkoutEntryCopyWithImpl;
@useResult
$Res call({
 String id, String date, String type, String? day, String? notes, List<Exercise> exercises, DateTime? createdAt
});




}
/// @nodoc
class _$WorkoutEntryCopyWithImpl<$Res>
    implements $WorkoutEntryCopyWith<$Res> {
  _$WorkoutEntryCopyWithImpl(this._self, this._then);

  final WorkoutEntry _self;
  final $Res Function(WorkoutEntry) _then;

/// Create a copy of WorkoutEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? type = null,Object? day = freezed,Object? notes = freezed,Object? exercises = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutEntry].
extension WorkoutEntryPatterns on WorkoutEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutEntry value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String type,  String? day,  String? notes,  List<Exercise> exercises,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutEntry() when $default != null:
return $default(_that.id,_that.date,_that.type,_that.day,_that.notes,_that.exercises,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String type,  String? day,  String? notes,  List<Exercise> exercises,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _WorkoutEntry():
return $default(_that.id,_that.date,_that.type,_that.day,_that.notes,_that.exercises,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String type,  String? day,  String? notes,  List<Exercise> exercises,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutEntry() when $default != null:
return $default(_that.id,_that.date,_that.type,_that.day,_that.notes,_that.exercises,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutEntry extends WorkoutEntry {
  const _WorkoutEntry({required this.id, required this.date, required this.type, this.day, this.notes, required final  List<Exercise> exercises, this.createdAt}): _exercises = exercises,super._();
  

@override final  String id;
@override final  String date;
@override final  String type;
@override final  String? day;
@override final  String? notes;
 final  List<Exercise> _exercises;
@override List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override final  DateTime? createdAt;

/// Create a copy of WorkoutEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutEntryCopyWith<_WorkoutEntry> get copyWith => __$WorkoutEntryCopyWithImpl<_WorkoutEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.day, day) || other.day == day)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,type,day,notes,const DeepCollectionEquality().hash(_exercises),createdAt);

@override
String toString() {
  return 'WorkoutEntry(id: $id, date: $date, type: $type, day: $day, notes: $notes, exercises: $exercises, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WorkoutEntryCopyWith<$Res> implements $WorkoutEntryCopyWith<$Res> {
  factory _$WorkoutEntryCopyWith(_WorkoutEntry value, $Res Function(_WorkoutEntry) _then) = __$WorkoutEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String type, String? day, String? notes, List<Exercise> exercises, DateTime? createdAt
});




}
/// @nodoc
class __$WorkoutEntryCopyWithImpl<$Res>
    implements _$WorkoutEntryCopyWith<$Res> {
  __$WorkoutEntryCopyWithImpl(this._self, this._then);

  final _WorkoutEntry _self;
  final $Res Function(_WorkoutEntry) _then;

/// Create a copy of WorkoutEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? type = null,Object? day = freezed,Object? notes = freezed,Object? exercises = null,Object? createdAt = freezed,}) {
  return _then(_WorkoutEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
