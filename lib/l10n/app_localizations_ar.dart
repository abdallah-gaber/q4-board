// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لوحة الأولويات';

  @override
  String get board => 'اللوحة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get searchHint => 'ابحث في الملاحظات';

  @override
  String get showDone => 'إظهار المكتمل';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterHideDone => 'إخفاء المكتمل';

  @override
  String get doneFilterControl => 'فلتر المهام المكتملة';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'تراجع';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get title => 'العنوان';

  @override
  String get description => 'الوصف';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get noDueDate => 'بدون تاريخ';

  @override
  String get markDone => 'مكتمل';

  @override
  String get moveTo => 'نقل إلى';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'النظام';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get defaultShowDone => 'الإعداد الافتراضي لإظهار المكتمل';

  @override
  String get syncComingSoon => 'المزامنة (قريبًا)';

  @override
  String get syncComingSoonDesc =>
      'تسجيل الدخول والمزامنة السحابية عبر Firebase ستضاف في المرحلة الثانية.';

  @override
  String get q1Title => 'مهم وعاجل';

  @override
  String get q2Title => 'مهم وغير عاجل';

  @override
  String get q3Title => 'غير مهم وعاجل';

  @override
  String get q4Title => 'غير مهم وغير عاجل';

  @override
  String get q1Label => 'ابدأ الآن';

  @override
  String get q2Label => 'خطط له';

  @override
  String get q3Label => 'فوّضه';

  @override
  String get q4Label => 'استبعده';

  @override
  String get q1TabSemantics => 'قسم ابدأ الآن';

  @override
  String get q2TabSemantics => 'قسم خطط له';

  @override
  String get q3TabSemantics => 'قسم فوّضه';

  @override
  String get q4TabSemantics => 'قسم استبعده';

  @override
  String get emptyQuadrant => 'لا توجد ملاحظات بعد';

  @override
  String get emptySearch => 'لا نتائج مطابقة للبحث';

  @override
  String get noteDeleted => 'تم حذف الملاحظة';

  @override
  String get noteMoved => 'تم نقل الملاحظة';

  @override
  String get requiredTitle => 'العنوان مطلوب';

  @override
  String get clearDueDate => 'مسح التاريخ';

  @override
  String get pickDate => 'اختيار تاريخ';

  @override
  String get doneChip => 'منجز';

  @override
  String get dragToReorder => 'اسحب لإعادة الترتيب';

  @override
  String get resetLocalData => 'إعادة ضبط البيانات المحلية';

  @override
  String get resetLocalDataDesc =>
      'يمسح كل الملاحظات والإعدادات المحفوظة على هذا الجهاز.';

  @override
  String get resetLocalDataConfirmTitle => 'إعادة ضبط البيانات؟';

  @override
  String get resetLocalDataConfirmBody =>
      'سيؤدي هذا إلى حذف كل الملاحظات والإعدادات نهائيًا من هذا الجهاز.';

  @override
  String get resetAction => 'إعادة ضبط';

  @override
  String get localDataResetSuccess => 'تمت إعادة ضبط البيانات المحلية';
}
