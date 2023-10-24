# Flutter Backdoor Package

This package adds a backdoor which checks for payment status for freelancing or other projects

# Requirements

A hosted json file in following [format](assets/example-hosted.json), A single json file can handle multiple projects

# Json Arguments
1. **apps:** Contains all the app objects, if we want to add a new app, Just add there

1. In every app you can add following arguments
    - **status:** it is a mandatory argument, it can have two values
        1. **0:** payment is not done
        1. **1:** payment is done
        > if the payment is done, other arguments are ignored
    
    - **expiryDate:** it's an optional argument, if current datetime is greater than expiry date, unPaid methods will be executed
        > enter date in ```yyyy-M-d``` or ```yyyy-M-d-h-m``` format (24 hours format)

    - **message** optional argument which can be used to sent message if payment is not done, you will receive it in call back

    - **maxLaunch:** number of launches after which app should check online for latest payment status, if not provided, app will always check the servers, although if date is expired app will always check server
        > if maxLaunch is negative, counter value will -100 * maxLaunch i.e. 100 if maxLaunch = -1

        >it Should be in string format
    
    - **developerDetails:** a map of <String,dynamic> type, which will be received  if payment is not done

# Usage
1. add dependency

    ```
    backdoor_flutter:
        git: https://github.com/gktirkha/backdoor_flutter
    ```

1. import 
    ```
    import 'package:backdoor_flutter/backdoor_flutter.dart';
    ```

1.  initialize
    ```
    Backdoor.initialize(
    appName: 'unpaid',
    url: 'https://raw.githubusercontent.com/gktirkha/backdoor_json/master/backdoor.json',
    version: 1,
    hiveBoxName: 'TEST',
    showLogs: true,
    );
    ```
    > you may want to turn off logs by changing showLogs to false

1. call check payment status and implement the call backs
    ```

    await Backdoor.checkPayment(
    onPaid: () {
    log('onPaid', name: 'Your Project');
    },
    onUnpaid: (apiResponse) {
    log('onUnpaid ${apiResponse?.message}', name: 'Your Project');
    },
    onException: (exception) {
    throw (exception);
    },
    onNetworkException: (exception) {
    log('onNetworkException', name: 'Your Project');
    },
    onCounter: ({expiryDate, remainingCounter, storedResponse}) {
    log('onCounter: storedResponse $storedResponse, expiryDate $expiryDate, remainingCounter $remainingCounter ', name: 'Your Project');
    },
    ),
    child: const Text('Check'),
          
    ```

# Example
- [flutter_backdoor_example](https://github.com/gktirkha/backdoor_flutter_example)

```
    import 'dart:developer';

    import 'package:backdoor_flutter/backdoor_flutter.dart';
    import 'package:flutter/material.dart';

    void main() {
    Backdoor.initialize(
    appName: 'unpaid',
    url: 'https://raw.githubusercontent.com/gktirkha/backdoor_flutter/master/assets/example-hosted.json',
    version: 1,
    hiveBoxName: 'TEST',
    showLogs: true,
    );
    runApp(const MainApp());
    }

    class MainApp extends StatelessWidget {
    const MainApp({super.key});

    @override
    Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
    body: Center(
    child: ElevatedButton(
    onPressed: () async => await Backdoor.checkPayment(
    onPaid: () {
    log('onPaid', name: 'Your Project');
    },
    onUnpaid: (apiResponse) {
    log('onUnpaid ${apiResponse?.message}', name: 'Your Project');
    },
    onException: (exception) {
    throw (exception);
    },
    onNetworkException: (exception) {
    log('onNetworkException', name: 'Your Project');
    },
    onCounter: ({expiryDate, remainingCounter, storedResponse}) {
    log('onCounter: storedResponse $storedResponse, expiryDate $expiryDate, remainingCounter $remainingCounter ', name: 'Your Project');
    },
    ),
    child: const Text('Check'),
    ),
    ),
    ),
    );
    }
    }

```

# Additional method
- **isExpired():** extension on ```String?``` which can be used to check if the date provided is expired or not
    - returns yes if string is null
    - only supports ```yyyy-M-d``` and ```yyyy-M-d-h-m``` format


# Flow
- [**png**](assets/flow.png)
- [**drawio**](assets/flow.drawio)
<br/>
<br/>
<img src= assets/flow.png>