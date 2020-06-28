import 'package:jukebox/models/track-json.dart';
import 'package:flutter/material.dart';


class TrackTile extends StatelessWidget{

  final JsonTrack track;
  
  TrackTile({this.track});

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
        // Check if the track is playing or is played and grey if it has been played
        color: track.playing ? Colors.green : track.played ? Colors.grey : Colors.white,
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
            backgroundImage: new NetworkImage(track.picture_big),
          ),
          title: Text(track.title),
          subtitle: Text(track.artist),
        ),
      ),
    );
  }
}