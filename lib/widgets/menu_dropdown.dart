import 'package:bank_card_app/general/styling.dart';
import 'package:flutter/material.dart';

enum MenuItems { removeAllCards, bannedCountries, backToStartScreen }

class MenuDropdown extends StatefulWidget {
  const MenuDropdown({
    super.key,
    required this.cardsIsEmpty,
    required this.onRemoveAllCards,
    required this.onShowBannedCountriesList,
    required this.onBackToStartScreen,
  });

  final void Function() onRemoveAllCards;
  final void Function() onShowBannedCountriesList;
  final void Function() onBackToStartScreen;
  final bool cardsIsEmpty;

  @override
  State<MenuDropdown> createState() => _MenuDropdownState();
}

class _MenuDropdownState extends State<MenuDropdown> {
  void _onRemoveAllCards() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Removing All Cards'),
        content: const Text(
            'Are you sure you want to remove all cards from the list?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  widget.onRemoveAllCards();
                  Navigator.pop(ctx);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBannedCountriesList() {
   widget.onShowBannedCountriesList();
  }

  void _backToStartScreen() {
    widget.onBackToStartScreen();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItems>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).colorScheme.surface,
        size: 20,
      ),
      onSelected: (MenuItems item) {
        switch (item) {
          case MenuItems.removeAllCards:
            _onRemoveAllCards();
            break;
          case MenuItems.bannedCountries:
            _showBannedCountriesList();
            break;
          case MenuItems.backToStartScreen:
            _backToStartScreen();
            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
        if (!widget.cardsIsEmpty)
          const PopupMenuItem<MenuItems>(
            value: MenuItems.removeAllCards,
            child: Row(
              children: [
                Icon(Icons.delete_outline_rounded, size: 20),
                SizedBox(width: 10),
                Text(
                  'Remove all cards',
                  style: kSmallText,
                ),
              ],
            ),
          ),
        const PopupMenuItem<MenuItems>(
          value: MenuItems.bannedCountries,
          child: Row(
            children: [
              Icon(Icons.do_not_disturb_alt_rounded, size: 20),
              SizedBox(width: 10),
              Text(
                'Banned Countries List',
                style: kSmallText,
              ),
            ],
          ),
        ),
        const PopupMenuItem<MenuItems>(
          value: MenuItems.backToStartScreen,
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Back to Start Screen',
                style: kSmallText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
