class Receipt {
  final String id;
  final String amount;
  final DateTime scannedAt;
  final String? note;
  final String? glitchArtId;

  Receipt({
    required this.id,
    required this.amount,
    required this.scannedAt,
    this.note,
    this.glitchArtId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'scannedAt': scannedAt.toIso8601String(),
      'note': note,
      'glitchArtId': glitchArtId,
    };
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      amount: json['amount'],
      scannedAt: DateTime.parse(json['scannedAt']),
      note: json['note'],
      glitchArtId: json['glitchArtId'],
    );
  }

  Receipt copyWith({
    String? id,
    String? amount,
    DateTime? scannedAt,
    String? note,
    String? glitchArtId,
  }) {
    return Receipt(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      scannedAt: scannedAt ?? this.scannedAt,
      note: note ?? this.note,
      glitchArtId: glitchArtId ?? this.glitchArtId,
    );
  }
}
