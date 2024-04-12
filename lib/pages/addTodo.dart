import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teknotodolist/pages/homepage.dart';

final titleControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descontroller = TextEditingController();
  String type = "";
  String category = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          DialogRoute(
                            context: context,
                            builder: (context) => HomePage(),
                          ));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create',
                        style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Text(
                        'New Todo',
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
                              categorySelect('Personal ', 0xff983d5b),
                            ],
                          ),
                          button()
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
      onTap: () {
        setState(() {
          type = label;
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

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
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
        FirebaseFirestore.instance.collection('ToDo').add({
          'title': _titlecontroller.text,
          'task': type,
          'category': category,
          'description': _descontroller.text
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
              'Add To Do ',
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
          controller: _descontroller,
          style: const TextStyle(color: Colors.grey, fontSize: 17),
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
          controller: _titlecontroller,
          style: const TextStyle(color: Colors.grey, fontSize: 17),
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
