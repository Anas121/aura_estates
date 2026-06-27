// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingsStream)
final bookingsStreamProvider = BookingsStreamProvider._();

final class BookingsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          List<BookingModel>,
          Stream<List<BookingModel>>
        >
    with
        $FutureModifier<List<BookingModel>>,
        $StreamProvider<List<BookingModel>> {
  BookingsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<BookingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BookingModel>> create(Ref ref) {
    return bookingsStream(ref);
  }
}

String _$bookingsStreamHash() => r'4e4278f470fbcea91002105e16dd0c7b412c4fa7';

@ProviderFor(BookingController)
final bookingControllerProvider = BookingControllerProvider._();

final class BookingControllerProvider
    extends $AsyncNotifierProvider<BookingController, List<BookingModel>> {
  BookingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingControllerHash();

  @$internal
  @override
  BookingController create() => BookingController();
}

String _$bookingControllerHash() => r'c39bb4032155d1d10bc42f4d8198f6591887340a';

abstract class _$BookingController extends $AsyncNotifier<List<BookingModel>> {
  FutureOr<List<BookingModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BookingModel>>, List<BookingModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BookingModel>>, List<BookingModel>>,
              AsyncValue<List<BookingModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
