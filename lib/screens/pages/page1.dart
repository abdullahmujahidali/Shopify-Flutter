import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  final data;
  const Page1({this.data});

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
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 400,
                          child: Center(
                            child: Stack(
                              children: <Widget>[
                                Transform.rotate(
                                  angle: 0.5,
                                  alignment: Alignment.topCenter,
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
                                            'assets/images/leaves.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 0.2,
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
                                            'assets/images/leaves.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 0.5,
                                  alignment: Alignment.bottomCenter,
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
                                            'assets/images/leaves.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            data['title'] ?? 'This is title',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(data['content'] ?? 'This is content')
                      ],
                    ),
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
