class Medecament {
  int id;
  String name;
  double presentation;

  Medecament(this.id, this.name,
      this.presentation
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'presentation': presentation,
    };
    return map;
  }

  Medecament.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    presentation = map ['presentation'];
  }
}
