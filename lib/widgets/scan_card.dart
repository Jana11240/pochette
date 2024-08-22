import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';

class ScanCard extends StatefulWidget {
  const ScanCard({super.key, required this.onCardDetailsObtained});

  final void Function(CardInfo cardInfo) onCardDetailsObtained;

  @override
  State<ScanCard> createState() => _ScanCardState();
}

class _ScanCardState extends State<ScanCard> {
  final ScannerWidgetController _controller = ScannerWidgetController();
  final ValueNotifier<CardInfo?> _cardInfo = ValueNotifier(null);

  @override
  void initState() {
    _controller
      ..setCardListener(_onListenCard)
      ..setErrorListener(_onError);
    super.initState();
  }

  @override
  void dispose() {
    _controller
      ..removeCardListeners(_onListenCard)
      ..removeErrorListener(_onError)
      ..dispose();
    super.dispose();
  }

  void _onListenCard(CardInfo? value) {
    _cardInfo.value = value;
  }

  void _onError(ScannerException exception) {
    if (kDebugMode) {
      print('Error: ${exception.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Scanner'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ScannerWidget(
                controller: _controller,
                overlayOrientation: CardOrientation.landscape,
                cameraResolution: CameraResolution.max,
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder<CardInfo?>(
                    valueListenable: _cardInfo,
                    builder: (context, card, child) {
                      if (card != null) {
                        if (card.expiry != '' &&
                            card.number != '' &&
                            card.type != '') {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onCardDetailsObtained(card);
                          });
                        }
                      }
                      return Text(card?.toString() ?? 'No Card Details');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
