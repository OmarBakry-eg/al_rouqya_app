import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

const unitId = "ca-app-pub-7107675850542949/5823469875";

class MusicPlayer extends StatefulWidget {
  final String title;
  final String url;
  MusicPlayer({@required this.url, @required this.title});
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;
  AudioPlayer player;
  AudioCache cache = AudioCache();
  bool playing = false;
  IconData playBtn = Icons.play_arrow;
  Duration position = new Duration();
  Duration musicLength = new Duration();
  var image;

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble() ?? 0,
          min: 0.0,
          max: musicLength.inSeconds.toDouble() ?? 0,
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    player.seek(newPos);
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;
      case AdLoadState.loadError:
        setState(() {
          _height = 100;
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    image = Random().nextInt(3) + 2;
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };
    player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _nativeAdController.dispose();
    player.dispose();
    cache.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () async {
            await player.dispose();
            cache.clearCache();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'الرقية الشرعية الشاملة : قناة أمجاد',
          style: GoogleFonts.changa(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: 280.0,
                height: 280.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    image: DecorationImage(
                      image: AssetImage("assets/$image.jpg"),
                      fit: BoxFit.fill,
                    )),
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 500.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          slider(),
                          Text(
                            "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 45.0,
                          color: Colors.blue,
                          onPressed: () {
                            seekToSec(position.inSeconds - 10);
                          },
                          icon: Icon(
                            Icons.fast_rewind,
                          ),
                        ),
                        IconButton(
                          iconSize: 62.0,
                          color: Colors.blue[800],
                          onPressed: () {
                            if (!playing) {
                              cache.play(widget.url);
                              setState(() {
                                playBtn = Icons.pause;
                                playing = true;
                              });
                            } else {
                              player.pause();
                              setState(() {
                                playBtn = Icons.play_arrow;
                                playing = false;
                              });
                            }
                          },
                          icon: Icon(
                            playBtn,
                          ),
                        ),
                        IconButton(
                          iconSize: 45.0,
                          color: Colors.blue,
                          onPressed: () {
                            seekToSec(position.inSeconds + 10);
                          },
                          icon: Icon(
                            Icons.fast_forward,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: _height,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: NativeAdmob(
                        adUnitID: unitId,
                        controller: _nativeAdController,
                        type: NativeAdmobType.banner,
                        error: Text("Failed to load the ad"),
                        loading: Container(),
                        options: NativeAdmobOptions(
                          ratingColor: Colors.red,
                        ),
                      ),
                    ),
                    // NativeAd(
                    //   buildLayout: adBannerLayoutBuilder,
                    //   loading: Text('loading'),
                    //   error: Text('Failed to load the ad'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
