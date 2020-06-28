import 'dart:convert';

import 'package:jukebox/models/track-json.dart';
import 'package:jukebox/shared/constants.dart';
import 'package:jukebox/shared/loading.dart';
import 'package:jukebox/tiles/track-tile.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class TrackPlayer extends StatefulWidget {
  @override
  _TrackPlayerState createState() => _TrackPlayerState();
}

class _TrackPlayerState extends State<TrackPlayer>{

List<JsonTrack> parseUsers(String responseBody) {
  print(responseBody);
  final parsed = json.decode(responseBody);
  List<JsonTrack> parsed2 = new List<JsonTrack>.from(parsed.map((json) => JsonTrack.fromJson(json)).toList());
  return parsed2;
}

Future<List<JsonTrack>> searchTracks() async {
  final http.Response resp = await http.get(
    'http://jukebox-api.azurewebsites.net/tracks/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (resp.statusCode == 200) {
    
   return parseUsers(resp.body);
   
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to save user');
  }
}

 Widget showTrackList(){
    return Container(
      height: 400.0,
      child: FutureBuilder(
          future: searchTracks(),  
          builder: (context, snapshot){
           
            if(snapshot.connectionState == ConnectionState.done){
              
              List<JsonTrack> tracks = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: tracks.length,
                  itemBuilder: (context, index){
                  return new TrackTile(track: tracks[index]);
                });    
            }else {
              
              return Loading();
            }
          }
        ),
    );
}
  

    @override
  Widget build(BuildContext context) {

 return Scaffold(
      appBar: AppBar(
         title: Text("Jukebox Player"),
      ),
      body:  Container(
          child:showTrackList(),
        ),
 );
  }
}
