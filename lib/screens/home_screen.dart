import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  List<dynamic> pokemonList = [];
  final TextEditingController _searchController = TextEditingController();
  bool isSearchBar = false;

  @override
  void initState() {
    super.initState();
    callPokemonList();
  }

  void callPokemonList() async {
    var url = Uri.http("pokeapi.co", "/api/v2/pokemon", {"limit": "100000", "offset": "0"});
    var response = await http.get(url);
    var results = jsonDecode(response.body)["results"] as List<dynamic>;

    List<dynamic> pokemons = [];
    for (final pokemon in results) {
      RegExp regex = RegExp(r"/([0-9]+)/");
      Match? match = regex.firstMatch(pokemon["url"]);

      if (match != null) {
        String capturedValue = match.group(1)!;

        pokemons.add({
          "id": capturedValue,
          "name": pokemon["name"],
        });
      }
    }

    setState(() {
      pokemonList = pokemons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchBar
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 20, 16, 10),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    hintText: "Name ...",
                  ),
                ),
              )
            : const Text(
                "MyDex",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchBar = !isSearchBar;
              });

              if (!isSearchBar) {
                _searchController.clear();
              }
            },
            icon: Icon(
              isSearchBar ? Icons.clear : Icons.search,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: pokemonList.where((pokemon) {
          String name = pokemon["name"];
          return name.contains(_searchController.text) ? true : false;
        }).map((pokemon) {
          return Image.network("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${pokemon["id"]}.gif");
        }).toList(),
      ),
    );
  }
}
