import 'package:intl/intl.dart';

class ProjectItem {
  final bool isComplete;
  final int orderId;
  final String name;
  final String companyName;
  final String deadline;

  ProjectItem(this.isComplete, this.orderId, this.name, this.companyName,
      this.deadline);

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    var date = DateTime.parse(json['deadline']);
    var formatter = DateFormat('dd.MM.yyyy');
    var deadline = formatter.format(date);
    bool isCompleted = json['isCompleted'];
    var orderId = json['orderId'];
    var name = json['name'];
    var companyName = json['companyName'];
    return ProjectItem(isCompleted, orderId, name, companyName, deadline);

  }

}