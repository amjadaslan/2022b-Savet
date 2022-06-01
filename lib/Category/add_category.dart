import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Category/profileImage.dart';
import 'package:savet/Services/user_db.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class add_category extends StatefulWidget {
  const add_category({Key? key}) : super(key: key);

  @override
  _add_categoryState createState() => _add_categoryState();
}

class pathWrapper {
  var value;
  bool videoFlag = false;
  pathWrapper(this.value);
}

class _add_categoryState extends State<add_category> {
  TextEditingController _desc = new TextEditingController();
  TextEditingController _name = new TextEditingController();

  var pWrap = new pathWrapper("");
  List<String> tags = [
    "Private",
    "Home décor",
    "DIY & crafts",
    "Entertainment",
    "Education",
    "Art",
    "Men’s fashion",
    "Women’s fashion",
    "Food & drinks",
    "Beauty",
    "Event planning",
    "Gardening",
    "Cars",
    "Fitness",
    "Movies & TV Shows"
  ];
  String tag = "Private";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Add Category"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  profileImage(
                      pWrap: pWrap, shape: "square", network_flag: false),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            labelText: 'Category Title',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)))),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                        maxLines: 6,
                        controller: _desc,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)))),
                  ),
                  SizedBox(height: 40),
                  Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          dropdownOverButton: true,
                          scrollbarRadius: const Radius.circular(10),
                          scrollbarAlwaysShow: true,
                          dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              )),
                          isExpanded: true,
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.transparent,
                          ),
                          items: List.generate(
                              tags.length,
                              (index) => DropdownMenuItem(
                                  value: tags[index],
                                  child: Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Text(tags[index])
                                    ],
                                  ))),
                          onChanged: (val) {
                            setState(() {
                              tag = val!;
                              print(tag);
                            });
                          },
                          value: tag,
                        ),
                      )),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    50),
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.deepOrange),
                          ),
                          SizedBox(width: 30),
                          TextButton(
                            onPressed: () async {
                              if (_name.text.isEmpty || pWrap.value == "") {
                                if (pWrap.value == "")
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please pick a profile image")));
                                else
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please write a title for the category")));
                              } else {
                                await Provider.of<UserDB>(context,
                                        listen: false)
                                    .addCategory(_name.text, _desc.text,
                                        pWrap.value, tag);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Submit"),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    50),
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.deepOrange),
                          )
                        ]),
                  )
                ],
              ),
            ),
          )),
        ));
  }
}
