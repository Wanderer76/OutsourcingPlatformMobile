import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:outsource_mobile/data/AuthData.dart';
import 'package:outsource_mobile/data/MyProject.dart';
import 'package:outsource_mobile/data/Storage.dart';
import 'package:outsource_mobile/widgets/project_participant_card.dart';
import 'package:outsource_mobile/widgets/project_response_participant_card.dart';

import '../data/Project.dart';

class ProjectPage extends StatefulWidget {
  String? id;
  ProjectPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => ProjectPageState(id);

}


class ProjectPageState extends State<ProjectPage> {
  ProjectPageState(this.id);

  Project? project;

  final String? id;
  final _storage = Storage();

  Future<void> responseToOrder(int vacancyId, bool reaction) async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/response/$id?vacancyId=$vacancyId&reaction=$reaction";
    String? token = await _storage.getItem("token", null);

    if (kDebugMode) {
      print(token);
    }

    final response = await http.post(
        Uri.parse(url),
        headers: <String, String> {
      "Authorization" : "Bearer $token"
      });

    if (kDebugMode) {

      print(response.request);
      print(response.headers);
      print(response.body);
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      fetchProjectInfo(id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> fetchProjectInfo(String? orderId) async{
    if (kDebugMode) {
      print(orderId);
    }

    if (orderId == null) {
      return;
    }

    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/order/$orderId";
    String? token = await _storage.getItem("token", null);

    if (kDebugMode) {
      print(token);
    }

    final response = await http.get(Uri.parse(url), headers: <String, String> {
      "Authorization" : "Bearer $token"
    });

    if (kDebugMode) {

      print(response.request);
      print(response.headers);
      print(response.body);
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        project = Project.fromJson(jsonResponse);
      });
      return;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }


  @override
  void initState() {
    fetchProjectInfo(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xFFFEF6F0),
        body: SingleChildScrollView(
            child: Builder(
                builder: (context) {
                  if (project != null) {
                    return Center(
                      child:
                      Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.all(15)
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Card(
                                child:
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(project?.name ?? "",
                                        style: TextStyle(fontSize: 22),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(project?.description ?? "",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.assignment, size: 30,),
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                                            Text("Статус: ${project!.isCompleted ? "Завершен" : "В процессе"}",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time, size: 30,),
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                                            Text("Дедлайн: ${project!.deadline}",
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://pixelbox.ru/wp-content/uploads/2022/08/avatar-boy-telegram-pixelbox.ru-88.jpg"),
                                            radius: 20,
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.all(12)),
                                          Flexible(child: Text(
                                            project!.companyName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )

                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Builder(
                  builder: (context) {
                    if (!project!.isResponded) {
                      return Column(
                        children: [
                          ...project!.orderVacancies.map((e) =>
                            Padding(padding: const EdgeInsets.all(10),
                              child:
                              FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),  // radius as you wish
                                    ),
                                    child: TextButton(
                                      onPressed: () =>
                                      {
                                        responseToOrder(e.id, true)
                                      },

                                      child:  Text(
                                        "Откликунться на роль ${e.orderRole
                                            .name}", textAlign: TextAlign.center,),
                                    )),
                              )

                            ),
                            )
                              .toList()
                        ],
                      );
                    }
                      else return Text("Вы уже откликнулись на проект ${project?.isAccepted == false ? ". Дождитесь подтверждения заявки создателем проекта." : " и создатель проекта принял заявку. Свяжитесь с ним для начала работы." }");

                  },
                  )

                          )





                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Padding(padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                    );
                  }
                }
            )

        )


    );
  }


}

