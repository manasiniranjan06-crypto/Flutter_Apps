
import 'dart:developer';

import 'package:adv_todo/todo_database.dart';
import 'package:adv_todo/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class todoApp extends StatefulWidget {
  const todoApp({super.key});

  @override
  State createState() => _todoApp();
}

class _todoApp extends State {

  ClearData() {
    titlecontrolller.clear();
    descriptioncontroller.clear();
    datecontroller.clear();
  }

  void sumbit(bool doedit, [TodoModel? obj]) {
    if (titlecontrolller.text.isNotEmpty &&
        descriptioncontroller.text.isNotEmpty &&
        datecontroller.text.isNotEmpty) {
      if (doedit) {
        obj!.title = titlecontrolller.text;
        obj.description = descriptioncontroller.text;
        obj.date = datecontroller.text;
        Map<String, dynamic> mapobj = {
          'title': obj.title,
          'description': obj.description,
          'date': obj.date,
          'Id': obj.Id,
        };
        TodoDatabase().updatetodoitems(mapobj);
      } else {
        cardList.add(
          TodoModel(
            title: titlecontrolller.text,
            description: descriptioncontroller.text,
            date: datecontroller.text,
          ),
        );
        Map<String, dynamic> dataMap = {
          'title': titlecontrolller.text,
          'description': descriptioncontroller.text,
          'date': datecontroller.text,
        };
        TodoDatabase().inserttodoitems(dataMap);
      }
      ClearData();
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    List<Map> taskcard = await TodoDatabase().gettodoitems();
    log("cardlist : $taskcard");
    for (var element in taskcard) {
      cardList.add(
        TodoModel(
          title: element['title'],
          description: element['description'],
          date: element['date'],
          Id: element['Id'],
        ),
      );
    }
    setState(() {});
  }

  //controller
  TextEditingController titlecontrolller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();

  //listof todomodel
  List<TodoModel> cardList = [];
  @override
  Widget build(BuildContext context) {
    //rgba(111, 81, 255, 1)
    return Scaffold(
      backgroundColor: Color.fromRGBO(111, 81, 255, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 80),
            child: Text(
              "Good Morning",
              style: GoogleFonts.quicksand(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Manasi",
              style: GoogleFonts.quicksand(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(height: 10),
          Expanded(
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                //rgbargba(217, 217, 217, 1)
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              child: Column(
                children: [
                  Text(
                    "CEATE TODO-LIST",
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),

                        color: Colors.white,
                      ),
                      child: TodoCard(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomsheet(false);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //bottom sheet
  showBottomsheet(bool doedit, [TodoModel? obj]) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create To-Do",
                style: GoogleFonts.quicksand(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "Title",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,

                      color: Color.fromRGBO(89, 57, 241, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 50,
                width: 370,
                child: TextField(
                  controller: titlecontrolller,
                  decoration: InputDecoration(
                    hintText: "title",
                    suffixIcon: Icon(Icons.text_fields_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Description",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Color.fromRGBO(89, 57, 241, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 50,
                width: 370,
                child: TextField(
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                    hintText: "description...",
                    suffixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Date",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Color.fromRGBO(89, 57, 241, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 50,
                width: 370,
                child: TextField(
                  controller: datecontroller,
                  // readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Enter Date here...",
                    suffixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.blueGrey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(0, 139, 148, 1),
                      ),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );

                    if (pickedDate != null) {
                      datecontroller.text = DateFormat.yMMMd().format(
                        pickedDate,
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  if (doedit) {
                    sumbit(doedit, obj);
                  } else {
                    sumbit(doedit);
                  }
                },
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //rgba(89, 57, 241, 1)
                    color: Color.fromRGBO(89, 57, 241, 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Submit",
                    style: GoogleFonts.quicksand(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //card
  Widget TodoCard() {
    return ListView.builder(
      itemCount: cardList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Slidable(
              key: ValueKey(cardList[index]),
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                extentRatio: 0.1,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: GestureDetector(
                              onTap: () {
                                titlecontrolller.text = cardList[index].title;
                                descriptioncontroller.text =
                                    cardList[index].description;
                                datecontroller.text = cardList[index].date;
                                showBottomsheet(true, cardList[index]);
                              },
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(89, 57, 241, 1),
                                ),
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                          ),
                          //SizedBox(height: 1,),
                          //delete
                          GestureDetector(
                            onTap: () {
                              int id = cardList[index].Id;
                              cardList.removeAt(index);
                              TodoDatabase().deletertodoitems(id);
                              setState(() {});
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                //  borderRadius: BorderRadius.circular(500),
                                color: Color.fromRGBO(89, 57, 241, 1),
                              ),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 236, 236, 236),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0.1)],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/image.svg", height: 80, width: 80),
                    SizedBox(width: 15),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          Text(
                            cardList[index].title,
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            cardList[index].description,
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            cardList[index].date,
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
