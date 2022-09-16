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
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Text("${m['id']}"),
                            title: Text("${m['name']}"),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Contact No :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['contact']}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Email :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['email']}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Gender :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['gender']}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Hobby :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${m['learning']}"),
                                    Text("${m['cricket']}"),
                                    Text("${m['listenmusic']}"),
                                    Text("${m['photography']}")
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
