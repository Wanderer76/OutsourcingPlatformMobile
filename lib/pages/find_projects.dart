import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outsource_mobile/data/Find.dart';
import 'package:outsource_mobile/data/ProjectItem.dart';
import 'package:outsource_mobile/data/Storage.dart';
import 'package:http/http.dart' as http;


class FindProjectsView extends StatefulWidget {
  const FindProjectsView({super.key});

  @override
  State<StatefulWidget> createState() => _FindProjectsViewState();

}

class _FindProjectsViewState extends State<FindProjectsView> {
  final _storage = Storage();

  FindResult? projectsResult;



  Future<void> fetchProjects() async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/order_list/0/10";

    String? token = await _storage.getItem("token", null);
    if (kDebugMode) {
      print(token);
    }
    final response = await http.post(
        Uri.parse(url),
        headers: <String, String> {
          "Authorization" : "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encoder.convert({}),

    );
    if (kDebugMode) {
      print(response.request);
      print(response.headers);
      print(response.body);
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      setState(() {
        projectsResult = FindResult.fromJson(jsonResponse);
      });
      return;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  void initState() {
    fetchProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F0),
      body:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Expanded(child:
            projectsResult != null ?
            RefreshIndicator(
                onRefresh: fetchProjects,
                child:
                ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: projectsResult!.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () =>
                        {
                          context.goNamed("Project", pathParameters: {"id" : projectsResult!.orders[index].orderId.toString()})
                        },
                        child: Card(
                            child:
                            Padding(
                              padding: EdgeInsets.all(15),
                              child:
                              Column(
                                children: [
                                  Text(
                                      projectsResult!.orders[index].name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "https://pixelbox.ru/wp-content/uploads/2022/08/avatar-boy-telegram-pixelbox.ru-88.jpg"),
                                        radius: 20,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(12)),
                                      Text(
                                        projectsResult!.orders[index].companyName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: [
                                      const Icon(
                                        Icons.assignment,
                                        size: 32,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(15)),
                                      Text(
                                        "Статус: ${projectsResult!.orders[index].isCompleted ? "Завершен" : "В работе"}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 32,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(15)),
                                      Text(
                                        "Дедлайн: ${projectsResult!.orders[index].deadline}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      )
                                    ],
                                  )
                                ],

                              ),
                            )
                        )
                    );
                  },
                )
            )

                : Column(
                children: [
                  const Text("Список пуст",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 30),
                      child:
                      TextButton(

                          onPressed: () {
                            // if (updateAndSendData()) {
                            //   context.goNamed("MyProjects");
                            // }
                            fetchProjects();
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                            backgroundColor: Colors.white70,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 55),
                            side: const BorderSide(color: Colors.black54),
                          ),
                          child: const Text("Обновить", style: TextStyle(color: Colors.black),)
                      )
                  ),

                ]
            )

            )
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {context.goNamed("NewProject")},
        tooltip: "Increment",
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),

      ),
    );
  }
}
