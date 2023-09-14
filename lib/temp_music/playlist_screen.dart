// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:signal/app/widget/app_app_bar.dart';
// import 'package:signal/app/widget/app_text.dart';
// import 'package:signal/temp_music/playlist_data.dart';
//
// class PlayListScreen extends StatefulWidget {
//   const PlayListScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PlayListScreen> createState() => _PlayListScreenState();
// }
//
// class _PlayListScreenState extends State<PlayListScreen> {
//   AudioPlayer player = AudioPlayer();
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: const AppAppBar(
//           title: AppText('Playlist'),
//         ),
//         body: getBody());
//   }
//
//   getBody() {
//     return ListView.builder(
//       itemCount: audios.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//             title: AppText(audios[index].audioUrl!),
//             trailing: IconButton(
//                 onPressed: () async {
//                   player.stop();
//                   if (audios[index].playingStatus == false) {
//                     player.setUrl(audios[index].audioUrl!);
//                     await player.play();
//                     for(int i=0; i < audios.length;i++)
//                       {
//                         audios[i].playingStatus=false;
//                       }
//                     audios[index].playingStatus=true;
//                     setState(() {});
//                   } else {
//                     await player.pause();
//                     audios[index].playingStatus = false;
//                     setState(() {});
//                   }
//                 },
//                 icon: (audios[index].playingStatus)
//                     ? const Icon(Icons.pause)
//                     : const Icon(Icons.play_arrow)));
//       },
//     );
//   }
// }
