import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled3/src/Home1.dart';
import 'package:untitled3/src/members.dart';
import 'package:untitled3/src/gallery.dart';
import 'package:untitled3/src/about.dart';
import 'package:untitled3/src/publication.dart';


class Home extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
//        primaryColor: Colors.white,
        brightness: Brightness.dark
      ),
      home: Tabs(),
    );
  }
}

class Tabs extends StatefulWidget {
  const Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Home1(),
      About(),
      Members(),
      Gallery(),
      Publication(),
    ];
    final _kTabs = <Tab>[
      Tab(child: Text("Home",textScaleFactor: 0.8,)),
      Tab(child: Text("Research",textScaleFactor: 0.8,),),
      Tab(child: Text("Members",textScaleFactor: 0.8,),),
      Tab(child: Text("Gallery",textScaleFactor: 0.8,),),
      Tab(child: Text("Publication",textScaleFactor: 0.7,),),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SELAB"),
          elevation: 0,

          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}
