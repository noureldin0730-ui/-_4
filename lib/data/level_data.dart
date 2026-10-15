import 'package:flutter/material.dart';

/// ============================================================
/// LEVEL DATA — خريطة البيطاش
/// رموز الخريطة:
///   '.' = فاضي (خارج اللعب)
///   'R' = طريق (أسفلت)
///   'S' = رصيف (رملي)
///   'G' = نجيل
///   'B' = مبنى (شكل عام)
///   'C' = مقهى
///   'K' = سوق
///   'P' = محطة زباين
///   'H' = بيت اللاعب (نقطة البداية)
/// ============================================================
class LevelData {
  static const int cols = 20;
  static const int rows = 20;

  // خريطة البيطاش — 20×20
  static const List<String> bitashMap = [
    'BBBBBBBBBBBBBBBBBBBB',
    'BSSSSSSSSSSSSSSSSSSB',
    'BSRRRRRRRRRRRRRRRRSB',
    'BSRBBBBRBBBBBRBBRRSB',
    'BSRBC..CRB...BRB.RRSB',
    'BSRB....RB...BRB.RRSB',
    'BSRBP...RP...RP..RRSB',
    'BSRB....RB...BRB.RRSB',
    'BSRBBBBRBBBBBRBBRRSB',
    'BSRRRRRRRRRRRRRRRRSB',
    'BSRRRRRRRRRRRRRRRRSB',
    'BSRBBBBBRBBBBBRBRRSB',
    'BSRB...BRB....BRBRRSB',
    'BSRBP..BRBP...BRBRRSB',
    'BSRB...BRB....BRBRRSB',
    'BSRBBBBBRBBBBBRBRRSB',
    'BSRRRRRRRRRRRRRRRRSB',
    'BSRRRRRRRRRRRRRRRRSB',
    'BSSSSSSSSSSSSSSSSSSB',
    'BBBBBBBBBBBBBBBBBBBB',
  ];

  // نقطة بداية اللاعب (في نص الشارع الرئيسي)
  static const int playerStartX = 2;
  static const int playerStartY = 10;

  // المحطات — (x, y) — كل محطة فيها زبون
  static const List<Map<String, dynamic>> stations = [
    {'x': 4,  'y': 6,  'name': 'سوق البيطاش',      'color': 0xFFE8A898},
    {'x': 14, 'y': 6,  'name': 'قهوة البيطاش',     'color': 0xFFA8D0E6},
    {'x': 4,  'y': 13, 'name': 'شارع البيطاش',     'color': 0xFFF5EDD8},
    {'x': 14, 'y': 13, 'name': 'محطة البيطاش',     'color': 0xFFA8D0E6},
    {'x': 9,  'y': 3,  'name': 'مخبز البيطاش',    'color': 0xFFE8A898},
    {'x': 9,  'y': 16, 'name': 'عمارة البيطاش',   'color': 0xFFF5EDD8},
  ];

  // المباني — (x, y, w, h, type)
  // type: 'cafe' / 'shop' / 'house' / 'market'
  static const List<Map<String, dynamic>> buildings = [
    // الصف الأول (فوق)
    {'x': 3,  'y': 3,  'w': 2, 'h': 2, 'type': 'house',  'label': 'بيت'},
    {'x': 6,  'y': 3,  'w': 2, 'h': 2, 'type': 'market', 'label': 'سوق'},
    {'x': 10, 'y': 3,  'w': 2, 'h': 2, 'type': 'cafe',   'label': 'قهوة'},
    {'x': 14, 'y': 3,  'w': 2, 'h': 2, 'type': 'shop',   'label': 'محل'},
    {'x': 17, 'y': 3,  'w': 2, 'h': 2, 'type': 'house',  'label': 'بيت'},

    // الصف التاني (وسط فوق)
    {'x': 3,  'y': 8,  'w': 2, 'h': 2, 'type': 'shop',   'label': 'بقالة'},
    {'x': 7,  'y': 8,  'w': 3, 'h': 2, 'type': 'market', 'label': 'سوق البيطاش'},
    {'x': 12, 'y': 8,  'w': 2, 'h': 2, 'type': 'cafe',   'label': 'قهوة'},
    {'x': 16, 'y': 8,  'w': 3, 'h': 2, 'type': 'shop',   'label': 'محل'},

    // الصف التالت (وسط تحت)
    {'x': 3,  'y': 11, 'w': 2, 'h': 2, 'type': 'house',  'label': 'عمارة'},
    {'x': 7,  'y': 11, 'w': 3, 'h': 2, 'type': 'market', 'label': 'سوق'},
    {'x': 12, 'y': 11, 'w': 2, 'h': 2, 'type': 'cafe',   'label': 'قهوة'},
    {'x': 16, 'y': 11, 'w': 3, 'h': 2, 'type': 'shop',   'label': 'محل'},

    // الصف الأخير (تحت)
    {'x': 3,  'y': 15, 'w': 2, 'h': 2, 'type': 'house',  'label': 'بيت'},
    {'x': 6,  'y': 15, 'w': 2, 'h': 2, 'type': 'shop',   'label': 'محل'},
    {'x': 10, 'y': 15, 'w': 2, 'h': 2, 'type': 'cafe',   'label': 'قهوة'},
    {'x': 14, 'y': 15, 'w': 2, 'h': 2, 'type': 'market', 'label': 'سوق'},
    {'x': 17, 'y': 15, 'w': 2, 'h': 2, 'type': 'house',  'label': 'بيت'},
  ];

  // النخل (للزينة) — (x, y)
  static const List<List<int>> palms = [
    [2, 2], [17, 2],
    [2, 9], [17, 9],
    [2, 17], [17, 17],
  ];

  // أعمدة النور — (x, y)
  static const List<List<int>> lamps = [
    [6, 9], [13, 9],
    [6, 14], [13, 14],
  ];

  /// نرجع لون الأرضية حسب الرمز
  static Color tileColor(String code) {
    switch (code) {
      case 'R': return const Color(0xFF5A5A66); // أسفلت
      case 'S': return const Color(0xFFE8C99B); // رصيف رملي
      case 'G': return const Color(0xFF7BA05B); // نجيل
      default:  return const Color(0xFFE8C99B);
    }
  }

  /// نرجع نوع المبنى حسب الرمز
  static String buildingType(String label) {
    if (label.contains('قهوة')) return 'cafe';
    if (label.contains('سوق')) return 'market';
    if (label.contains('عمارة') || label.contains('بيت')) return 'house';
    return 'shop';
  }
}