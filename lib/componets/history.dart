class HistoryEntry {
  final String receiptId;
  final String vehicleNumber;
  final String vehicleType;
  final DateTime checkOutTime;
  final double price;

  HistoryEntry({
    required this.receiptId,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.checkOutTime,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'receiptId': receiptId,
        'vehicleNumber': vehicleNumber,
        'vehicleType': vehicleType,
        'checkOutTime': checkOutTime.toIso8601String(),
        'price': price,
      };

  static HistoryEntry fromJson(Map<String, dynamic> json) => HistoryEntry(
        receiptId: json['receiptId'],
        vehicleNumber: json['vehicleNumber'],
        vehicleType: json['vehicleType'],
        checkOutTime: DateTime.parse(json['checkOutTime']),
        price: json['price'],
      );
}
