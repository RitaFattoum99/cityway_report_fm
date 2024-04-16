import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final Function(int) onRatingChanged;
  final int initialRating;

  // ignore: use_key_in_widget_constructors
  const StarRating({required this.onRatingChanged, this.initialRating = 0});

  @override
  // ignore: library_private_types_in_public_api
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              rating = index + 1;
              widget.onRatingChanged(rating);
            });
          },
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30.0,
          ),
        );
      }),
    );
  }
}
