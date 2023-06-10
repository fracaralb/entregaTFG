import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/services/match_service.dart';
import 'package:tfg_app/widgets/widgets.dart';

class SearchDateDelegate extends SearchDelegate {
  SearchDateDelegate() : super(searchFieldLabel: 'yyyy-mm-dd');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, ''), icon: Icon(Icons.chevron_left));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = Provider.of<MatchService>(context).findByName(query);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) =>
              MatchCard(match: results[index])),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = Provider.of<MatchService>(context).findByDate(query);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) =>
              MatchCard(match: results[index])),
    );
  }
}
