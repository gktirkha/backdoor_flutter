/// A class that defines static keys used for accessing storage in the application.
///
/// These keys are used to retrieve or store specific pieces of data related
/// to the application’s functionality, such as version information and payment models.
abstract class StorageServiceKeys {
  /// A base reference string used as a prefix for all storage keys.
  static String get _ref => 'BACKDOOR_FLUTTER_REF_';

  /// Key for accessing the version information in storage.
  ///
  /// This key is used to retrieve or store the version of the application.
  static String get version => '${_ref}VERSION';

  /// Key for accessing the payment model in storage.
  ///
  /// This key is used to retrieve or store the payment model details,
  static String get paymentModel => '${_ref}PAYMENT_MODEL';

  /// Key for accessing the launch count in storage.
  ///
  /// This key is used to retrieve or store the launch counter
  static String get launchCount => '${_ref}LAUNCH_COUNT';
}
