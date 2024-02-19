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
  final ScrollController _scrollController = ScrollController();
  String prevSearch = "";
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

  void _searchHandler(String value) {
    setState(() {
      setState(() {
        prevSearch = value;
      });
    });
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
          title: const Text(
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
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(
                    pokemonList: pokemonList,
                    prevSearchValue: prevSearch,
                    searchHandler: _searchHandler,
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
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
                duration: const Duration(seconds: 1),
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
                  return name.contains(prevSearch.toLowerCase()) ? true : false;
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
                            "${pokemon["name"][0].toUpperCase()}${pokemon["name"].substring(1, pokemon["name"].length)}",
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
            : const Center(child: CircularProgressIndicator(color: Colors.red)));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({required this.pokemonList, required this.prevSearchValue, required this.searchHandler});

  final List<dynamic> pokemonList;
  void Function(String value) searchHandler;
  String prevSearchValue;

  @override
  set query(String value) {
    if (prevSearchValue.isNotEmpty) {
      super.query = prevSearchValue;
      prevSearchValue = "";
    } else {
      super.query = value;
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
          searchHandler("");
        },
      ),
    ];
  }

  @override
  void showResults(BuildContext context) {
    searchHandler(query);
    close(context, "");
    super.showResults(context);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: pokemonList
          .where((pokemon) => pokemon["name"].contains(query.toLowerCase()) ? true : false)
          .map(
            (pokemon) => ListTile(
              splashColor: Colors.red,
              title: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.redAccent[100],
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon["id"]}.png",
                    loadingBuilder: (context, child, loadingProgress) {
                      return loadingProgress == null ? child : const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.grey, strokeWidth: 2));
                    },
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Text("${pokemon["name"][0].toUpperCase()}${pokemon["name"].substring(1, pokemon["name"].length)}"),
              ]),
              onTap: () {
                searchHandler(pokemon["name"]);
                close(context, "");
              },
            ),
          )
          .toList(),
    );
  }
}
