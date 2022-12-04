class Hotels {
  final String? name;
  final String? description;
  final String? imagePath;
  final String? location;
  final String? price;
  final String? raiting;
  final List<dynamic>? rooms;
  final List<dynamic>? roomsId;

  Hotels(
      {this.name,
      this.description,
      this.imagePath,
      this.location,
      this.price,
      this.raiting,
      this.rooms,
      this.roomsId});

  factory Hotels.fromJson(Map<String, dynamic> data) {
    //метод декодинга данных погоды по дням json
    return Hotels(
      raiting: data['raiting'] as String,
      imagePath: data['imagePath'] as String,
      name: data['name'] as String,
      location: data['location'] as String,
      description: data['description'] as String,
      rooms: data['rooms'] as List<dynamic>,
      roomsId: data['roomsId'] as List<dynamic>,
      price: data['price'] as String,
    );
  }
}
