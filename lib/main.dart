import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather/user.dart';
import 'package:weather/weather.dart';

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

  Future<Weather> getWeather() async {
    var response = await dio.get(
        "https://api.weatherapi.com/v1/current.json?key=acb4a4de25aa41b784651422200510&q=Margilan");
    if (response.statusCode == 200) {
      return Weather.fromJson(response.data);
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
            future: getWeather(),
            builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green[200],
                    ),
                    child: Column(
                      children: [
                        Image.network("https:" +
                            (snapshot.data?.current?.condition?.icon ?? ""),width: 100,height: 100,),
                        Text(
                            snapshot.data?.current?.tempC.toString() ?? "empty",style: TextStyle(fontSize: 30),)
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
