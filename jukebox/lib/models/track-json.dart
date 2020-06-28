class JsonTrack{

    final int track_id;
  final String title;
  final String artist;
  final String picture_big;
  final bool played;
  final int web_user;

  JsonTrack({ this.track_id, this.title, this.artist, this.picture_big, this.played, this.web_user});

factory JsonTrack.fromJson(Map<String, dynamic> json){

  return JsonTrack(
    track_id: json['id'],
    title: json['title'],
    artist: json['artist']['name'],
    picture_big: json['artist']['picture_big'],
    played: false,
    web_user: json['web_user'],
  );
 
}


}