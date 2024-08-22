import 'package:bank_card_app/models/card_model.dart';
import 'package:bank_card_app/general/styling.dart';
import 'package:flutter/material.dart';

class CardItem extends StatefulWidget {
  const CardItem({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTapCard,
  });

  final CardModel card;
  final bool isSelected;

  final void Function() onTapCard;

  @override
  State<CardItem> createState() {
    return _CardItemState();
  }
}

class _CardItemState extends State<CardItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return InkWell(
      onTap: widget.onTapCard,
      child: AnimatedScale(
        scale: widget.isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Material(
          elevation: 5.0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(kBorderRadius),
          clipBehavior: Clip.none,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: kSecondaryColor),
              gradient: const LinearGradient(
                colors: [
                  kSecondaryColor,
                  kTertiaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.card.name,
                          style: kBodyText.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.card.expirationDate,
                      style: kSmallText.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.isSelected)
                          Text(
                            widget.card.cvv,
                            style: kSmallText.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.isSelected
                              ? widget.card.number
                                  .replaceAllMapped(RegExp(r".{1,4}"),
                                      (match) => "${match.group(0)} ")
                                  .trim()
                              : '${'•' * 4} ${widget.card.number.substring(12)}',
                          style: kBodyText3.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.card.cardholder,
                        style: kBodyText.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          widget.card.type,
                          style: kBodyText.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
