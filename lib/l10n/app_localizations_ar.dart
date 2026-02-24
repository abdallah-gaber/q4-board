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
  String get syncSectionTitle => 'المزامنة السحابية';

  @override
  String get syncUnavailable => 'المزامنة السحابية غير متاحة';

  @override
  String get syncConnected => 'المزامنة السحابية جاهزة';

  @override
  String get syncNotSignedIn => 'سجّل الدخول لتفعيل المزامنة السحابية';

  @override
  String get syncNotConfiguredHelp =>
      'لم يتم إعداد Firebase بعد. شغّل FlutterFire configure واستبدل ملف firebase_options.dart.';

  @override
  String get syncSignIn => 'تسجيل الدخول';

  @override
  String get syncSignOut => 'تسجيل الخروج';

  @override
  String get syncPush => 'رفع';

  @override
  String get syncPull => 'سحب';

  @override
  String get syncSignedIn => 'تم تسجيل الدخول بنجاح';

  @override
  String get syncSignedOut => 'تم تسجيل الخروج';

  @override
  String get syncErrorGeneric => 'فشلت عملية المزامنة السحابية';

  @override
  String get syncStatusUnavailable => 'Firebase غير متاح (وضع محلي فقط).';

  @override
  String get syncStatusIdle => 'جاهز';

  @override
  String get syncStatusAuthRequired => 'يلزم تسجيل الدخول';

  @override
  String get syncStatusPushing => 'جارٍ رفع الملاحظات المحلية إلى السحابة...';

  @override
  String get syncStatusPulling =>
      'جارٍ سحب الملاحظات السحابية إلى هذا الجهاز...';

  @override
  String get syncStatusSuccess => 'اكتملت المزامنة';

  @override
  String get syncStatusError => 'فشلت المزامنة';

  @override
  String get syncStatusPushComplete => 'اكتمل الرفع';

  @override
  String get syncStatusPullComplete => 'اكتمل السحب';

  @override
  String get syncStatusPushCompleteConflicts =>
      'اكتمل الرفع (تم الاحتفاظ بالتعديلات الأحدث في السحابة)';

  @override
  String get syncStatusPullCompleteConflicts =>
      'اكتمل السحب (تم الاحتفاظ بالتعديلات الأحدث محليًا)';

  @override
  String get syncStatusPullRemoteEmptyLocalKept =>
      'السحابة فارغة؛ تم الاحتفاظ بالملاحظات المحلية (حماية من الحذف)';

  @override
  String syncUserId(String userId) {
    return 'المستخدم: $userId';
  }

  @override
  String syncPushDone(int upserts, int deletes, int skipped) {
    return 'اكتمل الرفع: تم تحديث $upserts، وحذف $deletes، وتخطي $skipped تعارضات';
  }

  @override
  String syncPullDone(int upserts, int deletes, int skipped) {
    return 'اكتمل السحب: تم تحديث $upserts، وحذف $deletes محليًا، وتخطي $skipped تعارضات';
  }

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
  String get loadDemoData => 'تحميل بيانات تجريبية';

  @override
  String get loadDemoDataDesc =>
      'استبدال الملاحظات المحلية ببيانات جاهزة لالتقاط لقطات الشاشة.';

  @override
  String demoDataLoaded(int count) {
    return 'تم تحميل $count ملاحظات تجريبية';
  }

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
