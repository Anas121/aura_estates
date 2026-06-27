// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(propertyRepository)
final propertyRepositoryProvider = PropertyRepositoryProvider._();

final class PropertyRepositoryProvider
    extends
        $FunctionalProvider<
          PropertyRepository,
          PropertyRepository,
          PropertyRepository
        >
    with $Provider<PropertyRepository> {
  PropertyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyRepositoryHash();

  @$internal
  @override
  $ProviderElement<PropertyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PropertyRepository create(Ref ref) {
    return propertyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PropertyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PropertyRepository>(value),
    );
  }
}

String _$propertyRepositoryHash() =>
    r'a536b7ea7a4102b5a9bc84da741b6f1fb33dc072';
