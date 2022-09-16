import 'package:creative/ViewPage.dart';
import 'package:creative/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({Key? key}) : super(key: key);

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  Database? db;
  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();
  TextEditingController tpass = TextEditingController();
  TextEditingController temail = TextEditingController();
  bool _obscure = false;
  String radio = "";
  int learning = 0;
  int cricket = 0;
  int listenmusic = 0;
  int photography = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbhelper().createdatabase().then(
      (value) {
        db = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Insert Page")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey.shade200),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                controller: tname,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    label: Text("Contact No"),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey.shade200),
                maxLength: 10,
                keyboardType: TextInputType.phone,
                controller: tcontact,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(),
                    filled: true,
                    helperText: "xyz@example.com",
                    fillColor: Colors.grey.shade200),
                keyboardType: TextInputType.emailAddress,
                controller: temail,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(),
                    filled: true,
                    helperText: "Must be 8 char",
                    fillColor: Colors.grey.shade200,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        icon: _obscure
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility))),
                controller: tpass,
              ),
              Row(
                children: [
                  Text(
                    "Gender :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                      onChanged: (value) {
                        radio = value.toString();
                        setState(() {});
                      },
                      value: "Male",
                      groupValue: radio),
                  Text("Male"),
                  Radio(
                      onChanged: (value) {
                        radio = value.toString();
                        setState(() {});
                      },
                      value: "Female",
                      groupValue: radio),
                  Text("Female"),
                  Radio(
                      onChanged: (value) {
                        radio = value.toString();
                        setState(() {});
                      },
                      value: "Other",
                      groupValue: radio),
                  Text("Other"),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Hobby :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Checkbox(
                              onChanged: (value) {
                                learning = value! ? 1 : 0;
                                setState(() {});
                              },
                              value: learning == 1 ? true : false),
                          Text("Learning"),
                          Checkbox(
                              onChanged: (value) {
                                cricket = value! ? 1 : 0;
                                setState(() {});
                              },
                              value: cricket == 1 ? true : false),
                          Text("Cricket"),
                          Checkbox(
                              onChanged: (value) {
                                listenmusic = value! ? 1 : 0;
                                setState(() {});
                              },
                              value: listenmusic == 1 ? true : false),
                          Text("Listen Music"),
                          Checkbox(
                              onChanged: (value) {
                                photography = value! ? 1 : 0;
                                setState(() {});
                              },
                              value: photography == 1 ? true : false),
                          Text("Photography"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    String name = tname.text;
                    String contact = tcontact.text;
                    String email = temail.text;
                    String pass = tpass.text;

                    String qry =
                        "insert into Test (name,contact,email,pass,radio,learning,cricket,listenmusic,photography) values ('$name','$contact','$email','$pass','$radio','$learning','$cricket','$listenmusic','$photography')";
                    print(qry);
                    await db!.rawInsert(qry);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return ViewPage();
                      },
                    ));
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
