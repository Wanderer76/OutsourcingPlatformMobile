import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outsource_mobile/data/ProjectExecutor.dart';

Widget ProjectParticipantCard(ProjectExecutor executor, VoidCallback onDelete) {
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

            Text(executor.fio, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),

            const Padding(padding: EdgeInsets.all(10)),

            Row(
              children: [
                const Icon(Icons.location_city, size: 30),
                const Padding(
                    padding: EdgeInsets.all(12)),
                Text("Город: ${executor.city}",
                    style: const TextStyle(fontSize: 18)),

              ],
            ),
            Row(
              children: [
                const Icon(Icons.assignment_ind, size: 30),
                const Padding(
                    padding: EdgeInsets.all(12)),
                Text("Роль: ${executor.orderVacancy.orderRole.name}",
                    style: const TextStyle(fontSize: 18)),

              ],
            ),
            Row(
              children: [
                const Icon(Icons.assignment, size: 30),
                const Padding(
                    padding: EdgeInsets.all(12)),
                Text("Статус: ${executor.isCompleted ? "Завершен" : "В процессе"}",
                    style: const TextStyle(fontSize: 18)),

              ],
            ),
            Row(
              children: [
                Icon(Icons.done_all, size: 30),
                Padding(
                    padding: EdgeInsets.all(12)),
                Text("Проектов завершено: ${executor.completedOrders}",
                    style: TextStyle(fontSize: 18)),
              ],
            ),

            const Padding(padding: EdgeInsets.all(12)),
            Row(
              children: [
                const Icon(Icons.alternate_email, size: 30),
                Padding(
                    padding: EdgeInsets.all(12)),
                Flexible(
                  child: Text("Email: ${executor.email}",
                      style: TextStyle(fontSize: 18)),
                )
              ],
            ),

            Row(
              children: [
                const Icon(Icons.local_phone, size: 30),
                const Padding(
                    padding: EdgeInsets.all(12)),
                Flexible(
                  child: Text("Телефон: ${executor.phone}",
                      style: const TextStyle(fontSize: 18)),
                )
              ],
            ),


            const Padding(padding: EdgeInsets.all(10)),
            FractionallySizedBox(
              widthFactor: 0.8,
              child:
              !executor.isCompleted ?
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),  // radius as you wish
                ),
                child: TextButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(

                    ),
                    child: const Text("Удалить из проекта", style: TextStyle(fontSize: 18, color: Colors.black),)),
              ) : Text(""),
            )

          ],
        ),
      ),
    ),
  );
}