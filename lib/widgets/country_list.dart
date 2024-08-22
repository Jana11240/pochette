import 'dart:convert';

import 'package:bank_card_app/general/styling.dart';
import 'package:bank_card_app/helpers/storage.dart';
import 'package:bank_card_app/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CountryList extends StatefulWidget {
  const CountryList({
    super.key,
  });

  @override
  State<CountryList> createState() {
    return _CountryListState();
  }
}

class _CountryListState extends State<CountryList> {
  final TextEditingController _typeAheadController = TextEditingController();
  Storage storage = Storage();

  List<Country>? _countries = [];
  Future<bool>? _countriesLoaded;

  Future<bool>? _countriesLoadedFromStorage;
  List<Country> _bannedCountries = [];
  Country? _enteredCountry;

  @override
  void initState() {
    _countriesLoaded = _getAllCountries();
    _countriesLoadedFromStorage = _getCountryListFromStorage();
    super.initState();
  }

  Future<bool> _getAllCountries() async {
    final countries = await loadCountries();
    setState(() {
      _countries = countries;
    });
    return true;
  }

  Future<bool> _getCountryListFromStorage() async {
    try {
      var jsonString = await storage.readFromFile('bannedCountries');
      List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _bannedCountries =
            jsonList.map((json) => Country.fromJson(json)).toList();
      });
    } catch (error) {
      print(error);
    }

    return true;
  }

  void _saveCountryListToStorage() async {
    String jsonString =
        json.encode(_bannedCountries.map((card) => card.toJson()).toList());
    await storage.writeToFile('bannedCountries', jsonString);
  }

  void _onAddCountry() {
    _typeAheadController.text = '';
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Choose the Country:',
                    style: kSmallText.copyWith(
                        color: kSoftTextColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              FutureBuilder(
                future: _countriesLoaded,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasData &&
                      snapshot.data == true &&
                      _countries!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TypeAheadField<Country>(
                        controller: _typeAheadController,
                        suggestionsCallback: (pattern) {
                          return _countries!
                              .where((country) =>
                                  '${country.name}, ${country.code}'
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, Country country) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text('${country.name}, ${country.code}'),
                          );
                        },
                        onSelected: (Country country) {
                          _typeAheadController.text =
                              '${country.name}, ${country.code}';

                          _enteredCountry = country;
                        },
                      ),
                    );
                  }
                  return const CircularProgressIndicator.adaptive();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: kBodyText.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor),
                      onPressed: _addCountry,
                      child: Text(
                        'Add',
                        style: kBodyText.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addCountry() async {
    if (_enteredCountry != null &&
        !_bannedCountries.contains(_enteredCountry)) {
      setState(() {
        _bannedCountries.add(_enteredCountry!);
        _saveCountryListToStorage();
      });
    }
    Navigator.pop(context);
  }

  void _deleteCountry(Country country) {
    setState(() {
      _bannedCountries.remove(country);
      _saveCountryListToStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'List of Banned Countries',
              style: kBodyText2,
            ),
          ],
        ),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(
            children: [
              FutureBuilder(
                  future: _countriesLoadedFromStorage,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data == true &&
                        _bannedCountries.isNotEmpty) {
                      return ListView.separated(
                        physics: const ScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 5),
                        shrinkWrap: true,
                        itemCount: _bannedCountries.length,
                        itemBuilder: (BuildContext context, int index) {
                          final country = _bannedCountries[index];
                          return Dismissible(
                            background: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            key: Key(country.code),
                            onDismissed: (direction) {
                              _deleteCountry(country);
                            },
                            child: Card(
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                              child: ListTile(
                                title: Text(
                                  country.name,
                                  style: kBodyText,
                                ),
                                trailing: Text(
                                  country.code,
                                  style: kBodyText.copyWith(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'There are currently no banned countries',
                              style: kBodyText.copyWith(
                                color: kSoftTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              onPressed: _onAddCountry,
              child: Text(
                'Add Country',
                style: kBodyText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
