import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import "../Model/variables.dart";
import 'camera_food2.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

Widget inputIDButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  //It displays a button to manually input the id
  //PreCond:
  //          1. Requires context of current page,
  //

  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button open a popup window to take the user input for ID
  return SizedBox(
      height: height / 12,
      width: width / 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 5),
              borderRadius: new BorderRadius.circular(3)),
        ),
        child: Text("Manual ID Entry", style: TextStyle(fontSize: 32)),
        onPressed: () {
          //await reassemble();
          Navigator.push(context, MaterialPageRoute(//open new one to scan
              builder: (context) {
            return InputIDForm(); //open the Input id pop box
          }));
        },
      ));
}

class InputIDForm extends StatefulWidget {
  InstitutionInfo currentInstitution;
  FoodStatus currentFoodStatus;
  InputIDForm(this.currentInstitution, this.currentFoodStatus, {Key? key}) : super(key: key);

  @override
  _InputIDFormState createState() => _InputIDFormState();
}

class _InputIDFormState extends State<InputIDForm> {
  //Creates a form to take user input
  final _newIdInputController = TextEditingController();
  final _newIdInputFormKey = GlobalKey<FormState>();
  // assume our input values are valid by default
  bool _IdInputEmpty = false;
  bool _IdBelongsToSubject = true;

  @override
  Widget build(BuildContext context) {
    Config.log.i("building add institution form widget");
    return AlertDialog(
      content: Stack(
        // overflow: Overflow.visible,
        children: <Widget>[
          Form(
            key: _newIdInputFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.perm_identity),
                        labelText: "ID",
                        // if our field is empty our errorText has the value "Value Can't Be Empty"
                        // otherwise if the input ID doesn't belong to a subject we inform the user of this
                        // otherwise we have null ie no error message
                        errorText: _IdInputEmpty ? "Value Can't Be Empty" :
                          !_IdBelongsToSubject ? "Input ID ${_newIdInputController.value.text} Doesn't Belong To a Subject In This Institution" : null
                    ),
                    controller: _newIdInputController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    formCancel(context),
                    formSubmit(context)
                  ], //buttons to perform operations to cancel or submit the input
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formSubmit(BuildContext context) {
    //It displays a form submit button and validates the user input
    //PreCond:
    //          1. Requires context of current page
    //
    //PostCond:
    //          1. Button is displayed on the page
    //          2. On press the button validates the user input and if its not empty then record exists then it opens
    //             camera for empty food state to take pictures

    return ElevatedButton(
        onPressed: () async {
          // validate form inputs manually as validate() function of form isn't working
          String newId = _newIdInputController.value.text;


          Config.log.i("pressed button to submit add input id form with student id: " + newId);

          this._IdInputEmpty = newId == null || newId.isEmpty;

          if(!this._IdInputEmpty){
            // the input ID is not empty, determine if this is a valid ID for a subject in this
            // institution
            Config.log.i("user entered id: "+ newId);
            // construct a SubjectInfo object using this ID
            SubjectInfo targetSubjectInfo = SubjectInfo(newId);
            // check if the constructed targetSubjectInfo is stored under the current institution
            // on the database
            await Database().institutionHasSubject(ResearchGroupInfo("testResearchGroupName"), widget.currentInstitution, targetSubjectInfo).then((subjectExists){
              setState((){
                // update our class variables from within setState so ui which may
                // depend upon these variables is also updated
                // re-evaluate this._IdInputEmpty here even though we already have this
                // value as we want to set both of our validation fields within
                // the same setState to avoid timing issues
                this._IdInputEmpty = newId == null || newId.isEmpty;
                // if the subject exists under the current institution on our database, the
                // input subject ID does correspond to an actual subject for this institution
                // otherwise the input ID is invalid
                this._IdBelongsToSubject = subjectExists;
              });
              if(this._IdBelongsToSubject) {
                // input ID is valid, allow the user to submit data for the subject with this ID

                // clear our text fields before exiting the add Institution popup
                // exit this popup before going to our next page so this popup isn't
                // revisited when we press the back button
                this._newIdInputController.clear();
                Navigator.of(context, rootNavigator: true).pop();

                // proceed to the pages to enter data for this particular subject
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return CameraFood2(widget.currentInstitution, targetSubjectInfo, widget.currentFoodStatus);
                    }));
              }
              else{
                // input ID is invalid, do not allow the user to continue until a
                // valid ID is provided
                Config.log.w("Input User Id not valid, doesn't correspond to subject within institution");
              }
            });
          }
          else{
            setState((){
              // set our state again so relevant error messages are displayed
              this._IdInputEmpty = newId == null || newId.isEmpty;
            });
            Config.log.w("User Id not provided");
          }
        },
        child: const Text("Submit"));
  }

  Widget formCancel(BuildContext context) {
    //It displays a form cancel button to close the input pop
    //PreCond:
    //          1. Requires context of current page
    //
    //PostCond:
    //          1. Button is displayed on the page
    //          2. On press the button navigates back to the previous page
    return ElevatedButton(
        onPressed: () {
          Config.log.i("cancelling form submission");
          // clear the text fields before exiting the add Institution popup
          this._newIdInputController.clear();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Cancel"));
  }

  @override
  void dispose() {
    // dispose of created text controllers to avoid memory leaks
    this._newIdInputController.dispose();
    super.dispose();
  }
}

Widget manualInput(BuildContext context, String btnName, Widget Function() page,
    int iconIndex) {
  //It displays a a button to input the id manually
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. Page function to navigate to the next page
  //          4. icon index to display the button icon
  //
  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button opens the next page (manual id popup)

  assert(btnName.isNotEmpty);
  assert(iconIndex >= 0);
  return Flexible(
      child: SizedBox(
          height: 140,
          width: 300,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return page();
                }));
              },
              child: Column(children: <Widget>[
                Text(
                  btnName,
                  style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context)
                        .fontSize(4), // insert your font size here
                  ),
                ),
                Icon(
                  categories[iconIndex].icon,
                  color: Colors.orange,
                  size: 50.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )
              ]))));
}
