import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../functions.dart';
import '../helpers/BrainProvider.dart';

class MainScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    var brainProvider = Provider.of<BrainProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 800) {
/////////////////////////// MOBILE ////////////////////////////////////
        return Scaffold(
          body: Container(
            width: double.infinity,
            color: Color.fromARGB(255, 25, 25, 25),
            child: Column(
              children: [
                Image.asset('assets/logo.png'),
                Text(
                  "Second Brain",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  "Second Brain is a software tool that acts as your personal knowledge base.",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 90),
                Container(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     GestureDetector(
                        onTap: () async {
                          print('upload db file');
                          await uploadDatabase();
                          print('db file uploaded');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Test()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.folder_open),
                            Text("Open brain"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
/////////////////////////// DESKTOP / WEB ////////////////////////////////////
        return Scaffold(
          body: Row(
            children: [
              Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width / 2,
                color: Color.fromARGB(237, 34, 34, 34),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png'),
                      Text(
                        "Second Brain",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        "Second Brain is a software tool that acts as your personal knowledge base.",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width / 2,
                color: Color.fromARGB(255, 25, 25, 25),
                child: Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          print('upload db file');
                          await uploadDatabase();
                          print('db file uploaded');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Test()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.folder_open),
                            Text("Open brain"),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          
                          await brainProvider.createBrain();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Test()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.folder_open),
                            Text("Create new brain"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}



//// TEMP
class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String userString = '__';
  List<String> collectionList = [];
  @override
  Widget build(BuildContext context) {
    var brainProvider = Provider.of<BrainProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(userString),
            ElevatedButton(onPressed: () async {
              
              try{
                List<Map<String, dynamic>> collections = await brainProvider.getBrainCollections();
              if (collections.isNotEmpty){
                // Display the retrieved brain collections
                print('Brain Collections:');
                setState(() {
                for (var collection in collections){
                  collectionList.add(collection['title']);
                }
                });
                
              }else{
                print('No collections found.');
              }
              }catch(e){
                print('Error while getting collections: $e');
              }
            }, child: Text("Display all"),),
            ElevatedButton(
              child: Text("Insert Collection"),
              onPressed: () async {

                var data = {
                  'title': 'Sample Collection',
                  'description': 'This is a sample brain collection.',
                  'created_at': DateTime.now().microsecondsSinceEpoch,
                };
                try{
                  await brainProvider.insertBrainCollection(data);
                }catch(e){
                  print('Error while inserting a collection: $e');
                }
                
              },
            ),
            ElevatedButton(onPressed: (){
              downloadDatabase();
            }, child: Text('Download DB'),),
            Column(children: [
              for (var i=0;i<collectionList.length;i++)
                Text('Title: ${collectionList[i]}'),
            ],)
          ],
        ),
      ),
    );
  }
}
