class PropertyModel {
  final String id;
  final String title;
  final double price;
  final String currency;
  final String location;
  final String category;
  final String description;
  final String imageUrl;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final bool isFeatured;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.location,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.isFeatured,
  });

  factory PropertyModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PropertyModel(
      id: id,
      title: data['title'] as String? ?? 'Inconnu',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] as String? ?? 'Inconnu',
      location: data['location'] as String? ?? 'Inconnu',
      category: data['category'] as String? ?? 'Inconnu', // ✅
      description: data['description'] as String? ?? 'Inconnu', // ✅
      imageUrl: data['imageUrl'] as String? ?? '',
      bedrooms: data['bedrooms'] as int? ?? 0, // ✅
      bathrooms: data['bathrooms'] as int? ?? 0, // ✅
      area: (data['area'] as num?)?.toDouble() ?? 0.0, // ✅
      isFeatured: data['isFeatured'] as bool? ?? false, // ✅
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'currency': currency,
      'location': location,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'isFeatured': isFeatured,
    };
  }
}
