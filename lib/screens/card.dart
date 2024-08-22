import 'dart:convert';
import 'package:bank_card_app/helpers/encryption.dart';
import 'package:bank_card_app/helpers/storage.dart';
import 'package:bank_card_app/models/card_model.dart';
import 'package:bank_card_app/general/styling.dart';
import 'package:bank_card_app/widgets/card_item.dart';
import 'package:bank_card_app/widgets/country_list.dart';
import 'package:bank_card_app/widgets/edit_card_form.dart';
import 'package:bank_card_app/widgets/menu_dropdown.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({
    super.key,
    required this.back,
  });

  final void Function() back;

  @override
  State<CardScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<CardScreen> {
  List<CardModel> _cards = [];
  Future<bool>? _cardsLoadedFromStorage;
  Storage storage = Storage();
  CardModel? _selectedCard;

  final aesEncryption = AES256Encryption(
    '12345678901234567890123456789012',
    '1234567890123456',
  );

  @override
  void initState() {
    _cardsLoadedFromStorage = _getCardsFromStorage();
    super.initState();
  }

  Future<bool> _getCardsFromStorage() async {
    try {
      var jsonString = await storage.readFromFile('cards');
      var decryptedString = aesEncryption.decrypt(jsonString);
      List<dynamic> jsonList = json.decode(decryptedString);
      setState(() {
        _cards = jsonList.map((json) => CardModel.fromJson(json)).toList();
      });
    } catch (error) {
      print(error);
    }

    return true;
  }

  void _saveCardsToStorage() async {
    String jsonString =
        json.encode(_cards.map((card) => card.toJson()).toList());
    String encryptedString = aesEncryption.encrypt(jsonString);
    await storage.writeToFile('cards', encryptedString);
  }

  void _addNewCard() {
    setState(() {
      _selectedCard = null;
    });
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditCardForm(onSaveCard: _saveCard),
    );
  }

  _saveCard(CardModel newCard) async {
    bool cardAlreadyExist = false;
    if (_cards.isNotEmpty) {
      _cards.forEach(
        (card) {
          if (card.number == newCard.number) {
            cardAlreadyExist = true;
          }
        },
      );
    }

    if (!cardAlreadyExist) {
      setState(() {
        _cards.add(newCard);
        _saveCardsToStorage();
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('This card has already been added.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
      return false;
    }
    return true;
  }

  _deleteCard(CardModel card) {
    final cardIndex = _cards.indexOf(card);
    setState(() {
      _selectedCard = null;
      _cards.remove(card);
      _saveCardsToStorage();
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Card deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _cards.insert(cardIndex, card);
              _saveCardsToStorage();
            });
          },
        ),
      ),
    );
  }

  _removeAllCards() {
    setState(() {
      _selectedCard = null;
      _cards = [];
      _saveCardsToStorage();
    });
  }

  void _onTapCard(CardModel card) {
    setState(() {
      if (_selectedCard == card) {
        _selectedCard = null;
      } else {
        _selectedCard = card;
      }
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cards',
                          style: kHeadline,
                        ),
                        Row(
                          children: [
                            Material(
                              elevation: 2.0,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              clipBehavior: Clip.none,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                ),
                                child: IconButton(
                                  onPressed: _addNewCard,
                                  icon: Icon(
                                    Icons.add_card_rounded,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              elevation: 2.0,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              clipBehavior: Clip.none,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                ),
                                child: MenuDropdown(
                                  cardsIsEmpty: _cards.isEmpty,
                                  onRemoveAllCards: _removeAllCards,
                                  onShowBannedCountriesList: () {
                                    setState(() {
                                      _selectedCard = null;
                                    });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => const CountryList(),
                                      ),
                                    );
                                  },
                                  onBackToStartScreen: widget.back,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _cardsLoadedFromStorage,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      if (snapshot.hasData &&
                          snapshot.data == true &&
                          _cards.isNotEmpty) {
                        return ListView.separated(
                          physics: const ScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 30),
                          shrinkWrap: true,
                          itemCount: _cards.length,
                          itemBuilder: (BuildContext context, int index) {
                            final card = _cards[index];
                            bool isSelected = card == _selectedCard;
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
                              key: Key(card.number),
                              onDismissed: (direction) {
                                _deleteCard(card);
                              },
                              child: CardItem(
                                card: card,
                                isSelected: isSelected,
                                onTapCard: () {
                                  _onTapCard(card);
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          heightFactor: 6,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.filter_none_rounded,
                                color: kSoftTextColor,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No cards have been added yet.',
                                style: kBodyText.copyWith(
                                  color: kSoftTextColor,
                                ),
                              ),
                              Text(
                                'Try adding some!',
                                style: kSmallText.copyWith(
                                  color: kSoftTextColor,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
