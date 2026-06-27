import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_repository.g.dart';

@riverpod
BookingRepository bookingRepository(Ref ref) {
  return BookingRepository();
}

class BookingRepository {
  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('Booking requests');

  Future<List<BookingModel>> fetchAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Stream<List<BookingModel>> watchBookings() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<void> add(BookingModel bookingRequest) async {
    await _collection.add(bookingRequest.toJson());
  }

  Future<void> updateStatus(String id, String status) async {
    await _collection.doc(id).update({'status': status});
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
