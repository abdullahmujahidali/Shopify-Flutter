import 'package:flutter/material.dart';

class SendEmailWidget extends StatelessWidget {
  const SendEmailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NEWS LETTER',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text('Subscribe to our news letter to get latest updates'),
        ),
        Container(
          padding: const EdgeInsets.all(2.0),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 40,
          child: Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Your Email Address',
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('Subscribe')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
