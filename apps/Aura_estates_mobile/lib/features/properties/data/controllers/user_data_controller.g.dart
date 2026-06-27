// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userDataRepository)
final userDataRepositoryProvider = UserDataRepositoryProvider._();

final class UserDataRepositoryProvider
    extends
        $FunctionalProvider<
          UserDataRepository,
          UserDataRepository,
          UserDataRepository
        >
    with $Provider<UserDataRepository> {
  UserDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserDataRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserDataRepository create(Ref ref) {
    return userDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserDataRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserDataRepository>(value),
    );
  }
}

String _$userDataRepositoryHash() =>
    r'd71ef07437d21f0e5cf2fc84ec396cd684584f6e';

@ProviderFor(UserDataController)
final userDataControllerProvider = UserDataControllerProvider._();

final class UserDataControllerProvider
    extends $NotifierProvider<UserDataController, UserData> {
  UserDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDataControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDataControllerHash();

  @$internal
  @override
  UserDataController create() => UserDataController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserData>(value),
    );
  }
}

String _$userDataControllerHash() =>
    r'574c7c3993d5036a235269146c8b9c2af24bc734';

abstract class _$UserDataController extends $Notifier<UserData> {
  UserData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserData, UserData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserData, UserData>,
              UserData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(isFavorite)
final isFavoriteProvider = IsFavoriteFamily._();

final class IsFavoriteProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsFavoriteProvider._({
    required IsFavoriteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isFavoriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isFavoriteHash();

  @override
  String toString() {
    return r'isFavoriteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isFavorite(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isFavoriteHash() => r'b15aa9fed4e40c56ea3a1ade1336caa643426873';

final class IsFavoriteFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  IsFavoriteFamily._()
    : super(
        retry: null,
        name: r'isFavoriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsFavoriteProvider call(String propertyId) =>
      IsFavoriteProvider._(argument: propertyId, from: this);

  @override
  String toString() => r'isFavoriteProvider';
}
