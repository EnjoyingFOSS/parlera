// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingState {
  ParleraLocale? get preferredLocale => throw _privateConstructorUsedError;
  bool get audioEnabled => throw _privateConstructorUsedError;
  bool get rotationEnabled => throw _privateConstructorUsedError;
  GameDurationType get gameDurationType => throw _privateConstructorUsedError;
  int get customGameDuration => throw _privateConstructorUsedError;
  int? get cardsPerGame => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingStateCopyWith<SettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingStateCopyWith<$Res> {
  factory $SettingStateCopyWith(
          SettingState value, $Res Function(SettingState) then) =
      _$SettingStateCopyWithImpl<$Res, SettingState>;
  @useResult
  $Res call(
      {ParleraLocale? preferredLocale,
      bool audioEnabled,
      bool rotationEnabled,
      GameDurationType gameDurationType,
      int customGameDuration,
      int? cardsPerGame});
}

/// @nodoc
class _$SettingStateCopyWithImpl<$Res, $Val extends SettingState>
    implements $SettingStateCopyWith<$Res> {
  _$SettingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredLocale = freezed,
    Object? audioEnabled = null,
    Object? rotationEnabled = null,
    Object? gameDurationType = null,
    Object? customGameDuration = null,
    Object? cardsPerGame = freezed,
  }) {
    return _then(_value.copyWith(
      preferredLocale: freezed == preferredLocale
          ? _value.preferredLocale
          : preferredLocale // ignore: cast_nullable_to_non_nullable
              as ParleraLocale?,
      audioEnabled: null == audioEnabled
          ? _value.audioEnabled
          : audioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      rotationEnabled: null == rotationEnabled
          ? _value.rotationEnabled
          : rotationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      gameDurationType: null == gameDurationType
          ? _value.gameDurationType
          : gameDurationType // ignore: cast_nullable_to_non_nullable
              as GameDurationType,
      customGameDuration: null == customGameDuration
          ? _value.customGameDuration
          : customGameDuration // ignore: cast_nullable_to_non_nullable
              as int,
      cardsPerGame: freezed == cardsPerGame
          ? _value.cardsPerGame
          : cardsPerGame // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingStateImplCopyWith<$Res>
    implements $SettingStateCopyWith<$Res> {
  factory _$$SettingStateImplCopyWith(
          _$SettingStateImpl value, $Res Function(_$SettingStateImpl) then) =
      __$$SettingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ParleraLocale? preferredLocale,
      bool audioEnabled,
      bool rotationEnabled,
      GameDurationType gameDurationType,
      int customGameDuration,
      int? cardsPerGame});
}

/// @nodoc
class __$$SettingStateImplCopyWithImpl<$Res>
    extends _$SettingStateCopyWithImpl<$Res, _$SettingStateImpl>
    implements _$$SettingStateImplCopyWith<$Res> {
  __$$SettingStateImplCopyWithImpl(
      _$SettingStateImpl _value, $Res Function(_$SettingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preferredLocale = freezed,
    Object? audioEnabled = null,
    Object? rotationEnabled = null,
    Object? gameDurationType = null,
    Object? customGameDuration = null,
    Object? cardsPerGame = freezed,
  }) {
    return _then(_$SettingStateImpl(
      preferredLocale: freezed == preferredLocale
          ? _value.preferredLocale
          : preferredLocale // ignore: cast_nullable_to_non_nullable
              as ParleraLocale?,
      audioEnabled: null == audioEnabled
          ? _value.audioEnabled
          : audioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      rotationEnabled: null == rotationEnabled
          ? _value.rotationEnabled
          : rotationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      gameDurationType: null == gameDurationType
          ? _value.gameDurationType
          : gameDurationType // ignore: cast_nullable_to_non_nullable
              as GameDurationType,
      customGameDuration: null == customGameDuration
          ? _value.customGameDuration
          : customGameDuration // ignore: cast_nullable_to_non_nullable
              as int,
      cardsPerGame: freezed == cardsPerGame
          ? _value.cardsPerGame
          : cardsPerGame // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SettingStateImpl extends _SettingState with DiagnosticableTreeMixin {
  const _$SettingStateImpl(
      {this.preferredLocale = null,
      this.audioEnabled = SettingState.defaultAudioEnabled,
      required this.rotationEnabled,
      this.gameDurationType = SettingState.defaultGameDurationType,
      this.customGameDuration = SettingState.defaultCustomGameDuration,
      this.cardsPerGame = SettingState.defaultCardsPerGame})
      : super._();

  @override
  @JsonKey()
  final ParleraLocale? preferredLocale;
  @override
  @JsonKey()
  final bool audioEnabled;
  @override
  final bool rotationEnabled;
  @override
  @JsonKey()
  final GameDurationType gameDurationType;
  @override
  @JsonKey()
  final int customGameDuration;
  @override
  @JsonKey()
  final int? cardsPerGame;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingState(preferredLocale: $preferredLocale, audioEnabled: $audioEnabled, rotationEnabled: $rotationEnabled, gameDurationType: $gameDurationType, customGameDuration: $customGameDuration, cardsPerGame: $cardsPerGame)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingState'))
      ..add(DiagnosticsProperty('preferredLocale', preferredLocale))
      ..add(DiagnosticsProperty('audioEnabled', audioEnabled))
      ..add(DiagnosticsProperty('rotationEnabled', rotationEnabled))
      ..add(DiagnosticsProperty('gameDurationType', gameDurationType))
      ..add(DiagnosticsProperty('customGameDuration', customGameDuration))
      ..add(DiagnosticsProperty('cardsPerGame', cardsPerGame));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingStateImpl &&
            (identical(other.preferredLocale, preferredLocale) ||
                other.preferredLocale == preferredLocale) &&
            (identical(other.audioEnabled, audioEnabled) ||
                other.audioEnabled == audioEnabled) &&
            (identical(other.rotationEnabled, rotationEnabled) ||
                other.rotationEnabled == rotationEnabled) &&
            (identical(other.gameDurationType, gameDurationType) ||
                other.gameDurationType == gameDurationType) &&
            (identical(other.customGameDuration, customGameDuration) ||
                other.customGameDuration == customGameDuration) &&
            (identical(other.cardsPerGame, cardsPerGame) ||
                other.cardsPerGame == cardsPerGame));
  }

  @override
  int get hashCode => Object.hash(runtimeType, preferredLocale, audioEnabled,
      rotationEnabled, gameDurationType, customGameDuration, cardsPerGame);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingStateImplCopyWith<_$SettingStateImpl> get copyWith =>
      __$$SettingStateImplCopyWithImpl<_$SettingStateImpl>(this, _$identity);
}

abstract class _SettingState extends SettingState {
  const factory _SettingState(
      {final ParleraLocale? preferredLocale,
      final bool audioEnabled,
      required final bool rotationEnabled,
      final GameDurationType gameDurationType,
      final int customGameDuration,
      final int? cardsPerGame}) = _$SettingStateImpl;
  const _SettingState._() : super._();

  @override
  ParleraLocale? get preferredLocale;
  @override
  bool get audioEnabled;
  @override
  bool get rotationEnabled;
  @override
  GameDurationType get gameDurationType;
  @override
  int get customGameDuration;
  @override
  int? get cardsPerGame;
  @override
  @JsonKey(ignore: true)
  _$$SettingStateImplCopyWith<_$SettingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
