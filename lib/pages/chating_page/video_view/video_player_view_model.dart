import 'package:signal/pages/chating_page/video_view/video_player_view.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel{

  VideoPlayerView? videoPlayerView;


  Map<String,dynamic> arguments={};
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayer;
  VideoPlayerViewModel(this.videoPlayerView);
  double videoPlayerValue = 0.0;

}