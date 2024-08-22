<img width="307" alt="Screenshot 2024-08-21 at 21 43 34" src="https://github.com/user-attachments/assets/19edbd79-1136-4495-90e6-5d65362acc74">

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

A video of the app running on a mobile device can be seen here: [https://www.youtube.com/watch?v=jfsva6VBydI]

<img src="https://github.com/user-attachments/assets/59f1527d-5537-4d66-8950-b5171e84c425" alt="IMG_5537" width="200"/>

<img src="https://github.com/user-attachments/assets/601848e2-3a27-4a98-8248-6ffec96dec54" alt="IMG_5539" width="200"/>

<img src="https://github.com/user-attachments/assets/1b9000f0-4aff-49b4-adc6-1c9bc3fe7b21" alt="IMG_5540" width="200"/>

<img src="https://github.com/user-attachments/assets/a3e77896-d169-46b6-8d25-5c2319f81b9b" alt="IMG_5541" width="200"/>

<img src="https://github.com/user-attachments/assets/4b4aae46-1875-4321-b6e5-b65db9743736" alt="IMG_5538" width="200"/>

<img src="https://github.com/user-attachments/assets/5e26bbb8-8d72-4acf-899d-d723f13e81fd" alt="IMG_5542" width="200"/>














