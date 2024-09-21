# Flutter Backdoor Package

This package adds a backdoor which checks for payment status for freelancing or other projects

# Requirements

A hosted json file in following [format](https://raw.githubusercontent.com/gktirkha/backdoor_flutter/refs/heads/master/assets/example-hosted.json), A single json file can handle multiple projects

# Json Arguments
1. **apps:** Contains all the app objects, if we want to add a new app, Just add there

1. In every app you can add following arguments
    - **status:** it is a mandatory argument, it can have following value
        1. **PAID:** payment is not done
        1. **UNPAID:** payment is done
        1. **ALLOW_LIMITED_LAUNCHES:** use max launch mechanism
        1. **ON_TRIAL:** use expire date mechanism
    
    - **target_version** to check Against backdoor version configured in code (should be greater than 0)
    - **should_check_after_paid** to force check json online even after status is paid (once set to false, devices with cached data will not have any effect after setting to true)
    - **check_during_trial** to force check json online in trial period (once set to false, devices with cached data will not have any effect after setting to true)
    - **expire_date** expiry date for **ON_TRIAL** mechanism
    - **warning_date** to issue warning in **ON_TRIAL** mechanism
    - **max_launch** number of launches after which online json should be checked in **ALLOW_LIMITED_LAUNCHES** Mechanism
    - **strict_max_launch** if set to false, (default true in flutter code) the launch count will reset in flutter code. if set to true, after launch exceeds OnLimitedLaunchExceeded will be called, else launch count will reset.
    - **developer_details** a json object (Map), optional
    - **additional_fields** you can literally send any thing



# Flow Chart For Whole Mechanism 
1. [image file](https://github.com/gktirkha/backdoor_flutter/blob/master/assets/flow.png) 
2. [draw.io](https://github.com/gktirkha/backdoor_flutter/blob/master/assets/flow.drawio)

# Usage

> Please Refer To dart [Dart Doc Version](https://gktirkha.github.io/flutter_packages_doc/backdoor_flutter)

1. add dependency

    ``` yaml
    dependencies:
        backdoor_flutter: ^latest_version
    ```
1. in code 
    ``` dart
    import 'dart:developer';

    import 'package:backdoor_flutter/backdoor_flutter.dart';
    import 'package:flutter/material.dart';

    void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await BackdoorFlutter.init(
        jsonUrl:
            "https://raw.githubusercontent.com/gktirkha/backdoor_flutter/beta/assets/example-hosted.json",
        appName: "trial_expire",
        version: 1,
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
                BackdoorFlutter.checkStatus(
                    onException: (exception) {
                        log(exception.toString(), name: "onException");
                    },
                    onUnhandled: (reason, backdoorPaymentModel) {
                        log(reason.name, name: "onUnhandled");
                        log(backdoorPaymentModel.toString(), name: "onUnhandled");
                    },
                    onAppNotFound: () {
                        log("onAppNotFound", name: "onAppNotFound");
                    },
                    onLimitedLaunch: (backdoorPaymentModel, currentCount) {
                        log(currentCount.toString(), name: "onLimitedLaunch");
                        log(backdoorPaymentModel.toString(), name: "onLimitedLaunch");
                    },
                    onLimitedLaunchExceeded: (backdoorPaymentModel) {
                        log(backdoorPaymentModel.toString(),
                        name: "onLimitedLaunchExceeded");
                    },
                    onPaid: (backdoorPaymentModel) {
                        log(backdoorPaymentModel.toString(), name: "onPaid");
                    },
                    onTargetVersionMisMatch:
                        (backdoorPaymentModel, targetVersion, configuredVersion) {
                        log(backdoorPaymentModel.toString(),
                        name: "onTargetVersionMisMatch");
                        log(targetVersion.toString(),
                        name: "onTargetVersionMisMatch Target Version");
                        log(configuredVersion.toString(),
                        name: "onTargetVersionMisMatch Configured Version");
                    },
                    onTrial: (backdoorPaymentModel, expiryDate, warningDate) {
                        log(backdoorPaymentModel.toString(), name: "onTrial");
                        log(expiryDate.toString(), name: "onTrial expiryDate");
                        log(warningDate.toString(), name: "onTrial warningDate");
                    },
                    onTrialEnded: (backdoorPaymentModel, expiryDate) {
                        log(backdoorPaymentModel.toString(), name: "onTrialEnded");
                        log(expiryDate.toString(), name: "onTrialEnded expiryDate");
                    },
                    onTrialWarning:
                        (backdoorPaymentModel, expiryDate, warningDate) {
                        log(backdoorPaymentModel.toString(), name: "onTrialWarning");
                        log(expiryDate.toString(), name: "onTrialWarning expiryDate");
                        log(warningDate.toString(),
                        name: "onTrialWarning warningDate");
                    },
                    onUnPaid: (backdoorPaymentModel) {
                        log(backdoorPaymentModel.toString(), name: "onUnPaid");
                    },
                );
                },
                child: const Text("Check App"),
            ),
            ),
        ),
        );
    }
    }

    ```

# License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.