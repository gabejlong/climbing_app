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
          /*optionsViewBuilder: (context, onSelected, option) => Align(
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
              ),*/
          fieldViewBuilder:
              (context, _locationController, focusNode, onEditingComplete) {
            return Container(
                height: 45,
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color(0xff1D1617).withOpacity(0.11),
                      blurRadius: 40,
                      spreadRadius: 0.0)
                ]),
                child: Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus == false) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setLocation(_locationController.text);
                      }
                    },
                    child: TextSelectionTheme(
                        data: TextSelectionThemeData(
                            cursorColor: Colors.red,
                            selectionHandleColor: Colors.red,
                            selectionColor: Colors.white.withOpacity(.5)),
                        child: TextField(
                          cursorErrorColor: Colors.white,
                          cursorColor: Colors.white,
                          controller: _locationController,
                          focusNode: focusNode,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.blue,
                              contentPadding: EdgeInsets.all(0),
                              hintText: 'Location',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none)),
                        ))));
          })
    ]);
  }
}
