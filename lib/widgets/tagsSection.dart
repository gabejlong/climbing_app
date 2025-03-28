import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_app/models/lists_model.dart';

class tagsSection extends StatefulWidget {
  final selectedTags;
  final Function(String) onTagsChanged;
  const tagsSection({required this.selectedTags, required this.onTagsChanged});

  @override
  State<tagsSection> createState() => _tagsState();
}

class _tagsState extends State<tagsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Tags (optional)',
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 10,
      ),
      Wrap(
        spacing: 5,
        runSpacing: 5,
        children: List.generate(
          tagsList.length,
          (index) {
            return Column(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        widget.onTagsChanged(tagsList[index]);
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          widget.selectedTags == tagsList[index]
                              ? Colors.black
                              : Color(0xfff0f0f0)),
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      tagsList[index],
                      style: TextStyle(
                        color: widget.selectedTags == tagsList[index]
                            ? Color(0xfff0f0f0)
                            : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            );
          },
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextButton.icon(
        label: Text(
          'Create new tag',
          style: TextStyle(
              color: Color(0xff007BDD),
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          CupertinoIcons.add,
          color: Color(0xff007BDD),
          size: 20,
        ),
        onPressed: () => (),
      ),
    ]);
  }
}
