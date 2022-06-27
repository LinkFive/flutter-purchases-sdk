import 'dart:async';

import 'package:linkfive_purchases/linkfive_purchases.dart';

extension LinkFiveInitilizeExtension on LinkFivePurchasesMain {
  ///
  /// For some cases, we want to make sure that LinkFive is initialized
  ///
  /// This method is throwing an Error whenever the API is not initialized.
  ///
  void makeSureIsInitialize() {
    if (!isInitialized.isCompleted) {
      throw UnsupportedError(
          "Please Initialize LinkFive first with your API key.");
    }
  }

  ///
  /// Sometimes, the Plugin just needs to wait until the
  ///
  Future<void> waitForInit() async {
    if (isInitialized.isCompleted) {
      return;
    }
    LinkFiveLogger.t("Waiting call until LinkFive is finished initialized");
    await isInitialized.future;
    LinkFiveLogger.t("Done waiting. Proceeding now");
  }

  ///
  /// This will complete the Initialization process
  ///
  finishInitialize() {
    isInitialized.complete(true);
  }
}
