abstract class FromToMap {
  // factory method;  using null should make a default object equivalent
  // to reset() of a current object.

  FromToMap Function(Map<String, dynamic>? map) get fromMapFactory;

  // reset to factory defaults (as if built from a null json object)
  void reset();
  void updateWithMap(Map<String, dynamic> map);
  // set object according to json document.
  void setWithMap(Map<String, dynamic>? map) {
    reset();
    if (map != null) updateWithMap(map);
  }

  // get json document representing object, suitible for cloning with the
  // factory method or reseting to this state using setInJson().
  Map<String, dynamic> toMap();

  @override
  bool operator ==(Object other) =>
      other is FromToMap && other.toMap() == toMap();

  @override
  int get hashCode => toMap().hashCode;
}
