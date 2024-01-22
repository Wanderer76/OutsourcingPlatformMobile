import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:outsource_mobile/data/Competencies.dart';
import 'package:outsource_mobile/data/ProjectCreate.dart';
import 'package:outsource_mobile/data/ProjectItem.dart';
import 'package:outsource_mobile/data/Storage.dart';
import 'package:http/http.dart' as http;

class NewProject extends StatefulWidget {
  NewProject({super.key});

  @override
  State<StatefulWidget> createState() => _NewProjectState();

}

class _NewProjectState extends State<NewProject> {

  final _storage = Storage();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;

  Competency _initialCategoty = new Competency(0, "Выберите сферу проекта");
  Competency _initialSkill = new Competency(0, "Выберите компетенцию");
  Competency _initialRole = new Competency(0, "Выберите роль");

  List<Competency> categories = [];
  List<Competency> skills = [];
  List<Competency> roles = [];

  List<Competency> selectedCategories = [];
  List<Competency> selectedSkills = [];
  List<Vacancy> selectedRoles = [];

  String error = "";


  Future<bool> fetchCreateProjectRequest() async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Order/create";
    var name = nameController.text;
    var description = descriptionController.text;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String deadline = formatter.format(selectedDate!);
    var project = ProjectCreate(name, description, deadline, selectedCategories, selectedSkills, selectedRoles);
    String? token = await _storage.getItem("token", null);

    if (kDebugMode) {
      print(json.encoder.convert(project));
    }

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String> {
      "Authorization" : "Bearer $token",
        "Content-Type" : "application/json"
    },
    body: json.encoder.convert(project)
    );

    if (kDebugMode) {
      print(response.request);
      print(response.headers);
      print(response.body);
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      return true;

    }
    return false;
  }

  Future<void> fetchCategories() async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Competencies/categories/0/40";
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
      List jsonResponse = json.decode(response.body);
      setState(() {
        categories = [_initialCategoty, ...jsonResponse.map((data) => Competency.fromJson(data)).toList()];

      });
      return;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> fetchSkills() async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Competencies/skills/0/40";
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
      List jsonResponse = json.decode(response.body);
      setState(() {
        skills = [_initialSkill, ...jsonResponse.map((data) => Competency.fromJson(data)).toList()];

      });
      return;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> fetchRoles() async {
    var url = "${const String.fromEnvironment("BASE_URL")}/api/Competencies/order-roles/0/40";
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
      List jsonResponse = json.decode(response.body);
      setState(() {
        roles = [_initialRole, ...jsonResponse.map((data) => Competency.fromJson(data)).toList()];

      });
      return;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  void initState() {
    fetchCategories();
    fetchSkills();
    fetchRoles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F0),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child:
                Text(
                  "Создать новый проект",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
            child:
            Center(
              child: Column(

                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child:
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Название проекта',
                          ),
                        ),
                    ),
                  ),

                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:
                      TextFormField(
                        controller: descriptionController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Описание',
                        ),
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child:
                        DateTimeField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Дедлайн проекта',
                            helperText: 'DD.MM.YYYY',
                          ),

                          dateFormat: DateFormat("dd.MM.yyyy"),
                          mode: DateTimeFieldPickerMode.date,
                          onDateSelected: (DateTime? value) {
                            setState(() {
                              selectedDate = value;
                            });
                          }, selectedDate: selectedDate,
                        ),
                    ),
                  ),

                  FractionallySizedBox(
                    widthFactor: 1.0,
                    child:
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:
                          Column(
                            children: [
                            DropdownButton<Competency>(
                              // Step 3.
                              value: _initialCategoty,
                              // Step 4.
                              items: categories
                                  .map<DropdownMenuItem<Competency>>((Competency value) {
                                return DropdownMenuItem<Competency>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                  ),
                                );
                              }).toList(),
                              // Step 5.
                              onChanged: (Competency? newValue) {
                                if (newValue != null && !selectedCategories.contains(newValue)) {
                                  setState(() {
                                    // _initialCategoty = newValue;
                                    selectedCategories = [...selectedCategories, newValue];
                                  });

                                }
                              },
                            ),
                            ...selectedCategories.map<Widget>((Competency value) {
                                return TextButton(
                                    onPressed: () => {
                                      setState(() {
                                        selectedCategories = selectedCategories.where((element) => element.name != value.name).toList();
                                      })
                                    },
                                    child: Text(value.name)
                                );
                            }).toList(),

                          ]
                      )
                    ),
                  ),
            ),

                  Card(
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        Column(
                            children: [
                              DropdownButton<Competency>(
                                // Step 3.
                                value: _initialSkill,
                                // Step 4.
                                items: skills
                                    .map<DropdownMenuItem<Competency>>((Competency value) {
                                  return DropdownMenuItem<Competency>(
                                    value: value,
                                    child: Text(
                                      value.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                                // Step 5.
                                onChanged: (Competency? newValue) {
                                  if (newValue != null && newValue != _initialSkill && !selectedSkills.contains(newValue)) {
                                    setState(() {
                                      // _initialCategoty = newValue;
                                      selectedSkills = [...selectedSkills, newValue];
                                    });

                                  }
                                },
                              ),
                              ...selectedSkills.map<Widget>((Competency value) {
                                return TextButton(
                                    onPressed: () => {
                                      setState(() {
                                        selectedSkills = selectedSkills.where((element) => element.name != value.name).toList();
                                      })
                                    },
                                    child: Text(value.name)
                                );
                              }).toList(),

                            ]
                        )
                    ),
                  ),


                  FractionallySizedBox(
                    widthFactor: 1.0,
                    child:
                  Card(
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        Column(
                            children: [
                              DropdownButton<Competency>(
                                // Step 3.
                                value: _initialRole,
                                // Step 4.
                                items: roles
                                    .map<DropdownMenuItem<Competency>>((Competency value) {
                                  return DropdownMenuItem<Competency>(
                                    value: value,
                                    child: Text(
                                      value.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                                // Step 5.
                                onChanged: (Competency? newValue) {
                                  if (newValue != null && newValue != _initialRole && !selectedRoles.contains(newValue)) {
                                    setState(() {
                                      selectedRoles = [...selectedRoles, Vacancy("1", OrderRole(newValue.name))];
                                    });

                                  }
                                },
                              ),
                              ...selectedRoles.map<Widget>((Vacancy value) {
                                return Row(
                                  children: [
                                    TextButton(
                                    onPressed: () => {
                                  setState(() {
                                    selectedRoles = selectedRoles.where((element) => element.orderRole.name != value.orderRole.name).toList();
                                  })
                                },
                                child: Text(value.orderRole.name)
                                ),
                                  SizedBox(
                                    width: 20,
                                    child:
                                  TextFormField(
                                    initialValue: value.maxWorkers,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (String newValue) => {
                                      value.maxWorkers = newValue
                                    },
                                  )
                                  )
                                ],
                                );
                              }).toList(),

                            ]
                        )
                    ),
                  ),
                  ),

                  const Padding(padding: EdgeInsets.all(10)),
                  TextButton(

                      onPressed: () {
                        fetchCreateProjectRequest().then((value) => {
                          if (value) {
                            context.goNamed("MyProjects")
                          }
                          else setState(() {
                            error = "ОЩИБКА!";
                          })
                        });


                      },
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 55)
                      ),
                      child: const Text("Создать проект", style: TextStyle(color: Colors.white),)
                  ),
                  Text(error)

                ],
              ),
            )
            )
          ]
      ),
      )
    );
  }

}