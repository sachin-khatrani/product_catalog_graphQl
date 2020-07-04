import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Declaring Auth Variables
  AuthLink authLink;
  HttpLink httpLink;
  // Declaring GraphQLClient for connection
  ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();
    // Setting up network with GraphQL Server
    authLink = AuthLink(
        getToken: () async =>
        'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik0wTTNOVVV3UmpVNU0wSkZRalpDUkRsQ05URTNOVFk1T0RnME5EaEJNVGRDTUVORU1EQkNOZyJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1hbGxvd2VkLXJvbGVzIjpbInVzZXIiXSwieC1oYXN1cmEtdXNlci1pZCI6ImF1dGgwfDVlZmI3MGIzMzUyZDhmMDAxM2M2Y2FlMiJ9LCJuaWNrbmFtZSI6InNhY2hpbmtoYXRyYW5pMTAiLCJuYW1lIjoic2FjaGlua2hhdHJhbmkxMEBnbWFpbC5jb20iLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvYWQ5NzdjODliYWQ3M2QxYmMyMWQwNjc5ZTc3ZTcxMDQ_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZzYS5wbmciLCJ1cGRhdGVkX2F0IjoiMjAyMC0wNi0zMFQxNzowNDo1My4wMTJaIiwiaXNzIjoiaHR0cHM6Ly9nZW5lc2lzcG9ydGFsLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1ZWZiNzBiMzM1MmQ4ZjAwMTNjNmNhZTIiLCJhdWQiOiJBS2wwNnc1REpPeWtpZ1dmSVZnUkt0TjQ1Zzc0MjMxQyIsImlhdCI6MTU5MzUzNjY5MywiZXhwIjoxMTE5MzUzNjY5MSwiYXRfaGFzaCI6IklqV0pCZElmZGl6LW5rdkY4WDNmMnciLCJub25jZSI6IjNEWndzRTBkYjR2WENmM2kyNGlQNzdTS3F-RHp2Y29vIn0.Aqf7X9Fp71PCfNd3vy6EKLmoj9gLAgO3yi_tpyXSA_pT-3uTJh1EQ1582PPUJtgxJvFl0Y1354ZEY6J0x2LRs-joHXv-itxU9bL6CegwZyrZ9uZ_cWn5zt2j2Wb8F4TtJ-Qyhb1muJeNB-uBS3GuAZL6wBZuW8fOZQG4xJOi2MzFqw9JXxArrIFzRxkLtVhjsjKC5MbxuTwOOuaPAtWj2P0HHLIbalqZdyXR6mfRsbDQuMJFyw_ia3fR9tL5Nfj2vqVK-5_I8qqYZ2jG_lACzoEXeSdYqci42AefICb1bVDt2V5VFX_tQ6pq6WpA5KB6whdxtH7_-tQs_WztDlQoBg');
    httpLink =
        HttpLink(uri: 'https://definite-rabbit-51.hasura.app/v1/graphql');
    Link link = authLink.concat(httpLink);
    client = ValueNotifier(GraphQLClient(link: link, cache: InMemoryCache()));
  }

  @override
  Widget build(BuildContext context) {
    // GraphQLProvider provides access to client instance down the widget tree
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Flutter & GraphQL Demo App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
           // visualDensity: VisualDensity.minimumDensity,
          ),
          home: MyHomePage(title: 'Product Catalog'),

        ),
      ),
    );
  }
}