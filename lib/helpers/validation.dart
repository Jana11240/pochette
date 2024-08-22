import 'dart:convert';
import 'package:bank_card_app/helpers/storage.dart';
import 'package:http/http.dart' as http;

class Validation {
  final Storage storage = Storage();

  String? validateInput(value, type) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the $type';
    }
    return null;
  }

  String? validateCardNumber(value) {
    final isNotEmpty = validateInput(value, 'card number');
    if (isNotEmpty != null) {
      return isNotEmpty;
    }
    if (value.length != 16) {
      return 'Invalid card number';
    }
    return null;
  }

  /* Alternative to using an API to lookup the card info */
  String deriveCardType(String cardNumber) {
    final visa = RegExp(r'^4[0-9]*$');
    final mc = RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]*$');
    final ae = RegExp(r'^3[47][0-9]*$');
    final dc = RegExp(r'^3(?:0[0-5]|[689])[0-9]*$');
    final disc = RegExp(
        r'^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]*$');
    final jcb = RegExp(r'^(?:2131|1800|35[0-9]*)$');
    final maestro = RegExp(r'^(5[06789]|6)[0-9]*$');

    if (jcb.hasMatch(cardNumber)) {
      return 'JCB';
    } else if (ae.hasMatch(cardNumber)) {
      return 'American Express';
    } else if (dc.hasMatch(cardNumber)) {
      return 'Diners Club';
    } else if (disc.hasMatch(cardNumber)) {
      return 'Discover';
    } else if (visa.hasMatch(cardNumber)) {
      return 'Visa';
    } else if (mc.hasMatch(cardNumber)) {
      return 'MasterCard';
    } else if (maestro.hasMatch(cardNumber)) {
      if (mc.hasMatch(cardNumber)) {
        return 'MasterCard';
      } else {
        return 'Maestro';
      }
    } else {
      return 'Unknown';
    }
  }

  lookupBin(bin) async {
    const String baseUrl = 'https://data.handyapi.com/bin/';
    final response = await http.get(
      Uri.parse('$baseUrl/$bin'),
      headers: {"Referer": "janavanvuren@gmail.com"},
    );
    if (response.statusCode == 200) {
      final cardInfo = jsonDecode(response.body);
      if (cardInfo['Status'] == 'SUCCESS') {
        return cardInfo;
      }
    }
    return null;
  }

  checkIfCountryValid(countryCode) async {
    bool isValid = true;
    try {
      var jsonString = await storage.readFromFile('bannedCountries');
      if (jsonString.isNotEmpty) {
        List<dynamic> jsonList = json.decode(jsonString);
        jsonList.forEach(
          (country) {
            if (country['code'] == countryCode) {
              isValid = false;
            }
          },
        );
      }
    } catch (error) {
      return true;
    }

    return isValid;
  }

  String? validateCvv(value) {
    final isNotEmpty = validateInput(value, 'CVV');
    if (isNotEmpty != null) {
      return isNotEmpty;
    }
    if (value.length != 3) {
      return 'Invalid CVV';
    }
    return null;
  }

  String? validateExpirationDate(value) {
    final isNotEmpty = validateInput(value, 'expiration date');
    if (isNotEmpty != null) {
      return isNotEmpty;
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
      return 'Invalid date format';
    }

    List<String> values = value.split('/');
    int month = int.parse(values[0]);
    int year = int.parse('20' + values[1]);
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month, 1);
    DateTime inputDate = DateTime(year, month, 1);

    if (inputDate.isBefore(firstDayOfNextMonth)) {
      return 'Date is expired';
    }
    return null;
  }
}
