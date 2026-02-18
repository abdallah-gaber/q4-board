abstract interface class SyncRepository {
  Stream<String> watchStatus();

  Future<void> push();

  Future<void> pull();
}
