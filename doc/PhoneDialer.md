# Phone Dialer

## Using Phone Dialer
```dart
import 'package:flutter_essentials/phone_dialer.dart';
```

The Phone Dialer functionality works by calling the Open method with a phone number to open the dialer with. When Open is requested the API will automatically attempt to format the number based on the country code if specified.

## Check if Supported
```dart
 await PhoneDialer.isSupported();
```

## Opening Dialer
```dart
    try {
      await PhoneDialer.open("5555555555");
    } on ArgumentError catch(e){
        // Number was null or white space
    } catch(e) {
       // Phone Dialer is not supported on this device.
       // Other error has occurred.
    }

```