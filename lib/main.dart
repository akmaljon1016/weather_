import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
        "http://api.weatherapi.com/v1/forecast.json?key=acb4a4de25aa41b784651422200510&q=Tashkent&days=7");
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
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green[200],
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              "https:" +
                                  (snapshot.data?.current?.condition?.icon ??
                                      ""),
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              snapshot.data?.current?.tempC.toString() ??
                                  "empty",
                              style: TextStyle(fontSize: 30),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                            itemCount:
                                snapshot.data?.forecast?.forecastday?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green[200],
                                ),
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https:" +
                                          (snapshot
                                                  .data
                                                  ?.forecast
                                                  ?.forecastday?[index]
                                                  .day
                                                  ?.condition
                                                  ?.icon ??
                                              ""),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      snapshot.data?.forecast?.forecastday?[index].day?.avgtempC.toString() ??
                                          "empty",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(snapshot.data?.forecast?.forecastday?[index].date??"empty")
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
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
