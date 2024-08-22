class CardModel {
  String name;
  String cardholder;
  String number;
  String expirationDate;
  String type;
  String cvv;
  String country;

  CardModel({
    required this.name,
    required this.cardholder,
    required this.number,
    required this.expirationDate,
    required this.type,
    required this.cvv,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cardholder': cardholder,
      'number': number,
      'expirationDate': expirationDate,
      'type': type,
      'cvv': cvv,
      'country': country,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: json['name'],
      cardholder: json['cardholder'],
      number: json['number'],
      expirationDate: json['expirationDate'],
      type: json['type'],
      cvv: json['cvv'],
      country: json['country'],
    );
  }
}
