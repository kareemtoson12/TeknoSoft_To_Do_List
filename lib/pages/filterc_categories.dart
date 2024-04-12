import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teknotodolist/pages/AddtodoCard.dart';
import 'package:teknotodolist/pages/homepage.dart';
import 'package:teknotodolist/pages/veiw_data.dart';
import 'package:teknotodolist/service/Auth_service.dart';

class CategoriecFilters extends StatefulWidget {
  const CategoriecFilters({super.key});

  @override
  State<CategoriecFilters> createState() => _CategoriecFiltersState();
}

class _CategoriecFiltersState extends State<CategoriecFilters> {
  AuthClass authClass = AuthClass();
  late Stream<QuerySnapshot> _stream; // Define _stream here

  List<select> selected = [];
  String type = "";

  @override
  void initState() {
    super.initState();

    _stream = FirebaseFirestore.instance
        .collection("ToDo")
        .where('category', isEqualTo: type)
        .snapshots();
  }

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
                        'Filter by categories',
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
                  label('choice Category'),
                  Column(
                    children: [
                      Row(
                        children: [
                          taskselect('Food', 0xfffd9800),
                          taskselect('WorkOut ', 0xff072eaf),
                        ],
                      ),
                      Row(
                        children: [
                          taskselect('Design', 0xff3d5298),
                          taskselect('Personal ', 0xff983d5b),
                        ],
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _stream, // Check if _stream is not null
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

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2),
    );
  }

  Widget taskselect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
          setState(() {
            type = label;
            _stream = FirebaseFirestore.instance
                .collection("ToDo")
                .where('category', isEqualTo: type)
                .snapshots();
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Chip(
            backgroundColor: type == label ? Colors.white : Color(color),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
            label: Text(
              label,
              style: TextStyle(
                  color: type == label ? Colors.black : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            )),
      ),
    );
  }
}

class select {
  String? id;
  bool checkvalue = false;
  select({this.id, required this.checkvalue});
}
