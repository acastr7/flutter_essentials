# Accelerometer

## Using Accelerometer
```dart
import 'package:flutter_essentials/accelerometer.dart';
```

## Check if Supported
```dart
 await Accelerometer.isSupported();
```

The Accelerometer functionality works by calling the Start and Stop methods to listen for changes to the acceleration. Any changes are sent back through the ReadingChanged event. Here is sample usage:

## Starting Accelerometer
```dart
try {

    await Accelerometer.start(SensorSpeed.UI);

} catch(e) {
    
}

```

## Listening to Accelerometer Data Events
```dart
StreamBuilder<AccelerometerData>(
    stream: Accelerometer.accelerometerDataController.stream
        .asBroadcastStream(),
    builder: (BuildContext context,
        AsyncSnapshot<AccelerometerData> snapshot) {
    if (snapshot.hasError) {
        return Text('Values: ${snapshot.error}');
    }

    if (snapshot.hasData) {
        return Column(
        children: <Widget>[
            Text('X: ${snapshot.data.acceleration.x}'),
            Text('Y: ${snapshot.data.acceleration.y}'),
            Text('Z: ${snapshot.data.acceleration.z}')
        ],
        );
    }

    return Text('Values: No Values Collected');
    },
)

```

## Listening to Accelerometer Shake Events
```dart
StreamBuilder<bool>(
    stream: Accelerometer.shakeDetectedController.stream.asBroadcastStream(),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
            return Text('Values: ${snapshot.error}');
        }

        if (snapshot.hasData) {
            return Container(
                height: 50,
                color: snapshot.data ? Colors.green : Colors.red,
                child: Text('IsShaking: ${snapshot.data}'),
            );
        }

        return Text('IsShaking: false');
    },
)

```


## Stopping Accelerometer
```dart
try {

    await Accelerometer.stop();

} catch(e) {
    
}

```