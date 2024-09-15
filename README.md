# Flutter Backdoor Package

This package adds a backdoor which checks for payment status for freelancing or other projects

# Requirements

A hosted json file in following [format](assets/example-hosted.json), A single json file can handle multiple projects

# Json Arguments
1. **apps:** Contains all the app objects, if we want to add a new app, Just add there

1. In every app you can add following arguments
    - **status:** it is a mandatory argument, it can have following value
        1. **PAID:** payment is not done
        1. **UNPAID:** payment is done
        1. **ALLOW_LIMITED_LAUNCHES:** use max launch mechanism
        1. **ON_TRIAL:** use expire date mechanism
    
    - **expiryDate:** it's an optional argument, if current datetime is greater than expiry date, unPaid methods will be executed
        > enter date in ```yyyy-M-d``` or ```yyyy-M-d-h-m``` format (24 hours format)

    - **message** optional argument which can be used to sent message if payment is not done, you will receive it in call back

    - **maxLaunch:** number of launches after which app should check online for latest payment status, if not provided, app will always check the servers, although if date is expired app will always check server
        > if maxLaunch is negative, counter value will -100 * maxLaunch i.e. 100 if maxLaunch = -1

        >it Should be in string format
    
    - **developerDetails:** a map of <String,dynamic> type, which will be received  if payment is not done
    - **should_check_after_paid** if we want to check / hit api even after status is paid
    - **max_launch** no of times to allow launch **ALLOW_LIMITED_LAUNCHES** mechanism, if negative the value is multiplied by 100.
    - **expiry_date** no of times to allow launch **ON_TRIAL** mechanism.
    - **strict_max_launch** resets max launch counter if set to false and max launch limit exceeds.

# Usage
1. add dependency

    ```
    backdoor_flutter:
        git: https://github.com/gktirkha/backdoor_flutter
    ```
1. in code 
    ``` dart
    import 'dart:developer';

    import 'package:backdoor_flutter/backdoor_flutter.dart';
    import 'package:flutter/material.dart';

    void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await BackdoorFlutter.initialize(
        appName:
            "ALLOW_LIMITED_LAUNCHES_WITH_NEGATIVE_MAX_LAUNCH_STRICT_LAUNCH_FALSE",
        autoDecrementLaunchCounter: true,
        jsonUrl:
            "https://raw.githubusercontent.com/gktirkha/backdoor_flutter/beta/assets/example-hosted.json",
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
                onPressed: () {
                BackdoorFlutter.checkAppStatus(
                    onException: (exception, paymentStatusModel) {
                    log(
                        "Exception $exception",
                    );
                    },
                    onLimitedLaunches: (paymentStatusModel, currentLaunchCount) {
                        log("onLimitedLaunches, $currentLaunchCount");
                    },
                    onLimitedLaunchesExceeded: (paymentStatusModel) {
                        log("onLimitedLaunchesExceeded");
                    },
                    onPaid: (paymentStatusModel) {
                        log("onPaid");
                    },
                    onTrial: (paymentStatusModel) {
                        log("onTrial");
                    },
                    onTrialExpire: (paymentStatusModel) {
                        log("onTrialExpire");
                    },
                    onUnpaid: (paymentStatusModel) {
                        log("onUnpaid");
                    },
                    onAppNotFoundInNJson: (apiResponse) {
                        log("onAppNotFoundInNJson");
                    },
                );
                },
                child: const Text("data"),
            ),
            ),
        ),
        );
    }
    }

    ```

# License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.