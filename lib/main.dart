import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}
const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _multiplyBy = 1;
  String _imageName = "images/pokeball.png";
  bool _chooseTypeBool = false;
  int _choosePokemon = 0;

  void _setImageName(){
    setState(() {
      if (_counter >= 30 && _chooseTypeBool == false) {
        _pokemonTypeAlertBox();
        _chooseTypeBool = true;
      } else if (_counter >= 30){
        _imageName = _imageName;
      }else {
        _imageName =  _imageName;
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter = _counter + (1*_multiplyBy);
      _setImageName();
    });
  }
  void _resetCounter(){
    setState(() {
      _counter = 0;
    });
  }

  void _buyIncrementMultiplyBy(){
    setState(() {
      var cost = 8 * _multiplyBy;
      if (_counter >= cost){
        _counter -= cost;
        _multiplyBy++;
      }
    });
  }

  void _setPokemontype(String imageName){
    setState(() {
        _imageName = imageName;
    });
  }
  void _loadParameters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
      _multiplyBy = (prefs.getInt('multiplyBy') ?? 1);
    });
  }

  void _autoSaving() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('counter', _counter);
      await prefs.setInt('multiplyBy', _multiplyBy);
    });
  }

  void _initGame() async {
    _loadParameters();
    _autoSaving();
  }


  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future <void> _soundMaker(String soundPath) async {
    final player = AudioPlayer();
    var duration = await player.setAsset(soundPath);
    player.play();
  }
// ALERT BOX
  Future<void> _pokemonTypeAlertBox() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
          Text('Choose your pokemon type'),]),
          actions: <Widget>[
            SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () =>
                {
                  Navigator.pop(context, 'Cancel'),
                  _soundMaker("sounds/bulbasaur.mp3"),
                  _choosePokemon = 1,
                  _setPokemontype("images/bulbizarre.png")},

                    child: Image.asset(
                        "images/grassType.png", width: 50, height: 50)),
                TextButton(onPressed: () =>
                {
                  Navigator.pop(context, 'Cancel'),
                  _soundMaker("sounds/charmander.mp3"),
                  _choosePokemon = 2,
                  _setPokemontype("images/salameche.png")},
                    child: Image.asset(
                        "images/fireType.png", width: 50, height: 50)),
                TextButton(onPressed: () =>
                {
                  Navigator.pop(context, 'Cancel'),
                  _soundMaker("sounds/squirtle.mp3"),
                  _choosePokemon = 3,
                  _setPokemontype("images/carapuce.png")},
                  child: Image.asset(
                      "images/waterType.png", width: 50, height: 50),),
              ],
            )
          )
        ]
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/pokemonFond.jpg"),
              fit: BoxFit.fill,
              ),
            ),
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Pokemon in pokedex',
                style: GoogleFonts.indieFlower(
                    textStyle: TextStyle(color: Colors.black, fontSize: 25)
                ),
              ),
              SizedBox(width: double.infinity),
              Text(
                '$_counter',
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: GoogleFonts.indieFlower(
                    textStyle: TextStyle(color: Colors.black, fontSize: 60)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                    onPressed: _incrementCounter,
                    child: Image.asset(_imageName)
                ),
              ),
              Column(
                children: [
                  TextButton(
                      onPressed: _buyIncrementMultiplyBy,
                      child: Icon(Icons.catching_pokemon)),
                  Text(
                      'x $_multiplyBy',
                      style: GoogleFonts.indieFlower(
                        textStyle: TextStyle(color: Colors.black, fontSize: 20)
                      ),
                  ),
                  Text(
                    'cost : ${_multiplyBy*8}',
                    style: GoogleFonts.indieFlower(
                        textStyle: TextStyle(color: Colors.black, fontSize: 20)
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _resetCounter(),
          _chooseTypeBool = false,
          _multiplyBy = 1,
          _setPokemontype("images/pokeball.png")
        },
        tooltip: 'reset',
        child: const Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
