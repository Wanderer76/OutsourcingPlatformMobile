import 'package:outsource_mobile/data/ProjectCreate.dart';

import 'Competencies.dart';



class ProjectExecutor {
  final int executorId;
  final String city;
  final int completedOrders;
  final String email;
  final String fio;
  final bool? isAccepted;
  final bool isCompleted;
  final bool isRated;
  final bool isResourceUploaded;
  final OrderVacancy orderVacancy;
  final String phone;
  final int responseId;
  final List<Competency> skills;
  final String username;

  factory ProjectExecutor.fromJson(Map<String, dynamic> json) {
      // {
      // "executorId" : int executorId,
      // "city" : String city,
      // "completedOrders" : int completedOrders,
      // "email" : String email,
      // "fio" : String fio,
      // "isAccepted" : bool isAccepted,
      // "isCompleted" : bool isCompleted,
      // "isRated" : bool isRated,
      // "isResourceUploaded" : bool isResourceUploaded,
      // "orderVacancy" : Map<String, dynamic> orderVacancy,
      // "phone" : String phone,
      // "responseId" : int responseId,
      // "skills" : List<Map<String, dynamic>> skills,
      // "username" : String username,
      // }
      return ProjectExecutor(
          json["executorId"],
          json["city"],
          json["completedOrders"],
          json["email"],
          json["fio"],
          json["isAccepted"],
          json["isCompleted"],
          json["isRated"],
          json["isResourceUploaded"],
          OrderVacancy.fromJson(json["orderVacancy"]),
          json["phone"],
          json["responseId"],
          List<Competency>.from(json["skills"].map((e) => Competency.fromJson(e))),
          json["username"]
      );
  }

  ProjectExecutor(this.executorId, this.city, this.completedOrders, this.email, this.fio, this.isAccepted, this.isCompleted, this.isRated, this.isResourceUploaded, this.orderVacancy, this.phone, this.responseId, this.skills, this.username);

}

class OrderVacancy {
  final int id;
  final int maxWorkers;
  final OrderRole orderRole;

  OrderVacancy(this.id, this.maxWorkers, this.orderRole);

  factory OrderVacancy.fromJson(Map<String, dynamic> json) {
      // {
      // "id" : int id,
      // "maxWorkers": int maxWorkers,
      // "orderRole": Map<String, dynamic> orderRole,
      // } =>
      return OrderVacancy(json["id"], json["maxWorkers"], OrderRole.fromJson(json["orderRole"]));
      // _ => throw const FormatException('Failed to get user auth response'),
  }



}