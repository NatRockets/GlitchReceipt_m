class Receipt {
  final String id;
  final String amount;
  final DateTime scannedAt;
  final String? note;
  final String? glitchArtId;
  final String? qrContent;

  Receipt({
    required this.id,
    required this.amount,
    required this.scannedAt,
    this.note,
    this.glitchArtId,
    this.qrContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'scannedAt': scannedAt.toIso8601String(),
      'note': note,
      'glitchArtId': glitchArtId,
      'qrContent': qrContent,
    };
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      amount: json['amount'],
      scannedAt: DateTime.parse(json['scannedAt']),
      note: json['note'],
      glitchArtId: json['glitchArtId'],
      qrContent: json['qrContent'],
    );
  }

  Receipt copyWith({
    String? id,
    String? amount,
    DateTime? scannedAt,
    String? note,
    String? glitchArtId,
    String? qrContent,
  }) {
    return Receipt(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      scannedAt: scannedAt ?? this.scannedAt,
      note: note ?? this.note,
      glitchArtId: glitchArtId ?? this.glitchArtId,
      qrContent: qrContent ?? this.qrContent,
    );
  }
}
