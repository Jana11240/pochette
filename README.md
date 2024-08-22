<!--![alt text](<Screenshot 2024-08-21 at 21.43.34.png>) 

270 105
470 705

-->

<img src="Screenshot 2024-08-21 at 21.43.34.png" alt="alt text" width="300"/>

## What is Pochette?

**Pochette** is a robust credit card validator and wallet application that securely and persistently stores credit cards after they pass a certain validation process. Pochette was made using flutter. 

## Minimum Requirements Achieved

1. Users can submit credit card details through a simple form, entering the chosen name of the card, cardholder name, card number, expiration date and CVV.
2. The country of issuance and card type are inferred using the first six digits of the card number, known as the INN/BIN number.
3. Credit cards are stored only if the issuer's country is not on the configurable banned-countries list.
4. The banned-countries list is user-configurable.
5. Valid credit cards are stored in local storage.
6. Credit cards captured during a session are displayed.
7. Duplicate cards cannot be captured.
8. Users can also add a card using OCR scanning.

## Additional Features for a Complete Product

1. Users can swipe to delete unwanted cards from the wallet.
2. Cards are *persistently* stored, allowing users to view card additions from previous sessions. A "Delete All" option is available for removing all stored cards.
3. AES-256 encryption and decryption were used to store the cards, ensuring that sensitive information remains inaccessible to unauthorized parties.

## Demonstration

A video of the app running on a mobile device can be seen here: youtube.com/immabeast

![alt text](imgonline-com-ua-twotoone-ra0zucDOs0t.png)
![alt text](imgonline-com-ua-twotoone-913vd1c8ByT3.png)







