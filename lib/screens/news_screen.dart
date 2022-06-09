import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String document = r''' 
  query GetNews {
    news (order_by : {h_id:asc}) {
      title
      url
      author
      h_id
      publishedAt
      source
      content
      urlToImage
      description
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.indigo[600],
        title: const Text('News List'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(document),
          // pollInterval: const Duration(seconds: 10),
        ),
        builder: ((result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List? newsList = result.data?['news'];
          if (newsList == null) {
            return const Center(
              child: Text('NO NEWS IS THERE'),
            );
          }
          print(result);
          print(newsList);
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(-2.0, 4.0))
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                      newsList[index]['urlToImage']),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    newsList[index]['title'],
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    newsList[index]['description'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    newsList[index]['author'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    newsList[index]['content'],
                                    style: TextStyle(color: Colors.grey[500]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Date : ${newsList[index]['publishedAt'].split('T')[0]}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Sources : ${newsList[index]['source']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
