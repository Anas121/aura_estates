import 'package:aura_estates_core/aura_estates_core.dart';

class BookingModel {
  final String id;
  final String userName;
  final String userMail;
  final String userPhone;
  final String bookingDate;
  final String status;
  final PropertyModel currentProperty;

  BookingModel({
    this.id = '',
    required this.currentProperty,
    required this.userName,
    required this.userMail,
    required this.userPhone,
    required this.bookingDate,
    this.status = 'En attente', // valeur par défaut
  });

  factory BookingModel.fromJson(Map<String, dynamic> json, String id) {
    return BookingModel(
      id: id,
      currentProperty: PropertyModel.fromFirestore(
        json['currentProperty'] as Map<String, dynamic>? ?? {},
        '',
      ),
      userName: json['userName'] as String? ?? 'Inconnue',
      userMail: json['userMail'] as String? ?? 'Inconnue',
      userPhone: json['userPhone'] as String? ?? 'Inconnue',
      bookingDate: json['bookingDate'] as String? ?? 'Inconnue',
      status: json['status'] as String? ?? 'En attente',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentProperty': currentProperty.toMap(),
      'userName': userName,
      'userMail': userMail,
      'userPhone': userPhone,
      'bookingDate': bookingDate,
      'status': status,
    };
  }
}
