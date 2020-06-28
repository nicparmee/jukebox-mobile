import 'dart:convert';

import 'package:jukebox/models/track-json.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class TrackTile extends StatelessWidget{

  final JsonTrack track;
  
  TrackTile({this.track});


/*Future<JsonDecode> addFriend(String uid, String frienduid) async {
  final http.Response resp = await http.post(
    'https://parmtree.co.za/events/friend_functions.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'function': 'addFriend',
      'uid': uid,
      'frienduid': frienduid,
    }),
  );
  if (resp.statusCode == 200) {
     print("her");
    JsonDecode response = JsonDecode.fromJson(json.decode(resp.body));
    return response;
  } else {
    throw Exception('Failed to add user');
  }
}

Future<JsonDecode> acceptFriend(String uid, String frienduid) async {
  final http.Response resp = await http.post(
    'https://parmtree.co.za/events/friend_functions.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'function': 'acceptFriend',
      'uid': uid,
      'frienduid': frienduid,
    }),
  );
  if (resp.statusCode == 200) {
    JsonDecode response = JsonDecode.fromJson(json.decode(resp.body));
    return response;
  } else {
    throw Exception('Failed to save user');
  }
}*/

  createAlertDialog(BuildContext context, String text){
      return showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text(text),
        );
      });
  }

  @override
  Widget build(BuildContext context){
    

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: track.playing ? Colors.green : Colors.white,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[   
              // Potentially a play button    
              /* IconButton(
                  iconSize: 20.0,
                  color: Colors.red,
                  onPressed: ()async{
                
                    }, 
                  icon: Icon(Icons.add),
                ), */
            ],
          ),
          leading: CircleAvatar(
            radius: 25.0,
           //backgroundColor: Colors.black38,
            backgroundImage: new NetworkImage(track.picture_big),
          ),
          title: Text(track.title),
          subtitle: Text(track.artist),
          
        ),

      ),
    );
  }
}