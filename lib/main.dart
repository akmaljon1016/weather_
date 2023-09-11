import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather/user.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dio dio = Dio();

  Future<List<User>> getUser() async {
    var response = await dio.get("https://jsonplaceholder.typicode.com/users");
    if (response.statusCode == 200) {
      return listFromJson(response.data);
    } else {
      throw Exception;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User download"),
        ),
        body: FutureBuilder(
            future: getUser(),
            builder:
                (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    color: Colors.green[100],
                    child: Column(
                      children: [
                        Text(snapshot.data?[index].company?.name ??
                            "this is empty"),
                        Text(snapshot.data?[index].name ??
                            "this is empty"),
                      ],
                    ),
                  );
                });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
