import 'dart:developer';
import 'dart:io';
import 'name_suggest.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
//Image.file(File(img!.path))

List<String> exampleFoodItems = ["Apple", "Sandwich", "Juice"]; //for String foodItem in exampleFoodItems
final nameTextController = new TextEditingController();
final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
final commentsTextController = new TextEditingController();
//XFile? _imageFile;
bool _nameFoodValid = true;
bool _weightFoodValid = true;
//final _newFoodItemKey = GlobalKey<FormState>();
@override
//change foodScannedFirst to build when reformatting the code
Widget foodScannedFirst(BuildContext context, XFile? imageFile) {
  return Dialog(
    child: Form(
      //key: _newFoodItemKey,
      child: Scaffold(
        body: Row(
          children: [
            Column(
              children: [
                Image.file(File(imageFile!.path)),
                retakePhoto(context),
              ]
            ),
            Flexible(
              child: Column(
                children: [
                  //nameEntrySuggester(nameTextController, _nameFoodValid),
                  suggestBox(context, nameTextController, _nameFoodValid),
                  itemPresets(nameTextController),
                  weightEntry(weightTextController, _weightFoodValid),
                  addComments(context, commentsTextController),
                  submitData(context)
                ],
              )
            )
          ]
        )
      )
    )
  );
}

Widget retakePhoto(BuildContext context){
  return ElevatedButton(
      onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
      child: const Text("Retake Photo"),
      style: ElevatedButton.styleFrom(primary: Colors.redAccent)
  );
}

Widget submitData(BuildContext context){
  return ElevatedButton(
      onPressed: () {
        //submit name - weight - ID - photo - comments - date - institution
        Navigator.of(context, rootNavigator: true).pop();
        },
      child: const Text("Submit"),
      style: ElevatedButton.styleFrom(primary: Colors.lightGreen)
  );
}

Widget addComments(BuildContext context, TextEditingController controller) {
  return TextField(
    decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Comments'
    ),
    controller: controller,
  );
}

Widget itemPresets(TextEditingController controller) {
  List<Widget> presets = [];
  for (String foodItem in exampleFoodItems){
    presets.add(
        ElevatedButton(
          onPressed: () {controller.text = foodItem;} ,
          child: Text(foodItem)
        )
    );
  }
  return Row(children : presets);
}

Widget nameEntrySuggester(TextEditingController controller, bool fieldIsValid) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'missing fields';
      }
      return null;
    },
    decoration: InputDecoration(

        labelText: "Name of Food Item",
        // if the field isn't valid errorText has the value "Value Can't Be Empty"
        // otherwise errorText is null
        errorText: !fieldIsValid ? "Value"
            "Can't Be Empty" : null
    ),

  );

}

Widget weightEntry(TextEditingController controller, bool fieldIsValid){

  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty){
        return 'missing fields';
      }
      return null;
    },
    decoration: InputDecoration(

        labelText: "Weight (g)",
        // if the field isn't valid errorText has the value "Value Can't Be Empty"
        // otherwise errorText is null
        errorText: !fieldIsValid ? "Value"
            "Can't Be Empty" : null
    ),
    controller: controller,
  );

}
