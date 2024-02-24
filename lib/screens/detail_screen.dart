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
  dynamic pokemonSpecies;
  dynamic pokemonEvolution;
  int currentIndex = 0;
  bool isAnimation = false;

  @override
  void initState() {
    setState(() {
      currentIndex = widget.initIndex;
    });

    callPokemonDetail(widget.pokemonList[widget.initIndex]["id"]);
    callPokemonSpecies(widget.pokemonList[widget.initIndex]["id"]);
    callPokemonEvolution(widget.pokemonList[widget.initIndex]["id"]);
    super.initState();
  }

  Future callPokemonDetail(String id) async {
    var url = Uri.http("pokeapi.co", "/api/v2/pokemon/$id");
    var response = await http.get(url);
    var pk = jsonDecode(response.body);

    url = Uri.http("pokeapi.co", "/api/v2/pokemon-species/$id");
    response = await http.get(url);
    var pkSpecies = jsonDecode(response.body);

    setState(() {
      pokemon = pk;
      pokemonSpecies = pkSpecies;
    });
  }

  Future callPokemonSpecies(String id) async {
    var url = Uri.http("pokeapi.co", "/api/v2/pokemon-species/$id");
    var response = await http.get(url);

    setState(() {
      pokemonSpecies = jsonDecode(response.body);
    });
  }

  Future callPokemonEvolution(String id) async {
    var url = Uri.http("pokeapi.co", "/api/v2/evolution-chain/$id");
    var response = await http.get(url);

    setState(() {
      pokemonEvolution = jsonDecode(response.body);
    });
  }

  int getTypeColor(int index) {
    return int.parse(types[pokemon["types"][index]["type"]["name"]], radix: 16);
  }

  String getId(bool isNumberSign) {
    String id = pokemon["id"].toString();
    switch (id.length) {
      case 1:
        return isNumberSign ? "#000$id" : "000$id";
      case 2:
        return isNumberSign ? "#00$id" : "00$id";
      case 3:
        return isNumberSign ? "#0$id" : "0$id";
      default:
        return isNumberSign ? "#$id" : id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return pokemon != null
        ? Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(360),
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
                                getId(true),
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
                              viewportFraction: 0.40,
                              initialPage: currentIndex,
                            ),
                            onPageChanged: (value) {
                              setState(() {
                                setState(() {
                                  currentIndex = value;
                                  callPokemonDetail(widget.pokemonList[value]["id"]);
                                  callPokemonSpecies(widget.pokemonList[value]["id"]);
                                  callPokemonEvolution(widget.pokemonList[value]["id"]);
                                });
                              });
                            },
                            children: widget.pokemonList.mapIndexed((i, pkm) {
                              return Padding(
                                padding: EdgeInsets.all(i != currentIndex ? 52 : 0),
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
              padding: const EdgeInsets.all(0),
              child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 12,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      labelColor: Color(getTypeColor(0)),
                      indicatorColor: Color(getTypeColor(0)),
                      tabs: const [
                        Tab(icon: Icon(Icons.feed)),
                        Tab(icon: Icon(Icons.leaderboard)),
                        Tab(icon: Icon(Icons.album)),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ID",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Gender Rate",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Catch Rate",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Weight",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Height",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                                const SizedBox(width: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${pokemon["id"]}"),
                                    const SizedBox(height: 16),
                                    Text("${pokemon["name"][0].toUpperCase()}${pokemon["name"].substring(1, pokemon["name"].length)}"),
                                    const SizedBox(height: 16),
                                    Text(pokemonSpecies["gender_rate"] == -1 ? "Genderless" : "${((8 - pokemonSpecies["gender_rate"]) / 8) * 100}/${(pokemonSpecies["gender_rate"] / 8) * 100} M/F"),
                                    const SizedBox(height: 16),
                                    Text("${((pokemonSpecies["capture_rate"] / 255) * 100).toStringAsFixed(2)}%"),
                                    const SizedBox(height: 16),
                                    Text("${(pokemon["weight"] * 0.1).toStringAsFixed(2)} kg"),
                                    const SizedBox(height: 16),
                                    Text("${(pokemon["height"] * 1.016).toStringAsFixed(2)} m"),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                        child: Column(
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "HP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Attack",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Defense",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Sp.Attack",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Sp.Defense",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Speed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                        Text(
                                          pokemon["stats"][index]["base_stat"].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.block, size: 58, color: Colors.grey[500]),
                          const SizedBox(height: 16),
                          const Text("this Pokémon have no evolutions."),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                color: Colors.white,
                child: const CircularProgressIndicator(color: Colors.red),
              ),
            ),
          );
  }
}
