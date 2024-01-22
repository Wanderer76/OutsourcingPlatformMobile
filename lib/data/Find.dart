import 'package:outsource_mobile/data/Competencies.dart';

import 'ProjectExecutor.dart';

class FindResult {
  final int count;
  final List<FindProjectItem> orders;

  FindResult(this.count, this.orders);

  factory FindResult.fromJson(Map<String, dynamic> json) {
    return FindResult(
      json["count"],
      List<FindProjectItem>.from(json["orders"].map((e) => FindProjectItem.fromJson(e))),
    );
  }



}

class FindProjectItem {
  final bool isCompleted;
  final int orderId;
  final String name;
  final String companyName;
  final String deadline;
  final List<Competency> skills;
  final List<OrderVacancy> vacancies;

  factory FindProjectItem.fromJson(Map<String, dynamic> json) {
    return FindProjectItem(
        json["isCompleted"],
        json["orderId"],
        json["name"],
        json["companyName"],
        json["deadline"],
        List<Competency>.from(json["orderSkills"]["skills"].map((e) => Competency.fromJson(e))),
      List<OrderVacancy>.from(json["vacancies"].map((e) => OrderVacancy.fromJson(e))),
    );
  }

  FindProjectItem(this.isCompleted, this.orderId, this.name, this.companyName, this.deadline, this.skills, this.vacancies);

}