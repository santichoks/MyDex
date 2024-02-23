import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:collection/collection.dart';

const dynamic types = {
  "normal": "FFA8A77A",
  "fire": "FFEE8130",
  "water": "FF6390F0",
  "electric": "FFF7D02C",
  "grass": "FF7AC74C",
  "ice": "FF96D9D6",
  "fighting": "FFC22E28",
  "poison": "FFA33EA1",
  "ground": "FFE2BF65",
  "flying": "FFA98FF3",
  "psychic": "FFF95587",
  "bug": "FFA6B91A",
  "rock": "FFB6A136",
  "ghost": "FF735797",
  "dragon": "FF6F35FC",
  "dark": "FF705746",
  "steel": "FFB7B7CE",
  "fairy": "FFD685AD",
};

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.pokemonList, required this.initIndex});

  final int initIndex;
  final List<dynamic> pokemonList;

  @override
  State<DetailScreen> createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen> {
  dynamic pokemon;
  int currentIndex = 0;
  bool isAnimation = true;

  @override
  void initState() {
    setState(() {
      currentIndex = widget.initIndex;
    });

    callPokemonDetail(widget.pokemonList[widget.initIndex]["id"]);
    super.initState();
  }

  void callPokemonDetail(String id) async {
    var url = Uri.http("pokeapi.co", "/api/v2/pokemon/$id");
    var response = await http.get(url);

    setState(() {
      pokemon = jsonDecode(response.body);
    });
  }

  int getTypeColor(int index) {
    return int.parse(types[pokemon["types"][index]["type"]["name"]], radix: 16);
  }

  String getId() {
    String id = pokemon["id"].toString();
    switch (id.length) {
      case 1:
        return "#000$id";
      case 2:
        return "#00$id";
      case 3:
        return "#0$id";
      default:
        return "#$id";
    }
  }

  @override
  Widget build(BuildContext context) {
    return pokemon != null
        ? Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(380),
              child: Stack(
                children: [
                  AppBar(
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: pokemon["types"].length < 2
                              ? [
                                  Colors.grey,
                                  Color(getTypeColor(0)),
                                ]
                              : [
                                  Color(getTypeColor(0)),
                                  Color(getTypeColor(1)),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.black,
                    actions: [
                      Switch.adaptive(
                        activeColor: Color(getTypeColor(0)),
                        inactiveTrackColor: Colors.grey[700],
                        value: isAnimation,
                        onChanged: (value) => setState(() {
                          isAnimation = !isAnimation;
                        }),
                      )
                    ],
                  ),
                  Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${pokemon["name"][0].toUpperCase()}${pokemon["name"].substring(1, pokemon["name"].length)}",
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                getId(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            children: pokemon["types"].length < 2
                                ? [
                                    Container(
                                      width: 82,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(getTypeColor(0)),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          pokemon["types"][0]["type"]["name"].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    Container(
                                      width: 82,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(getTypeColor(0)),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          pokemon["types"][0]["type"]["name"].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 82,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(getTypeColor(1)),
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          pokemon["types"][1]["type"]["name"].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: PageView(
                            controller: PageController(
                              viewportFraction: 0.36,
                              initialPage: currentIndex,
                            ),
                            onPageChanged: (value) {
                              setState(() {
                                setState(() {
                                  currentIndex = value;
                                  callPokemonDetail(widget.pokemonList[value]["id"]);
                                });
                              });
                            },
                            children: widget.pokemonList.mapIndexed((i, pkm) {
                              return Padding(
                                padding: EdgeInsets.all(i != currentIndex ? 48 : 0),
                                child: Image.network(
                                  isAnimation
                                      ? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${pkm["id"]}.gif"
                                      : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pkm["id"]}.png",
                                  color: i != currentIndex ? Colors.grey[800] : null,
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(38),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("HP"),
                          SizedBox(height: 16),
                          Text("Attack"),
                          SizedBox(height: 16),
                          Text("Defense"),
                          SizedBox(height: 16),
                          Text("Sp.Attack"),
                          SizedBox(height: 16),
                          Text("Sp.Defense"),
                          SizedBox(height: 16),
                          Text("Speed"),
                          SizedBox(height: 16),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            ...List.generate(pokemon["stats"].length, (index) {
                              return Column(
                                children: [
                                  LinearProgressIndicator(
                                    value: pokemon["stats"][index]["base_stat"] / 255,
                                    color: Color(getTypeColor(0)),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(pokemon["stats"].length, (index) {
                          return Column(
                            children: [
                              Text(pokemon["stats"][index]["base_stat"].toString()),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Container(
                color: Colors.white,
                child: const CircularProgressIndicator(color: Colors.red),
              ),
            ),
          );
  }
}
