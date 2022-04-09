import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    onGenerateRoute: route.generateRoute,
  ));
}

class route {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // jika ingin mengirim argument
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/listloop':
        return MaterialPageRoute(builder: (_) => jsonList());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text('Error page')),
      );
    });
  }
}

class HomePage extends StatelessWidget {
  String button1 = "Lihat JsonList";
  String button2 = "Error Page";

  @override
  Widget build(BuildContext context) {
    void button1press() {
      Navigator.pushNamed(context, '/listloop');
    }

    void button2press() {
      Navigator.pushNamed(context, '/halaman-404');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Belajar Routing | Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: button1press,
                child: Text(button1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: button2press,
                child: Text(button2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class jsonList extends StatelessWidget {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";
  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Belajar GET HTTP'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text((snapshot.data[index]['id'].toString())),
                      ),
                      title: Text(snapshot.data[index]['title'] +
                          " (" +
                          snapshot.data[index]['userId'].toString() +
                          ")"),
                      subtitle: Text(snapshot.data[index]['body']),
                    );
                  });
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
