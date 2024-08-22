import 'package:bank_card_app/helpers/validation.dart';
import 'package:bank_card_app/models/card_model.dart';
import 'package:bank_card_app/general/styling.dart';
import 'package:bank_card_app/widgets/scan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';
import 'package:camera/camera.dart';

class EditCardForm extends StatefulWidget {
  const EditCardForm({
    super.key,
    required this.onSaveCard,
  });

  final Function(CardModel newCard) onSaveCard;

  @override
  State<EditCardForm> createState() {
    return _EditCardFormState();
  }
}

class _EditCardFormState extends State<EditCardForm> {
  final _form = GlobalKey<FormState>();
  final validate = Validation();

  late CameraController _cameraController;
  late Future<void> cameraValue;

  bool _isLoading = false;

  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();

  String _enteredCardName = '';
  String _enteredCardHolder = '';
  String _enteredCardNumber = '';
  String _enteredExpirationDate = '';
  String _enteredCvv = '';

  bool _attemptedSave = false;

  @override
  void initState() {
    _cardNumberController.text = '';
    _expirationDateController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  void _onSaveCard() async {
    setState(() {
      _attemptedSave = true;
    });

    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _attemptedSave = true;
      _isLoading = true;
    });

    final cardInfo =
        await validate.lookupBin(_enteredCardNumber.substring(0, 6));
    bool isValid = false;
    if (cardInfo != null) {
      if (cardInfo['Country'].isNotEmpty && cardInfo['Country'] != null) {
        isValid = await validate.checkIfCountryValid(cardInfo['Country']['A2']);
      }

      if (isValid) {
        CardModel newCard = CardModel(
          name: _enteredCardName,
          cardholder: _enteredCardHolder,
          number: _enteredCardNumber,
          expirationDate: _enteredExpirationDate,
          type: cardInfo['Scheme'],
          cvv: _enteredCvv,
          country: cardInfo['Country']['A2'],
        );

        await widget.onSaveCard(newCard);
        Navigator.pop(context);
      }
    }

    if (!isValid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('This card cannot be verified.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  _onScanCard() async {
    try {
      final cameras = await availableCameras();
      setState(() {
        _cardNumberController.text = '';
        _expirationDateController.text = '';
      });
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras[0], ResolutionPreset.high);
        cameraValue = _cameraController.initialize();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ScanCard(
              onCardDetailsObtained: (card) {
                if (_cardNumberController.text == '' &&
                    _expirationDateController.text == '') {
                  _populateCardDetails(card);
                  Navigator.pop(ctx);
                }
              },
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('No cameras available'),
            content: const Text('A card cannot be scanned at this time.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Okay'))
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  _populateCardDetails(CardInfo cardInfo) {
    setState(() {
      _cardNumberController.text = cardInfo.number;
      _expirationDateController.text = cardInfo.expiry;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.chevron_left_rounded,
                                      size: 40,
                                    ),
                                  ),
                                  Text(
                                    "New Card",
                                    style: kBodyText3.copyWith(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: _onScanCard,
                                child: Material(
                                  elevation: 2.0,
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                  clipBehavior: Clip.none,
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius:
                                          BorderRadius.circular(kBorderRadius),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Icon(
                                            Icons.document_scanner_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            size: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(
                                            'Scan Card',
                                            style: kBodyText.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Card Name',
                                counter: SizedBox.shrink(),
                              ),
                              style: kBodyText,
                              maxLength: 20,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                return validate.validateInput(
                                    value, 'card name');
                              },
                              onChanged: (value) {
                                if (_attemptedSave) {
                                  _form.currentState!.validate();
                                }
                              },
                              onSaved: (value) {
                                _enteredCardName = value!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Cardholder Name',
                                counter: SizedBox.shrink(),
                              ),
                              style: kBodyText,
                              maxLength: 40,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                return validate.validateInput(
                                    value, 'cardholder name');
                              },
                              onChanged: (value) {
                                if (_attemptedSave) {
                                  _form.currentState!.validate();
                                }
                              },
                              onSaved: (value) {
                                _enteredCardHolder = value!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: _cardNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Card Number',
                                counter: SizedBox.shrink(),
                              ),
                              maxLength: 16,
                              style: kBodyText,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              validator: (value) {
                                return validate.validateCardNumber(value);
                              },
                              onChanged: (value) {
                                if (_attemptedSave) {
                                  _form.currentState!.validate();
                                }
                              },
                              onSaved: (value) {
                                _enteredCardNumber = value!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: _expirationDateController,
                              decoration: const InputDecoration(
                                labelText: 'Month/Year',
                                hintText: 'MM/YY',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                MonthYearInputFormatter(),
                              ],
                              validator: (value) {
                                return validate.validateExpirationDate(value);
                              },
                              onChanged: (value) {
                                if (_attemptedSave) {
                                  _form.currentState!.validate();
                                }
                              },
                              onSaved: (value) {
                                _enteredExpirationDate = value!;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                counter: SizedBox.shrink(),
                              ),
                              style: kBodyText,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              autocorrect: false,
                              validator: (value) {
                                return validate.validateCvv(value);
                              },
                              onChanged: (value) {
                                if (_attemptedSave) {
                                  _form.currentState!.validate();
                                }
                              },
                              onSaved: (value) {
                                _enteredCvv = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 30),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: _onSaveCard,
                                child: Text(
                                  'Add Card',
                                  style:
                                      kBodyText.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MonthYearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4) {
      text = text.substring(0, 4);
    }
    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
