class GlitchArtService {
  static List<int> extractColorsFromAmount(String amount, int seed) {
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    final digitList = cleanAmount.isEmpty ? [0] : cleanAmount.split('').map(int.parse).toList();

    while (digitList.length < 3) {
      digitList.add((seed + digitList.length) % 10);
    }

    return digitList.take(3).toList();
  }
}
