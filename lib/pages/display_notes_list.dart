import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/adapters/notes_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/pages/add_notes.dart';
import 'package:notes_app/pages/edit_notes.dart';
class DisplayNotesList extends StatefulWidget {
  @override
  _DisplayNotesListState createState() => _DisplayNotesListState();
}

class _DisplayNotesListState extends State<DisplayNotesList> {
  Box<Notes> box ;
@override
  void initState() {
    box = Hive.box<Notes>('notes');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:FloatingActionButton.extended(backgroundColor:Colors.deepPurple,icon:Icon(Icons.note_add),onPressed:(){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>AddNotes()));
      }, label:Text('Add a Note')) ,
      appBar:AppBar(
        title:Text('Notes') ,
        centerTitle: true,
        backgroundColor:Colors.deepPurple,
      ),
      body:Container(
        decoration:BoxDecoration(
            gradient:LinearGradient(
              colors: [
                Colors.deepPurple[200],
                Colors.deepPurple[800]
              ],
              begin:Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,20.0),
          child: ValueListenableBuilder(
            valueListenable:box.listenable(),
            builder: (context,Box<Notes> box,_){
              if(box.values.isEmpty) {
                return Center(child: Text(
                  'No Notes Available', style: TextStyle(fontSize: 40,color:Colors.white),),);
              }
              else{
                return ListView.builder(
                    itemCount:box.length,
                    itemBuilder:(context,index){
                      Notes notes=box.getAt(index);
                      return Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10.0,
                            child: ListTile(
                              title:Text(notes.title,style:TextStyle(fontWeight:FontWeight.bold),),
                              subtitle:Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children: [
                                      Text(notes.description),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Text("Edit",style:TextStyle(color:Colors.deepPurple),),
                                            SizedBox(width:5.0),
                                            Icon(Icons.edit,color:Colors.deepPurple,),
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder:(context)=>EditNotes(index:index,title:notes.title,description:notes.description,)));
                                        },
                                      ),
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Text('Delete',style:TextStyle(color:Colors.deepPurple),),
                                            SizedBox(width:5.0),
                                            Icon(Icons.delete,color:Colors.deepPurple),
                                          ],
                                        ),
                                        onPressed: () async{
                                          await box.deleteAt(index);
                                          Fluttertoast.showToast(
                                              msg:'Note Deleted Successfully',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.deepPurple
                                          );
                                        },
                                      ),
                                    ],)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:20.0,)
                        ],
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}
