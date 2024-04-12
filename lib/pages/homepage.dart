import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:teknotodolist/pages/AddtodoCard.dart';
import 'package:teknotodolist/pages/addTodo.dart';
import 'package:teknotodolist/pages/filter_setting.dart';

import 'package:teknotodolist/pages/filterc_categories.dart';
import 'package:teknotodolist/pages/veiw_data.dart';

import 'package:teknotodolist/service/Auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();

  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("ToDo").snapshots();

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
                  const Row(
                    children: [
                      Text(
                        'Today\'s schedule',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      /*  CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://scontent.fcai19-7.fna.fbcdn.net/v/t39.30808-6/243377403_1215628965601557_2663449234593570265_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_ohc=xJQdX-gnBWUAX_u2rf9&_nc_ht=scontent.fcai19-7.fna&oh=00_AfA31ONpuQ0Hz-tuiw1N4xydjkN4Z9eNLjsR6UtyQjKHZg&oe=660F9D80'),
                      ) */
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
                            switch (document['category']) {
                              case 'Personal' || 'personal':
                                iconcolor = Colors.white;
                                iconData = Icons.run_circle;
                                break;
                              case 'Food':
                                iconcolor = Colors.green;
                                iconData = Icons.food_bank;
                                break;
                              case 'WorkOut ':
                                iconcolor = Colors.yellow;
                                iconData = Icons.sports_gymnastics_rounded;
                                break;
                              case 'Work ':
                                iconcolor = Colors.teal;
                                iconData = Icons.work;
                                break;
                              case 'Design ':
                                iconcolor = Colors.purple;
                                iconData = Icons.work;
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        showSelectedLabels: true, // Add this line
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Handle Home icon tap
              },
              child: const Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
            ),
            label: 'Hom',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const AddToDo();
                  },
                ));
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.purple, Colors.indigoAccent]),
                    shape: BoxShape.circle),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                _showFilterOptions(context);
              },
              child: const Icon(
                Icons.settings,
                size: 30,
                color: Colors.white,
              ),
            ),
            label: 'Settings',
          ),
        ],
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

void _showFilterOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('priority');
              },
              child: Text('Filter by Priority'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('category');
              },
              child: Text('Filter by Category'),
            ),
          ],
        ),
      );
    },
  ).then((value) {
    if (value != null) {
      // Handle the selected filter option
      if (value == 'priority') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterSttings(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoriecFilters(),
          ),
        );
      }
    }
  });
}
