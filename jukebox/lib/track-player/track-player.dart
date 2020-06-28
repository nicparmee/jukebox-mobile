import 'dart:async';
import 'dart:convert';

import 'package:jukebox/models/track-json.dart';
import 'package:jukebox/shared/constants.dart';
import 'package:jukebox/shared/loading.dart';
import 'package:jukebox/tiles/track-tile.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:http/http.dart' as http;

class TrackPlayer extends StatefulWidget {
  @override
  _TrackPlayerState createState() => _TrackPlayerState();
}

class _TrackPlayerState extends State<TrackPlayer> {
  Timer timer;
  List<JsonTrack> tracks = [];
  bool firstBuild = true;
  int index;
  var rng = new Random();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    searchTracks();
  }

  // Logic for playing the tracks
  void selectPlayingTrack() {
    if (firstBuild) {
      index = rng.nextInt(tracks.length);
      tracks[index].changePlayed(true);
      tracks[index].changePlaying(true);
      firstBuild = false;
      timer = Timer.periodic(
          Duration(seconds: 15), (Timer t) => selectPlayingTrack());
    } else {
      setState(() {
        tracks[index].changePlaying(false);
        index = (index + 1) % tracks.length;
        if (tracks[index].played) {
          // end of playing all songs
          timer?.cancel();
          // potentially
          // firstBuild = true
          // run again
        } else {
          tracks[index].changePlayed(true);
          tracks[index].changePlaying(true);
        }
      });
    }
  }

  List<JsonTrack> parseTracks(String responseBody) {
    print(responseBody);
    final parsed = json.decode(responseBody);
    List<JsonTrack> tracksList = new List<JsonTrack>.from(
        parsed.map((json) => JsonTrack.fromJson(json)).toList());
    return tracksList;
  }

  // Fetch tracks from own server
  void searchTracks() async {
    final http.Response resp = await http.get(
      'http://jukebox-api.azurewebsites.net/tracks/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (resp.statusCode == 200) {
      // Prep list and select first track to play
      tracks = parseTracks(resp.body);
      selectPlayingTrack();
      setState(() {
        loading = false;
      });
    } else {
     
      throw Exception('Failed to save user');
    }
  }

  Widget showTrackList() {
    return ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return new TrackTile(track: tracks[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jukebox Player"),
      ),
      body: loading ? Loading() : Container(child: showTrackList()),
    );
  }
}
