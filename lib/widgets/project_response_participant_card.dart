import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outsource_mobile/data/ProjectExecutor.dart';

Widget ProjectsResponseParticipantCard(ProjectExecutor executor, VoidCallback onAccept, VoidCallback onDeny) {
  return FractionallySizedBox(
    widthFactor: 0.9,
    child: Card(
      child:
      Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://pixelbox.ru/wp-content/uploads/2022/08/avatar-boy-telegram-pixelbox.ru-88.jpg"),
              radius: 40,
            ),

            Text(executor.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),

            const Padding(padding: EdgeInsets.all(10)),

            Row(
              children: [
                const Icon(Icons.done_all, size: 30),
                const Padding(
                    padding: EdgeInsets.all(12)),
                Text("Проектов завершено: ${executor.completedOrders}",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),

            Row(
              children: [
                const Icon(Icons.assignment_ind, size: 30),
                const Padding(
                    padding: EdgeInsets.all(12)),
                Flexible(
                  child: Text(executor.orderVacancy.orderRole.name,
                      style: const TextStyle(fontSize: 18)),
                )

              ],
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Column(
              children: [
                const Text("Компетенции:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                ...executor.skills.map((e) =>
                    Text(e.name, style: TextStyle(color: Colors.blueAccent, fontSize: 18),)
                ),
              ],
            ),

            const Padding(padding: EdgeInsets.all(10)),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),  // radius as you wish
                ),
                child: TextButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(

                    ),
                    child: Text("Принять в проект", style: TextStyle(fontSize: 18),)),
              ),
            ),



            const Padding(padding: EdgeInsets.all(10)),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),  // radius as you wish
                ),
                child: TextButton(
                    onPressed: onDeny,
                    style: ElevatedButton.styleFrom(

                    ),
                    child: Text("Отклонить", style: TextStyle(fontSize: 18, color: Colors.black),)),
              ),
            ),

          ],
        ),
      ),
    ),
  );
}