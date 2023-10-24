extension DateExtension on String? {
  bool isExpired() {
    if (this == null) return true;
    final List<int> serverDateSplitted = this!.split('-').map((e) => int.tryParse(e) ?? 0).toList();
    final DateTime serverDateTime = (serverDateSplitted.length == 5)
        ? DateTime(
            serverDateSplitted[0],
            serverDateSplitted[2],
            serverDateSplitted[3],
            serverDateSplitted[4],
          )
        : DateTime(
            serverDateSplitted[0],
            serverDateSplitted[1],
            serverDateSplitted[2],
          );

    final DateTime now = DateTime.now();
    final DateTime today = (serverDateSplitted.length == 5)
        ? DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            now.minute,
          )
        : DateTime(
            now.year,
            now.month,
            now.day,
          );

    return today.isAfter(serverDateTime);
  }
}
