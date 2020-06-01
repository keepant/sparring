import 'package:firebase_auth/firebase_auth.dart';
import "package:graphql_flutter/graphql_flutter.dart";

class API {
  
  
  final HttpLink httpLink = HttpLink(
    uri: 'https://sparring-api.herokuapp.com/v1/graphql',
  );

  final WebSocketLink websocketLink = WebSocketLink(
    url: 'wss://https://sparring-api.herokuapp.com/v1/graphql',
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
    ),
  );

  // final AuthLink authLink = AuthLink(
  //   getToken: () async => 'Bearer ' + token,
  // );
}
