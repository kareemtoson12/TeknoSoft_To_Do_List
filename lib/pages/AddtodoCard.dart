import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final IconData icondata;
  final Color iconcolor;
  final String time;
  final bool check;
  final Color iconBgcolor;

  TodoCard(
      {super.key,
      required this.title,
      required this.icondata,
      required this.iconcolor,
      required this.time,
      required this.check,
      required this.onchange,
      required this.iconBgcolor,
      required this.index});
  final Function onchange;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
                primarySwatch: Colors.blue,
                unselectedWidgetColor: const Color(0xff5e616a)),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                activeColor: const Color(0xff6cd8a9),
                checkColor: const Color(0xff0e3e26),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                value: check,
                onChanged: (value) {
                  onchange(index);
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 65,
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                color: const Color(0xff2a2e3d),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: iconBgcolor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        icondata,
                        color: iconcolor,
                      ),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
