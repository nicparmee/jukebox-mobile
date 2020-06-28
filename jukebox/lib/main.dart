import 'dart:convert';

import 'package:flutter/material.dart';
import 'shared/constants.dart';
import 'shared/loading.dart';
import 'models/track-json.dart';
import 'models/data-json.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JukeBox',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Search Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

bool loading = false;
Future<String> state = "" as Future<String>;

Future<String> addToJukeBoxAPI(JsonTrack track) async{

 final http.Response resp = await http.post(
      'http://jukebox-api.azurewebsites.net/tracks/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'track_id': track.track_id.toString(),
        'title': track.title,
        'artist': track.artist,
        'picture_big': track.picture_big,
        'played': 'false',
        'web_user': track.web_user.toString(),
      }),
    );
    if (resp.statusCode == 200) {
        
      return "success";
    } else {

      return "failed";
    }
  
}


Future<String> getTrack(String search) async {
    final http.Response resp = await http.get(
      'https://api.deezer.com/search?q=' + search,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      
    );
    if (resp.statusCode == 200) {
  
      JsonData response = JsonData.fromJson(json.decode(resp.body));
      JsonTrack track = new JsonTrack.fromJson(response.data[0]);
      
     // return addToJukeBoxAPI(track);
      return null;
    } else {

      throw Exception('Failed to save user');
    }
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
  
      _counter++;
    });
  }

String _addTrack;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
     
        child: loading ? Loading():Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                 child:   Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ 
                      SizedBox(
                        width: 200,
                       child:TextFormField(
                         
                         decoration: textFormDecoration.copyWith(
                                hintText: 'Input name'),
                            validator: (val) =>
                                val.isEmpty ? 'Please enter a song name' : null,
                            onChanged: (val) => setState(() {
                              _addTrack = val;
                            }),
                      ),
                      ),
                      RaisedButton(
                        // on pressed fetch track
                        // and add to own api
                        // loading screen
                        onPressed:()async{
                          loading = true;
                          state = getTrack(_addTrack);
                          },
                        
          //    child: FutureBuilder(
          //      future: getTrack("Blinding lights"),
          //      builder: (context, snapshot){
          //        JsonTrack track = snapshot.data ?? new JsonTrack(uid: 1, title: "in", duration: 5);
                      
                    ),
                    ]
                    ),
                    
            ),
         //   Text(track.title),
              FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
          ]
        ),
      
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
