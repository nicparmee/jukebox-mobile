import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jukebox/track-player/track-player.dart';
import 'shared/constants.dart';
import 'shared/loading.dart';
import 'models/track-json-deezer.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String state = "";

  Future<String> addToJukeBoxAPI(JsonTrackDeezer track) async {
    final http.Response resp = await http.post(
      'http://jukebox-api.azurewebsites.net/tracks/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'track_id': track.track_id,
        'title': track.title,
        'artist': track.artist,
        'picture_big': track.picture_big,
        'played': false,
        'web_user_id': track.web_user,
      }),
    );
    if (resp.statusCode == 201) {
      loading = false;
      return "success: " +
          track.title +
          " by " +
          track.artist +
          " has been added to your jukebox!";
    } else {
      loading = false;
      return "sorry something went wrong";
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
      JsonTrackDeezer track = new JsonTrackDeezer.fromJson(response.data[0]);

      return addToJukeBoxAPI(track);
    } else {
      loading = false;
      return "sorry we couldn't find that song";
    }
  }

  String _addTrack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Music to Jukebox"),
      ),
      body: Center(
        child: loading
            ? Loading()
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
                new Flexible(
                  child: Form(
                    key: _formKey,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              decoration: textFormDecoration.copyWith(
                                  hintText: 'Song Name'),
                              validator: (val) => val.isEmpty
                                  ? 'Please enter a song name'
                                  : null,
                              onChanged: (val) => setState(() {
                                _addTrack = val;
                              }),
                            ),
                          ),
                          RaisedButton(
                            // on pressed fetch track
                            // and add to own api
                            // initialise loading screen
                            child: Text("Add"),
                            padding: EdgeInsets.all(5.0),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  state = "searching for track";
                                });
                                loading = true;
                                dynamic response = await getTrack(_addTrack);
                                setState(() {
                                  state = response;
                                });
                              }
                            },
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    state,
                    style: new TextStyle(fontSize: 12.0, color: Colors.black),
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FloatingActionButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (TrackPlayer()))),
                  tooltip: 'Play Music',
                  child: Icon(Icons.play_arrow),
                ),
              ]),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
