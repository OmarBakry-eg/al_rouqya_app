import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player.dart';
import 'dart:async';

//ca-app-pub-7107675850542949/5823469875 unit id
//ca-app-pub-7107675850542949~9463972618 app id

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> audios = [
    'aud/0.mp3',
    'aud/1.mp3',
    'aud/2.mp3',
    'aud/3.mp3',
    'aud/4.mp3',
    'aud/5.mp3',
    'aud/6.mp3',
    'aud/7.mp3',
    'aud/8.mp3',
  ];
  List<String> titles = [
    'الرقية الشرعية مشاري بن راشد العفاسي',
    'الرقية الشرعية احمد العجمي',
    'الرقية الشرعية سعود الفايز',
    'الرقية الشرعية ادريس ابكر',
    'الرقية الشرعية للوقاية والعلاج من السحر والمس والعين والحسد بصوت الشيخ ماهر المعيقلي',
    'الرقية الشرعية رقية السحر للقارى فارس عباد',
    'الرقية الشرعية للوقاية والعلاج من السحر والمس والعين والحسد بصوت الشيخ ياسر الدوسري',
    'رقية البيت لإبطال االسحر وتاثير العين والحسد وطرد الجن والشياطين',
    'رقية بصوت عذب جميل',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'الرقية الشرعية الشاملة : قناة أمجاد',
          style: GoogleFonts.changa(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          thickness: 1.5,
        ),
        itemCount: audios.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MusicPlayer(
                              url: audios[index], title: titles[index])));
                },
                title: Text(
                  titles[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Container(
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'استمع الآن',
                    style: GoogleFonts.amiri(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
