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
