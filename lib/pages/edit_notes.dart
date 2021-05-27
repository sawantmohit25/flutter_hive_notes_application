import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/adapters/notes_adapter.dart';
class EditNotes extends StatefulWidget {
  int index;
  String title;
  String description;
  EditNotes({this.title,this.description,this.index});
  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title='';
  String description='';
  final _formKey = GlobalKey<FormState>();
   String validateTitleAndDescription(val){
    if (val.isEmpty) {
      return 'Required';
    }
    return null;
  }
  @override
  void initState() {
    setState(() {
      titleController.text=widget.title;
      descriptionController.text=widget.description;
    });
    super.initState();
  }
  @override
  void dispose() {
     titleController.dispose();
     descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.deepPurple[400],
      appBar:AppBar(
        title:Text('Edit Note'),
        centerTitle: true,
        backgroundColor:Colors.deepPurple,
      ),
      body:SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,0),
            child:Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Container(color:Colors.deepPurple,height:250,child: Image.asset('assets/notepadimage.png')),
                  SizedBox(height:20,),
                  TextFormField(
                    style: TextStyle(color:Colors.purple),
                    decoration: InputDecoration(errorStyle:TextStyle(color:Colors.white),hintStyle:TextStyle(color:Colors.purple),hintText:'Title',fillColor: Colors.white,filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.white,width: 2.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.pink,width: 2.0),
                      ),
                    ),
                    validator:validateTitleAndDescription,
                    controller:titleController,
                    onChanged: (val){
                      setState(() {
                        title=val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    style: TextStyle(color:Colors.purple),
                    decoration: InputDecoration(errorStyle:TextStyle(color:Colors.white),hintStyle:TextStyle(color:Colors.purple),hintText:'Description',fillColor: Colors.white,filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.white,width: 2.0),
                      ),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.pink,width: 2.0),
                      ),
                    ),
                    validator: validateTitleAndDescription,
                    controller: descriptionController,
                    maxLines:8,
                    onChanged: (val){
                      setState(() {
                        description=val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(onPressed: (){
                    if(_formKey.currentState.validate()){
                      Box<Notes> notes=Hive.box<Notes>('notes');
                      notes.putAt(widget.index,Notes(title:title,description:description));
                      Fluttertoast.showToast(
                          msg:'Note Edited Successfully',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.white,
                          textColor: Colors.deepPurple
                      );
                      Navigator.pop(context);
                    }
                  },color: Colors.white,
                    child: Text('EDIT',style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold),),),
                ],
              ),
            )
        ),
      ),
    );
  }
}
