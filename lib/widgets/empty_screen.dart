import 'package:flutter/material.dart';


class EmptyScreen extends StatelessWidget {
  final String title;
  final Widget icon;

  const EmptyScreen({ Key? key, required this.title, required this.icon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
          opacity: 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(
                  width: 160,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}