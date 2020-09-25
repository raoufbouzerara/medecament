import 'package:flutter/material.dart';
import 'package:medecament/Helpers/db_helper.dart';
import 'package:medecament/Models/medecament.dart';
import 'dart:async';

class DBTestPage extends StatefulWidget {
  final String title;

  DBTestPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}

class _DBTestPageState extends State<DBTestPage> {
  //
  Future<List<Medecament>> medecaments;
  List<Medecament> medlist;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String name;
  String presentation;
  int curUserId;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      medecaments = dbHelper.getEmployees();
    });
  }

  clearName() {
    controller.clear();
    controller2.clear();
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Medecament e = Medecament(curUserId, name, double.parse(presentation));
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Medecament e = Medecament(null, name, double.parse(presentation));
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: controller2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Presentation'),
              validator: (val) => val.length == 0 ? 'Enter Presentation' : null,
              onSaved: (val) => presentation = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter SQLITE CRUD DEMO'),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            Expanded(
              child: FutureBuilder(
                future: medecaments,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    medlist = snapshot.data;
                    return ListView.builder(
                        itemCount: medlist == null ? 0 : medlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          Medecament med = medlist[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            child: ListTile(
                              // leading: CircleAvatar(
                              //   backgroundColor: Theme.of(context).primaryColor,
                              //   radius: 30,
                              //   child: Container(
                              //     padding: const EdgeInsets.all(4),
                              //     width: 50,
                              //     child: FittedBox(
                              //       child: Text('${med.presentation}\n mg',
                              //         style: const TextStyle(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //         textAlign: TextAlign.center,
                              //       ),
                              //
                              //     ),
                              //   ),
                              // ),
                              title: Text(
                                '${med.name}',
                                style: Theme.of(context).textTheme.title,
                              ),
                              subtitle: Text('${med.presentation}'),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.pink[400],
                                  ),
                                  onPressed: () {
                                    dbHelper.delete(med.id);
                                    refreshList();
                                  }),
                              onLongPress: () {
                                setState(() {
                                  isUpdating = true;
                                  curUserId = med.id;
                                });
                                controller.text = med.name;
                                controller2.text = med.presentation.toString();
                              },
                            ),
                          );
                        });
                  }
                  return new Container(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (ctx, constrains) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'No drugs added yet!!',
                              style: Theme.of(context).textTheme.title,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                height: constrains.maxHeight * 0.6,
                                child: Image.asset('Assets/Images/doctor2.png',fit: BoxFit.cover,))
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
