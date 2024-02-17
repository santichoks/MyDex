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
  final ScrollController _scrollController = ScrollController();
  bool isSearchBar = false;
  bool showbtn = false;

  @override
  void initState() {
    callPokemonList();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10) {
        showbtn = true;
        setState(() {});
      } else {
        showbtn = false;
        setState(() {});
      }
    });

    super.initState();
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
                  borderRadius: BorderRadius.circular(12),
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
      floatingActionButton: Visibility(
        visible: showbtn,
        child: FloatingActionButton.small(
          shape: const CircleBorder(),
          onPressed: () {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
            );
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
      ),
      body: pokemonList.isNotEmpty
          ? GridView(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
              ),
              children: pokemonList.where((pokemon) {
                String name = pokemon["name"];
                return name.contains(_searchController.text.toLowerCase()) ? true : false;
              }).map((pokemon) {
                return Card(
                  color: Colors.red[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: -30,
                        child: Opacity(
                          opacity: 0.15,
                          child: Image.network(
                            "https://icon-library.com/images/pokeball-icon-transparent/pokeball-icon-transparent-26.jpg",
                            height: 136,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Text(
                          "${pokemon["name"].toString()[0].toUpperCase()}${pokemon["name"].toString().substring(1, pokemon["name"].toString().length)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                blurRadius: 1,
                                color: Colors.redAccent,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Image.network(
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon["id"]}.png",
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null ? child : const Center(child: CircularProgressIndicator(color: Colors.white));
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: CircularProgressIndicator(color: Colors.white));
                          },
                          height: 96,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
    );
  }
}
