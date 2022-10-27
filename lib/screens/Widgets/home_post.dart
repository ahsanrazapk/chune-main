import 'package:flutter/material.dart';
import 'package:newapp/screens/Widgets/FollowCard.dart';

import '../../models/chune.dart';


class HomePostCard extends StatelessWidget {
  final Chune post;

  final VoidCallback likePost;

  final VoidCallback listenPost;

  const HomePostCard(this.post, {Key key, this.likePost, this.listenPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              AvatarImage(post.userImage, 17),
              SizedBox(
                width: 10,
              ), //Profile Image
              Text(
                post.username,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ), //Username
              SizedBox(
                height: 50,
              )
            ],
          ),
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                post.albumArt,
                // ignore: missing_return
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Text('Your error widget...');
                },
                //post.albumArt,
                height: 370,
                width: 370,
              ),
            ),
            onDoubleTap: likePost,
            onTap: listenPost,
          ), //Album art
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.songName,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ), //Song Name/Artist

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${post.likeCount}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? Colors.red : Colors.black),
                      onPressed: likePost,
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                post.artistName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ), //Song Name/Artist
            ],
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}