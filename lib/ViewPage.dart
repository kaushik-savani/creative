import 'package:creative/InsertPage.dart';
import 'package:creative/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Database? db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<List<Map<String, Object?>>> getData() async {
    db = await dbhelper().createdatabase();
    List<Map<String, Object?>> l1 = await db!.rawQuery('select * from Test');
    return l1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return InsertPage();
            },
          ));
        },
        child: Text("Add"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Map<String, Object?>> l =
                  snapshot.data as List<Map<String, Object?>>;
              return l.length > 0
                  ? ListView.builder(
                      itemCount: l.length,
                      itemBuilder: (context, index) {
                        Map m = l[index];
                        List hobby = [];
                        if (m['learning'] == 1) {
                          hobby.add("Learning");
                        }
                        if (m['cricket'] == 1) {
                          hobby.add("Cricket");
                        }
                        if (m['listenmusic'] == 1) {
                          hobby.add("Listen Music");
                        }
                        if (m['photography'] == 1) {
                          hobby.add("Photography");
                        }
                        if (hobby.length == 0) {
                          hobby.add("No hobby select");
                        }
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            onLongPress: () {
                              showDialog(
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Delete"),
                                      content: Text(
                                          "Are you sure you want to delete '${m['name']}'"),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            String qry =
                                                "delete from Test where id='${m['id']}'";
                                            await db!.rawDelete(qry);
                                            setState(() {});
                                          },
                                          child: Text("Yes"),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No"))
                                      ],
                                    );
                                  },
                                  context: context);
                            },
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return InsertPage(m: m);
                                },
                              ));
                            },
                            leading: Text("${m['id']}"),
                            title: Text("${m['name']}"),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Contact No : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['contact']}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Email : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['email']}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Gender : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['radio']}")
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Container(),
                                    Text(
                                      "Hobby : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 50),
                                      height: 70,
                                      child: ListView.builder(
                                        itemCount: hobby.length,
                                        itemBuilder: (context, index1) {
                                          return Text("${hobby[index1]}");
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text("No Data Found"),
                    );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: getData(),
      ),
    );
  }
}
