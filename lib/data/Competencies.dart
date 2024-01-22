class Competency {
  final int id;
  final String name;

  Competency(this.id, this.name);

  factory Competency.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      "id" : int id,
      "name": String name,
      } =>
          Competency(id, name),
      _ => throw const FormatException('Failed to get user auth response'),
    };
  }

  Map<String, dynamic> toJson() => {
    "id" : -1,
    "name": name
  };
}
