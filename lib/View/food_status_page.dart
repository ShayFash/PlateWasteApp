import 'package:flutter/material.dart';
import 'food_status_widget.dart';
import 'institution_page_widgets.dart';
import 'upload_data.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

class FoodStatusPage extends StatefulWidget {


  FoodStatusPage( {Key? key}) : super(key: key);

  @override
  State<FoodStatusPage> createState() => _FoodStatusPageState();
}

class _FoodStatusPageState extends State<FoodStatusPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building food status page");
    return Scaffold(
      appBar: AppBar(title: Text('Select the food status'), leading: backButton(context), actions: [modifyButton()]),
      body: _FoodStatusOptions(),
    );
  }


  Widget _FoodStatusOptions(){
    return SafeArea(

      child: Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  <Widget>[
                  foodStatusButton(context,"Food Type 1",()=>UploadData()),

                  foodStatusButton(context,"Food Type 2",()=>UploadData()),

                  foodStatusButton(context,"Food Type 3",()=>UploadData()),



                ],
              )
          )
      ),);
  }
}
