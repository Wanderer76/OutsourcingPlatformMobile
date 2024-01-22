import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';


import '../data/Storage.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsViewState();

}

class _ChatsViewState extends State<ChatsView> {

  final _storage = Storage();

  late HubConnection hubConnection;


  Future<void> connectSocket() async {
    if (kDebugMode) {
      print("start connection...");
    }
    String? token = await _storage.getItem("token", null);
    final serverUrl = "${const String.fromEnvironment("BASE_URL")}/chats?token=Bearer ${token}";
    // final connectionOptions = HttpConnectionOptions

    final httpOptions = HttpConnectionOptions(skipNegotiation: true, transport: HttpTransportType.WebSockets);
    hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpOptions)
        .build();
    hubConnection.onclose( (error) => print("Connection Closed"));
    await hubConnection.start();
    final result = await hubConnection.invoke("ReceiveStartedChats", args: <Object>[token!, 0, 100]);
    hubConnection.on("ReceiveStartedChatRooms", handleChatRooms);



    if (kDebugMode) {
      print(result);
    }

  }


  void handleChatRooms (List<dynamic>? l) {
    if (kDebugMode) {
      print(l);
    }
  }

  @override void initState() {
    print("init");
    connectSocket();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F0),
      body:
            RefreshIndicator(
            onRefresh: connectSocket,
            child:
            ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 23),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => {

                },
                child:
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child:
                        Padding(padding: EdgeInsets.all(10),
                        child: Row(
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

                            Column(
                              children: [
                                Text(
                                  "Имя человечка",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "Компания человечка",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 40),
                                width:40.0,
                                height:40.0,
                                child: Center(child:Text("5")),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2),
                                )
                            ),


                          ],
                        ),)

                  )
                ,
              );
            }
            ),
            )
        );
  }

}