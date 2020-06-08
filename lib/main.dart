import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.orange
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String input = "";

  createTodo(){
    DocumentReference documentReference = Firestore.instance.collection("MyTodo").document(input);

    Map<String,String> todo = {"title":input};

    documentReference.setData(todo).whenComplete(() => print ("$input created"));
  }

  deleteTodo(item){
    DocumentReference documentReference = Firestore.instance.collection("MyTodo").document(item);

    documentReference.delete().whenComplete(() => print ("$item deleted"));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   todos.add("Item 1");
  //   todos.add("Item 2");
  //   todos.add("Item 3");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo App")),
      floatingActionButton: FloatingActionButton(
        onPressed:  (){
          showDialog(context: context,builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text("Add Todo"),
              content: TextField(
                onChanged: (String value){
                  input = value;
                },
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    // setState(() {
                    //   todos.add(input);
                    // });
                    createTodo();
                    Navigator.of(context).pop();
                  },
                  child: Text("Add"),)
              ],
            );
          });
        },
        child: Icon(Icons.add,color:Colors.white),
      ),
      body: StreamBuilder(stream: Firestore.instance.collection("MyTodo").snapshots(),builder: (context,snapshots){
        return ListView.builder(
        shrinkWrap: true,
         itemCount: snapshots.data.documents.length, 
         itemBuilder: (context,index){
           DocumentSnapshot documentSnapshot = snapshots.data.documents[index]; 
           return Dismissible(
             onDismissed: (direction){
               deleteTodo(documentSnapshot["title"]);
             },
             key: Key(documentSnapshot["title"]), 
             child: Card(
               elevation: 1,
               margin: EdgeInsets.all(8),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
               child: ListTile(
                 contentPadding: EdgeInsets.all(10),
                   title:Text(documentSnapshot["title"]),
                   trailing: IconButton(
                     icon: Icon(Icons.delete,color: Colors.orange), 
                     onPressed: (){
                       setState(() {
                         deleteTodo(documentSnapshot["title"]);
                       });
                     }
                   )
                 ),
               ),
             );
         });
      }),

    //   ListView.builder(
    //     itemCount: todos.length, 
    //     itemBuilder: (BuildContext context, int index){
    //       return Dismissible(
    //         key: Key(todos[index]), 
    //         child: Card(
    //           elevation: 1,
    //           margin: EdgeInsets.all(8),
    //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
    //           child: ListTile(
    //             contentPadding: EdgeInsets.all(10),
    //               title:Text(todos[index]),
    //               trailing: IconButton(
    //                 icon: Icon(Icons.delete,color: Colors.orange), 
    //                 onPressed: (){
    //                   setState(() {
    //                     todos.removeAt(index);
    //                   });
    //                 }
    //               )
    //             ),
    //           ),
    //         );
    //     })
    );
  }
}