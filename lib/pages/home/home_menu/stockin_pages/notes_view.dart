import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wareflow/constants/constants.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Notes", style: kTitleTextStyle),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Done", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_photo_alternate),
                    label: Text(
                      "Upload an Image",
                      style: kSecondaryTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: kButtonStyle.copyWith(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      iconColor: WidgetStatePropertyAll(Colors.white),
                      iconAlignment: IconAlignment.start,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.note_add_rounded),
                    label: Text(
                      "Upload a File",
                      style: kSecondaryTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: kButtonStyle.copyWith(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      iconColor: WidgetStatePropertyAll(Colors.white),
                      iconAlignment: IconAlignment.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 10,
                decoration: kInputDecoration.copyWith(
                  fillColor: Colors.white,
                  hintText:
                      "Enter Notes\ntip: use # for easy search (eg.#WareFlow).\n:)",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  hintStyle: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
