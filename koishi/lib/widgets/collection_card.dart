import 'package:flutter/material.dart';
import 'package:koishi/models/collection.dart';

class CollectionCard extends StatefulWidget {
  final Collection collection;
  final bool isFirst;

  const CollectionCard({
    Key? key,
    required this.collection,
    required this.isFirst,
  }) : super(key: key);

  @override
  _CollectionCardState createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            bottom: 15, left: 15, right: 15, top: (widget.isFirst) ? 15 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 57,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF5C014),
                    Color(0xFFC34B74),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.collection.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
