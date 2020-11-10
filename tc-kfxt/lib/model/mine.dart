class Mine {
  int offline_count = 0;
  int collect_count = 0;

  static Mine fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    Mine mine = Mine();
    mine.offline_count = map["offline_count"];
    mine.collect_count = map["collect_count"];
    return mine;
  }

  Map tojson() => {
    "offline_count": offline_count,
    "collect_count": collect_count,
  };
}