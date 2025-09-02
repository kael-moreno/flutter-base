/// Abstract interface for local counter data operations
abstract class CounterLocalDataSource {
  /// Get the current counter value from local storage
  Future<int> getCounter();
  
  /// Save the counter value to local storage
  Future<void> saveCounter(int value);
  
  /// Clear the counter from local storage
  Future<void> clearCounter();
}

/// Implementation of local data source using in-memory storage
/// In a real app, this would use SharedPreferences, Hive, etc.
class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  static int _counter = 0;

  @override
  Future<int> getCounter() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    return _counter;
  }

  @override
  Future<void> saveCounter(int value) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 50));
    _counter = value;
  }

  @override
  Future<void> clearCounter() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 50));
    _counter = 0;
  }
}
