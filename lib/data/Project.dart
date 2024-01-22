import 'ProjectExecutor.dart';

class Project {
  final String companyName;
  final String deadline;
  final String name;
  final String description;
  final String phone;
  final String email;
  final bool isCompleted;
  final bool isResponded;
  final bool isAccepted;
  final List<OrderVacancy> orderVacancies;



  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        json["companyName"],
        json["deadline"],
        json["name"],
        json["description"],
        json["phone"],
        json["email"],
        json["isCompleted"],
        List<OrderVacancy>.from(json["orderVacancies"].map((e) => OrderVacancy.fromJson(e))),
        json["isAccepted"],
        json["isResponded"],
    );
  }

  Project(this.companyName, this.deadline, this.name, this.description, this.phone, this.email, this.isCompleted, this.orderVacancies, this.isAccepted, this.isResponded);


}