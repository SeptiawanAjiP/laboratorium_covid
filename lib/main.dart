import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_covid/lab_model.dart';
import 'package:http/http.dart' as myHttp;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LabPage(),
    );
  }
}

class LabPage extends StatefulWidget {
  const LabPage({Key? key}) : super(key: key);

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  List<LabModel> labs = [];

  Future getAllData() async {
    try {
      var response = await myHttp
          .get(Uri.parse('https://data.covid19.go.id/public/api/lab.json'));

      List data = (json.decode(response.body));

      data.forEach((element) {
        labs.add(LabModel.fromJson(element));
      });

      print(labs);
    } catch (er) {
      print('error :' + er.toString());
    }
  }

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getAllData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: Colors.red);
                  } else {
                    if (labs.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: labs.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                title: Text(labs[index].namaLab),
                                subtitle: Text(labs[index].alamat ?? ''),
                                trailing: Wrap(children: [
                                  IconButton(
                                      onPressed: () {
                                        print(labs[index].kontakPhone);
                                        if (labs[index].kontakPhone !=
                                            null) if (labs[
                                                index]
                                            .kontakPhone!
                                            .isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text("Nomor Telepon"),
                                              content: Text(
                                                  "Telepon Sekarang - " +
                                                      labs[index].kontakPhone!),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("Ok"),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text("Ups"),
                                              content: Text(
                                                  "Tidak ada nomor telepon"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Text("Ok"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        // launchUrl(Uri.parse("tel://" +
                                        //     labs[index].kontakPhone!));
                                      },
                                      icon:
                                          Icon(Icons.call, color: Colors.blue)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (labs[index].lat != null &&
                                            labs[index].lon != null) {
                                          navigateTo(
                                              double.parse(labs[index].lat!!),
                                              double.parse(labs[index].lon!!));
                                        }
                                      },
                                      icon: Icon(Icons.directions,
                                          color: Colors.green)),
                                ])),
                          ),
                        ),
                      );
                    } else {
                      return Text('Tidak ada data');
                    }
                  }
                }),
          ],
        ),
      )),
    );
  }
}
