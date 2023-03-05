import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:provider/provider.dart';

import '../../../../models/app_model.dart';

class OrderListLoadingItem extends StatelessWidget {
  const OrderListLoadingItem();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isDarkTheme = Provider.of<AppModel>(context, listen: false).darkTheme;
    return Container(
      width: size.width,
      height: 200,
      margin: const EdgeInsets.only(
          bottom: 10.0, left: 10.0, right: 10.0, top: 5.0),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: isDarkTheme ? Colors.black87 : Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Skeleton(
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton(
                          height: 25.0,
                          width: Random().nextInt(150) + 100.0,
                        ),
                        const SizedBox(height: 5),
                        Skeleton(
                          height: 14.0,
                          width: Random().nextInt(100) + 50.0,
                        ),
                        const Expanded(
                          child: SizedBox(
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: Random().nextInt(4) + 4,
                              child: const Skeleton(
                                height: 14.0,
                                width: double.infinity,
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                width: 1,
                              ),
                            ),
                            const Flexible(
                              flex: 4,
                              child: Skeleton(
                                height: 14.0,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: isDarkTheme ? Colors.black26 : Colors.grey.shade300,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 18.0,
                          width: 70.0,
                        ),
                        SizedBox(height: 10),
                        Skeleton(
                          height: 14.0,
                          width: 20.0,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 18.0,
                          width: 70.0,
                        ),
                        SizedBox(height: 10),
                        Skeleton(
                          height: 14.0,
                          width: 20.0,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 18.0,
                          width: 70.0,
                        ),
                        SizedBox(height: 10),
                        Skeleton(
                          height: 14.0,
                          width: 20.0,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Skeleton(
                          height: 18.0,
                          width: 70.0,
                        ),
                        SizedBox(height: 10),
                        Skeleton(
                          height: 14.0,
                          width: 20.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
