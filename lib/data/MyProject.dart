import 'ProjectExecutor.dart';

class MyProject {
  final String companyName;
  final String deadline;
  final String name;
  final String description;
  final List<ProjectExecutor> executorResponse;
  final String phone;
  final String email;
  final bool isCompleted;




  factory MyProject.fromJson(Map<String, dynamic> json) {
      return MyProject(
          json["companyName"],
          json["deadline"],
          json["name"],
          json["description"],
          List<ProjectExecutor>.from(json["executorResponse"].map((e) => ProjectExecutor.fromJson(e))),
          json["phone"],
          json["email"],
          json["isCompleted"]

      );
  }

  MyProject(this.companyName, this.deadline, this.name, this.description, this.executorResponse, this.phone, this.email, this.isCompleted);


}