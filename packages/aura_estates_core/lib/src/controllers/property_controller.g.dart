// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(propertiesStream)
final propertiesStreamProvider = PropertiesStreamProvider._();

final class PropertiesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PropertyModel>>,
          List<PropertyModel>,
          Stream<List<PropertyModel>>
        >
    with
        $FutureModifier<List<PropertyModel>>,
        $StreamProvider<List<PropertyModel>> {
  PropertiesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertiesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertiesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<PropertyModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PropertyModel>> create(Ref ref) {
    return propertiesStream(ref);
  }
}

String _$propertiesStreamHash() => r'1a5ad207bf6ad74d00ed46cef79e6c63aba7d081';

@ProviderFor(PropertyController)
final propertyControllerProvider = PropertyControllerProvider._();

final class PropertyControllerProvider
    extends $AsyncNotifierProvider<PropertyController, void> {
  PropertyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyControllerHash();

  @$internal
  @override
  PropertyController create() => PropertyController();
}

String _$propertyControllerHash() =>
    r'4b4b7e2b62c2c109f230709c7cdd1ee2ae5a292d';

abstract class _$PropertyController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, String> {
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCategoryHash() => r'b8ffe8bb124ebefc18b46dcad7ce8a31ed74f8fe';

abstract class _$SelectedCategory extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
