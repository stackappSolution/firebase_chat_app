class PlayListData {
  String? audioUrl;
  bool playingStatus;

  PlayListData({this.audioUrl, this.playingStatus = false});
}

List<PlayListData> audios = [
  PlayListData(
      audioUrl:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'),
  PlayListData(
      audioUrl:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3'),
  PlayListData(
      audioUrl:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3'),
  PlayListData(
      audioUrl:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3'),
];
