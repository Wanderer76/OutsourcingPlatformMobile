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


class MyProjectPage extends StatefulWidget {
  String? id;
  MyProjectPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => MyProjectPageState(id);

}


class MyProjectPageState extends State<MyProjectPage> {
  MyProjectPageState(this.id);

  MyProject? project;

  final String? id;
  final _storage = Storage();

  Future<void> fetchProjectInfo(String? orderId) async{
    if (kDebugMode) {
      print(orderId);
    }

    if (orderId == null) {
      return;
    }

    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/detail_order_info/$orderId";
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
        project = MyProject.fromJson(jsonResponse);
      });
      return;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> updateResponse(int responseId, int vacancyId, bool isAccept) async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/update_response?isAccept=${isAccept}&responseId=${responseId}&vacancyId=${vacancyId}";
    String? token = await _storage.getItem("token", null);

    print({
      "isAccept" : isAccept,
      "vacancyId" : vacancyId,
      "responseId" : responseId
    });

    final response = await http.post(
        Uri.parse(url),
        headers: <String, String> {
          "Authorization" : "Bearer $token",
          "Content-Type" : "application/json"
        },

    );

    if (kDebugMode) {
      print(response.request);
      print(response.headers);
      print(response.body);
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      fetchProjectInfo(id);

    }
  }

  Future<void> deleteExecutor(int executorId, int orderId) async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/delete_executor";
    String? token = await _storage.getItem("token", null);

    final response = await http.delete(
        Uri.parse(url),
        headers: <String, String> {
          "Authorization" : "Bearer $token",
          "Content-Type" : "application/json"
        },
        body: json.encoder.convert({
          "executorId": executorId,
          "orderId": orderId,
          "message": "Удален по желанию создателя"
        })
    );

    if (kDebugMode) {
      print(response.request);
      print(response.headers);
      print(response.body);
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      fetchProjectInfo(id);

    }
  }

  
  @override
  void initState() {
    super.initState();
    fetchProjectInfo(id);

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


                    // if (project!.executorResponse.where((element) => element.isAccepted == true).length > 0){
                      const Padding(padding: EdgeInsets.all(15)),

                      // участники проекта
                      Text(project!.executorResponse.where((element) => element.isAccepted == true).isNotEmpty ? "Участники проекта:" : "",
                        style: const TextStyle(fontWeight: FontWeight.w600,
                            fontSize: 23),
                      ),

                      ...project!.executorResponse.where((element) =>
                      element.isAccepted == true)
                          .map((e) =>
                          ProjectParticipantCard(e, () =>
                              deleteExecutor(e.executorId, int.parse(id!))))
                          .toList(),
                    // }



                    // новые заявки
                    const Padding(padding: EdgeInsets.all(15)),

                    Text(project!.executorResponse.where((element) => element.isAccepted == null).isNotEmpty ?"Новые предложения:" : "",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
                    ),

                    ...project!.executorResponse.where((element) => element.isAccepted == null).map((e) => ProjectsResponseParticipantCard(e, () => updateResponse(e.responseId, e.orderVacancy.id, true), () => updateResponse(e.responseId, e.orderVacancy.id, true))).toList(),



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

