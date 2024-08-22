import 'package:bank_card_app/general/styling.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    super.key,
    required this.start,
  });

  final void Function() start;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/pochette.png',
                        fit: BoxFit.fill,
                      ),
                    )),
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome!',
                style: kBodyText2.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 30),
              Text(
                'Validate and store credit cards with precision and ease.',
                style: kBodyText3.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: start,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                icon: const Icon(Icons.arrow_right_alt),
                label: const Text(
                  'Start',
                  style: kButtonText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
