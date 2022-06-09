import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:news_app/screens/news_screen.dart';

late ValueNotifier<GraphQLClient> client;
void main() async {
  final HttpLink httpLink =
      HttpLink('https://darling-alpaca-73.hasura.app/v1/graphql');
  AuthLink authLink = AuthLink(
      headerKey: 'x-hasura-admin-secret',
      getToken: () =>
          'bfQdbqZN8asJE3jqwybcv1K8LWctCoqYaO46BiWuqw0IsUGx0R6qdBk4iA8rvo9c');
  Link link = authLink.concat(httpLink);
  client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App using GraphQL',
        home: NewsScreen(),
      ),
    );
  }
}

