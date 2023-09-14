import 'package:signal/pages/chating_page/video_view/video_player_view.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel{

  VideoPlayerView? videoPlayerView;


  Map<String,dynamic> arguments={};
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayer;
  VideoPlayerViewModel(this.videoPlayerView);
  double videoPlayerValue = 0.0;
  double sliderValue = 0.0;


  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }


  void stopVideoPlayback() {
    if (videoController != null &&
        videoController!.value.isPlaying) {
      videoController!.pause();
    }
  }

}