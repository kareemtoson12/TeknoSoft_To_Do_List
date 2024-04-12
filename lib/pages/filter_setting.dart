import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:teknotodolist/pages/AddtodoCard.dart';
import 'package:teknotodolist/pages/homepage.dart';

import 'package:teknotodolist/pages/veiw_data.dart';

import 'package:teknotodolist/service/Auth_service.dart';

class FilterSttings extends StatefulWidget {
  FilterSttings({super.key});

  @override
  State<FilterSttings> createState() => _FilterSttings();
}

class _FilterSttings extends State<FilterSttings> {
  AuthClass authClass = AuthClass();

  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection("ToDo")
      .orderBy("task", descending: true) // Order by priority, descending
      .snapshots();

  List<select> selected = [];

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE dd').format(now);

    return Scaffold(
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(DialogRoute(
                          context: context,
                          builder: (context) {
                            return HomePage();
                          },
                        ));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.white,
                      )),
                  const Row(
                    children: [
                      Text(
                        'priority levels',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 25,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            IconData? iconData;
                            Color? iconcolor;
                            final Map<String, dynamic> document =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            switch (document['task']) {
                              case 'high':
                                iconcolor = Colors.red;
                                iconData = Icons.priority_high;
                                break;
                              case 'Medium,':
                                iconcolor = Colors.yellow;
                                iconData = Icons.priority_high;
                                break;
                              case 'Low ':
                                iconcolor = Colors.green;
                                iconData = Icons.priority_high;
                                break;
                              default:
                                iconcolor = Colors.grey;
                                iconData = Icons.error;
                                break;
                            }

                            selected.add(select(
                                checkvalue: false,
                                id: snapshot.data!.docs[index].id));
                            return InkWell(
                              onLongPress: () async {
                                // Show an alert dialog to confirm deletion
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete this todo?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            // Close the alert dialog
                                            Navigator.of(context).pop();

                                            // Delete the document
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('ToDo')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();
                                              print(
                                                  'Document successfully deleted.');
                                            } catch (error) {
                                              print(
                                                  'Error deleting document: $error');
                                            }
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Close the alert dialog
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewData(
                                      document: document,
                                      id: snapshot.data!.docs[index].id),
                                ));
                              },
                              child: TodoCard(
                                check: selected[index].checkvalue,
                                iconBgcolor: Colors.black,
                                iconcolor: iconcolor ?? Colors.black,
                                icondata: iconData ?? Icons.error,
                                time: '3 am',
                                title: document['title'],
                                index: index,
                                onchange: onChange,
                                key: ValueKey(document['id']),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkvalue = !selected[index].checkvalue;
    });
  }
}

class select {
  String? id;
  bool checkvalue = false;
  select({this.id, required this.checkvalue});
}
