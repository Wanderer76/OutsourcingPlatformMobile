import "package:outsource_mobile/data/Competencies.dart";


class ProjectCreate {
  final String name;
  final String description;
  final String deadline;
  final List<Competency> orderCategories;
  final List<Competency> orderSkills;
  final List<Vacancy> orderVacancies;
  final int price = 0;

  ProjectCreate(this.name, this.description, this.deadline, this.orderCategories, this.orderSkills, this.orderVacancies);

  Map<String, dynamic> toJson() => {
    'name' : name,
    'description' : description,
    "deadline" : deadline,
    "orderCategories": orderCategories.map((e) => e.toJson()).toList(),
    "orderSkills" : orderSkills.map((e) => e.toJson()).toList(),
    "orderVacancies" : orderVacancies.map((e) => e.toJson()).toList(),
    "maxWorkers" : "1",
    "price": 0
  };

}

class Vacancy {
  String maxWorkers;
  final OrderRole orderRole;

  Vacancy(this.maxWorkers, this.orderRole);


  Map<String, dynamic> toJson() => {
    "maxWorkers" : maxWorkers,
    "orderRole" : orderRole.toJson()
  };


}

class OrderRole {
  final String name;

  OrderRole(this.name);

  Map<String, dynamic> toJson() => {
    "name" : name
  };

  factory OrderRole.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      "name": String name,
      } =>
          OrderRole(name),
      _ => throw const FormatException('Failed to get user auth response'),
    };
  }
}