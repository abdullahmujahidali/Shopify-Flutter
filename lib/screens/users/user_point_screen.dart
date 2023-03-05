import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show UserModel, UserPoints;
import '../../services/index.dart' show ServerConfig;

class UserPointScreen extends StatefulWidget {
  @override
  State<UserPointScreen> createState() => _StateUserPoint();
}

class _StateUserPoint extends State<UserPointScreen> {
  final dateWidth = 100;
  final pointWidth = 50;
  final borderWidth = 0.5;

  Future<UserPoints> getUserPoint() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final points = await httpGet(
        '${ServerConfig().url}/wp-json/api/flutter_user/get_points/?insecure=cool&user_id=${userModel.user!.id}'
            .toUri()!);
    return UserPoints.fromJson(json.decode(points.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(
            S.of(context).myPoints,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        body: FutureBuilder<UserPoints>(
          future: getUserPoint(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Align(
                alignment: Alignment.center,
                child: kLoadingWidget(context),
              );
            }
            if (!snapshot.hasData) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      trailing: Text(
                        snapshot.data!.points.toString(),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                              fontSize: 35,
                            ),
                      ),
                      title: Text(
                        S.of(context).myPoints,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(indent: 15.0, endIndent: 15.0),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        S.of(context).events,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        for (var event in snapshot.data!.events)
                          ListTile(
                            trailing: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                event.points!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            title: Text(event.description!),
                            subtitle: Text(
                              event.date!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.6),
                              ),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
