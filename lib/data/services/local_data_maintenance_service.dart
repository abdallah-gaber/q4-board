import '../hive/hive_initializer.dart';

class LocalDataMaintenanceService {
  const LocalDataMaintenanceService();

  Future<void> resetAllLocalData() {
    return HiveInitializer.resetLocalData();
  }
}
