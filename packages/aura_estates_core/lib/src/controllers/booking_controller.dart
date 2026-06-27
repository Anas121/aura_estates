import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_controller.g.dart';

@riverpod
Stream<List<BookingModel>> bookingsStream(Ref ref) {
  return ref.watch(bookingRepositoryProvider).watchBookings();
}

@riverpod
class BookingController extends _$BookingController {
  @override
  Future<List<BookingModel>> build() async {
    return ref.read(bookingRepositoryProvider).fetchAll();
  }

  Future<void> addBookingRequest(BookingModel bookingRequest) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bookingRepositoryProvider).add(bookingRequest);
      return ref.read(bookingRepositoryProvider).fetchAll();
    });
  }

  Future<void> updateBookingStatus({
    required String id,
    required String status,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(bookingRepositoryProvider).updateStatus(id, status);
      if (ref.mounted) {
        final bookings = await ref.read(bookingRepositoryProvider).fetchAll();
        state = AsyncData(bookings);
      }
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
    }
  }

  Future<void> deleteBooking(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(bookingRepositoryProvider).delete(id);
      if (ref.mounted) {
        final bookings = await ref.read(bookingRepositoryProvider).fetchAll();
        state = AsyncData(bookings);
      }
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
    }
  }
}
