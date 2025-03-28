import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:climbing_app/models/lists_model.dart";

class locationSection extends StatefulWidget {
  final String? selectedLocation;
  final Function(String?) onLocationChanged;
  locationSection(
      {required this.selectedLocation, required this.onLocationChanged});

  @override
  State<locationSection> createState() => _locationState();
}

class _locationState extends State<locationSection> {
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  setLocation(text) {
    setState(() {
      if (text != '') {
        widget.onLocationChanged(text);
      } else {
        widget.onLocationChanged(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Autocomplete<String>(
          initialValue: TextEditingValue(text: widget.selectedLocation ?? ''),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return locationOptions.where((String option) {
              option = option.toLowerCase();
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            setLocation(selection);
          },
          optionsViewBuilder: (context, onSelected, option) => Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: 400,
                    color: Colors.white,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: option.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return Text(
                          option.elementAt(index),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        );
                      },
                    )),
              ),
          fieldViewBuilder:
              (context, _locationController, focusNode, onEditingComplete) {
            return Container(
                //height: 45,
                child: Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus == false) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setLocation(_locationController.text);
                      }
                    },
                    child: TextField(
                      cursorErrorColor: Colors.black,
                      cursorColor: Colors.black,
                      controller: _locationController,
                      focusNode: focusNode,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      onEditingComplete: onEditingComplete,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                            CupertinoIcons.search,
                            color: Colors.black,
                          ),
                          filled: false,
                          contentPadding: EdgeInsets.all(0),
                          labelText: 'Location',
                          labelStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                          hintText: 'Grand River Rocks Waterloo',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )));
          })
    ]);
  }
}
