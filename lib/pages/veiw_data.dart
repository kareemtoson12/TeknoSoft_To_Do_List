import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:teknotodolist/pages/homepage.dart';

class ViewData extends StatefulWidget {
  ViewData({super.key, required this.document, required this.id});
  final Map<String, dynamic> document;
  final String id;
  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  TextEditingController? _titlecontroller;
  TextEditingController? _descontroller;
  String? type;
  String? category;
  bool edit = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    String title = widget.document['title'] ?? 'hey there';
    _titlecontroller = TextEditingController(text: title);

    String description = widget.document['description'] ?? 'heythere';
    _descontroller = TextEditingController(text: description);
    type = widget.document['task'];
    category = widget.document['category'];
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xff1d1e26),
            Color(0xff252041),
          ])),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 28,
                          color: edit ? Colors.green : Colors.white,
                        )),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        edit ? "Editing view" : 'View',
                        style: const TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Text(
                        'Your Todo',
                        style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      label('Task Title'),
                      title(),
                      const SizedBox(
                        height: 10,
                      ),
                      label('Task Priority'),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          taskselect('high', 0xffff6d6e),
                          taskselect('Medium,', 0xffff9000),
                          taskselect('Low ', 0xff2bc8de),
                        ],
                      ),
                      label('Descreption'),
                      const SizedBox(
                        height: 12,
                      ),
                      Descreption(),
                      label('Category'),
                      Column(
                        children: [
                          Row(
                            children: [
                              categorySelect('Food', 0xfffd9800),
                              categorySelect('WorkOut ', 0xff072eaf),
                            ],
                          ),
                          Row(
                            children: [
                              categorySelect('Design', 0xff3d5298),
                              categorySelect('Run', 0xff983d5b),
                            ],
                          ),
                          edit ? button() : Container(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget taskselect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
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

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Chip(
            backgroundColor: category == label ? Colors.white : Color(color),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
            label: Text(
              label,
              style: TextStyle(
                  color: category == label ? Colors.black : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            )),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection('ToDo').doc(widget.id).update({
          'title': _titlecontroller!.text,
          'task': type,
          'category': category,
          'description': _descontroller!.text
        });
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
          height: 50,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                  colors: [Color(0xff8a32f1), Color(0xffad32f9)])),
          child: const Center(
            child: Text(
              'Update To Do ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget Descreption() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 155,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          enabled: edit,
          controller: _descontroller,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Descreption',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
              contentPadding: EdgeInsets.only(left: 20, right: 20)),
        ),
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff2a2e3d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          enabled: edit,
          controller: _titlecontroller,
          style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Task Title',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
              contentPadding: EdgeInsets.only(left: 20, right: 20)),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2),
    );
  }
}
