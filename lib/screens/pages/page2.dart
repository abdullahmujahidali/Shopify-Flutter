import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  final data;

  const Page2({this.data});

  @override
  Widget build(BuildContext context) {
    List<String>? images = data['images'];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: <Widget>[
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image.asset(
                  'assets/images/leaves.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(-0.3, 1.0),
                ),
              ),
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6)),
              ),
              Transform.rotate(
                angle: 0.5,
                alignment: const Alignment(0.0, 0.0),
                child: Container(
                  width: 150,
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: (images != null && images.isNotEmpty)
                      ? Image.network(
                          images[0],
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/background/background-1.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Transform.rotate(
                angle: 1.0,
                alignment: const Alignment(-4.0, 5.0),
                child: Container(
                  width: 150,
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: (images != null && images.length > 1)
                      ? Image.network(
                          images[1],
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/background/background-1.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Transform.rotate(
                angle: -0.5,
                alignment: const Alignment(6.0, -3.0),
                child: Container(
                  width: 150,
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: (images != null && images.length > 2)
                      ? Image.network(
                          images[2],
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/background/background-1.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Transform.rotate(
                angle: 0.1,
                alignment: const Alignment(-50.0, 5.0),
                child: Container(
                  width: 150,
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: (images != null && images.length > 3)
                      ? Image.network(
                          images[3],
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/background/background-1.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: Colors.black38, width: 2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          data['title'] ?? 'This is title',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data['content'] ?? 'This is content',
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
