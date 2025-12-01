class GlitchArt {
  final String id;
  final String receiptId;
  final String amount;
  final int seed;
  final DateTime generatedAt;
  final String? qrContent;

  GlitchArt({
    required this.id,
    required this.receiptId,
    required this.amount,
    required this.seed,
    required this.generatedAt,
    this.qrContent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiptId': receiptId,
      'amount': amount,
      'seed': seed,
      'generatedAt': generatedAt.toIso8601String(),
      'qrContent': qrContent,
    };
  }

  factory GlitchArt.fromJson(Map<String, dynamic> json) {
    return GlitchArt(
      id: json['id'],
      receiptId: json['receiptId'],
      amount: json['amount'],
      seed: json['seed'],
      generatedAt: DateTime.parse(json['generatedAt']),
      qrContent: json['qrContent'],
    );
  }
}
