import 'dart:convert';
import 'package:flutter/services.dart';

class Country {
  final String name;
  final String code;

  Country({required this.name, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
}

Future<List<Country>> loadCountries() async {
  final String response = await rootBundle.loadString('assets/data/countries.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Country.fromJson(json)).toList();
}