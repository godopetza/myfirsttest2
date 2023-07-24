import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/controllers/firebase_functions.dart';

class EditScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(
      builder: (_) => const EditScreen(
            appBarTitle: '',
            enableFields: false,
          ));

  final String appBarTitle; //B7
  final String? notetitle, notedesc, id;
  final bool enableFields; //B8
  final bool postnew;

  const EditScreen(
      {Key? key,
      required this.appBarTitle,
      required this.enableFields,
      this.notetitle,
      this.notedesc,
      this.postnew = false,
      this.id})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    final _titleController = TextEditingController(text: widget.notetitle);
    final _descriptionController = TextEditingController(text: widget.notedesc);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(widget.appBarTitle), // Task B7 here
        actions: [
          if (widget.enableFields)
            IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  size: 30,
                ),
                onPressed: () { // TASK B9
                  //check if new post new if edit then edit //B9
                  widget.postnew
                      ? homeController.createNote(
                          _titleController.text, _descriptionController.text)
                      : homeController.updateNote(widget.id!,
                          _titleController.text, _descriptionController.text);
                }),
          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              enabled: widget.enableFields, //B8
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                enabled: widget.enableFields, //B8
                style: const TextStyle(color: Colors.black),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Type the description',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
