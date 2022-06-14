import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Category/profileImage.dart';
import 'package:savet/Services/user_db.dart';

import 'add_category.dart';

class edit_category extends StatefulWidget {
  edit_category({Key? key, required this.id, tag}) : super(key: key);
  int id;
  String? tag;
  @override
  edit_categoryState createState() => edit_categoryState();
}

class edit_categoryState extends State<edit_category> {
  TextEditingController _desc = TextEditingController();
  TextEditingController _name = TextEditingController();

  var pWrap = pathWrapper("");
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
  String temp = "";
  @override
  Widget build(BuildContext context) {
    var cat = Provider.of<UserDB>(context).categories[widget.id];
    pWrap = pWrap.value == "" ? pathWrapper(cat['image']) : pWrap;
    String tag = cat['tag'].toString();
    String name = cat['title'].toString();
    String desc = cat['description'].toString();
    _desc.text = _desc.text == "" ? desc : _desc.text;
    _name.text = _name.text == "" ? name : _name.text;
    temp = temp == "" ? tag : temp;
    //File imageFile = File(pWrap.value);
    // bool temp1 = File(pWrap.value).absolute.existsSync();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Edit category"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  pWrap.value == pathWrapper(cat['image']).value
                      ? profileImage(
                          pWrap: pWrap, shape: "square", network_flag: true)
                      : profileImage(
                          pWrap: pWrap, shape: "square", network_flag: false),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            labelText: 'Category Title',
                            // hintText: name,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)))),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                        maxLines: 6,
                        controller: _desc,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)))),
                  ),
                  const SizedBox(height: 40),
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
                                      const SizedBox(width: 20),
                                      Text(tags[index])
                                    ],
                                  ))),
                          onChanged: (val) {
                            setState(() {
                              temp = val ?? temp;
                              print(temp);
                            });
                          },
                          value: temp,
                        ),
                      )),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    50),
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.deepOrange),
                          ),
                          const SizedBox(width: 30),
                          TextButton(
                            onPressed: () async {
                              _name.text = _name.text == "" ? name : _name.text;
                              _desc.text = _desc.text == "" ? desc : _desc.text;

                              print(pWrap.value);
                              print(_name.text);
                              print(_desc.text);
                              print(temp);
                              Provider.of<UserDB>(context, listen: false)
                                  .editCategory(widget.id, pWrap.value,
                                      _name.text, temp, _desc.text);
                              Navigator.pop(context);
                            },
                            child: const Text("Submit"),
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
