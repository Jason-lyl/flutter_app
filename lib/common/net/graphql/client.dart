/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/graphql/client.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net/graphql
 * Created Date: Tuesday, September 8th 2020, 10:57:43 am
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:flutter_app/common/net/graphql/repositories.dart';
import 'package:flutter_app/common/net/graphql/users.dart';
import 'package:graphql/client.dart';

GraphQLClient _client(token) {
  final HttpLink _httpLink = HttpLink(
    uri: 'https://api.github.com/graphql',
  );

  final AuthLink _authLink = AuthLink(
    getToken: () => '$token',
  );

  final Link _link = _authLink.concat(_httpLink);

  return GraphQLClient(
      link: _link,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject));
}

GraphQLClient _innerClient;

initClient(token) {
  _innerClient ??= _client(token);
}

realeaseClient() {
  _innerClient = null;
}

Future<QueryResult> getRepository(String owner, String name) async {
  final QueryOptions _options = QueryOptions(
      document: readRepository,
      variables: <String, dynamic>{'owner': owner, 'name': name},
      fetchPolicy: FetchPolicy.noCache);
  return await _innerClient.query(_options);
}

Future<QueryResult> getTrendUser(String location, {String cursor}) async {
  var variables = cursor == null
      ? <String, dynamic>{
          'location': "location:${location} sort:followers",
        }
      : <String, dynamic>{
          'location': "location:${location} sort:followers",
          'after': cursor
        };

  final QueryOptions _options = QueryOptions(
    document: cursor == null ? readTrendUser : readTrendUserByCursor,
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
  return await _innerClient.query(_options);
}
