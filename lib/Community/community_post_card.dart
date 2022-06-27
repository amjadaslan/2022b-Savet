import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/post_comment_section.dart';
import 'package:savet/main.dart';

import '../Posts/Post/post_comment_section.dart';
import '../Services/user_db.dart';

class community_post extends StatefulWidget {
  const community_post(
      {Key? key, required this.post, required this.user, required this.token})
      : super(key: key);
  final Map post;
  final Map user;
  final String token;
  @override
  _community_postState createState() => _community_postState();
}

class _community_postState extends State<community_post> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    bool isHappy = false, isLoved = false;
    var postsIliked = Provider.of<UserDB>(context, listen: false).postsIliked;
    var postsIloved = Provider.of<UserDB>(context, listen: false).postsIloved;
    for (var e in postsIliked) {
      if (e == widget.post['id']) {
        isHappy = true;
        break;
      }
    }

    for (var e in postsIloved) {
      if (e == widget.post['id']) {
        isLoved = true;
        break;
      }
    }
    Future<bool> onLikeButtonTapped(bool x) async {
      print("performing like");

      /// send your request here
      if (!isHappy) {
        await Provider.of<UserDB>(context, listen: false).addLike(
            Provider.of<UserDB>(context, listen: false).user_email,
            (widget.user != null)
                ? (widget.user['email'])
                : Provider.of<UserDB>(context, listen: false).user_email,
            widget.post['id'],
            widget.post['cat_id']);
        Provider.of<UserDB>(context, listen: false).addNotification(
            (widget.user != null)
                ? (widget.user['email'])
                : Provider.of<UserDB>(context, listen: false).user_email,
            ' reacted to your post.');
        sendPushMessage(
            widget.token,
            '',
            '${Provider.of<UserDB>(context, listen: false).username}'
                ' reacted to your post.');
        widget.user['categories']
            .singleWhere(
                (element) => element['id'] == widget.post['cat_id'])['posts']
            .singleWhere((post) => post['id'] == widget.post['id'])['likes']++;
      } else {
        await Provider.of<UserDB>(context, listen: false).removeLike(
            Provider.of<UserDB>(context, listen: false).user_email,
            (widget.user != null)
                ? (widget.user['email'])
                : Provider.of<UserDB>(context, listen: false).user_email,
            widget.post['id'],
            widget.post['cat_id']);
        widget.user['categories']
            .singleWhere(
                (element) => element['id'] == widget.post['cat_id'])['posts']
            .singleWhere((post) => post['id'] == widget.post['id'])['likes']--;
      }
      isHappy = !isHappy;
      setState(() {});
      return isHappy;
    }

    Future<bool> onLoveButtonTapped(bool x) async {
      /// send your request here
      if (!isLoved) {
        await Provider.of<UserDB>(context, listen: false).addLove(
            Provider.of<UserDB>(context, listen: false).user_email,
            (widget.user != null)
                ? (widget.user['email'])
                : Provider.of<UserDB>(context, listen: false).user_email,
            widget.post['id'],
            widget.post['cat_id']);
        sendPushMessage(
            widget.token,
            '',
            '${Provider.of<UserDB>(context, listen: false).username}'
                ' reacted to your post.');
        Provider.of<UserDB>(context, listen: false).addNotification(
            (widget.user != null)
                ? (widget.user['email'])
                : Provider.of<UserDB>(context, listen: false).user_email,
            ' reacted to your post.');
        widget.user['categories']
            .singleWhere(
                (element) => element['id'] == widget.post['cat_id'])['posts']
            .singleWhere((post) => post['id'] == widget.post['id'])['loves']++;
      } else {
        await Provider.of<UserDB>(context, listen: false).removeLove(
            Provider.of<UserDB>(context, listen: false).user_email,
            (widget.user != null)
                ? (widget.user['email'])
                : Provider.of<UserDB>(context, listen: false).user_email,
            widget.post['id'],
            widget.post['cat_id']);
        widget.user['categories']
            .singleWhere(
                (element) => element['id'] == widget.post['cat_id'])['posts']
            .singleWhere((post) => post['id'] == widget.post['id'])['loves']--;
      }

      isLoved = !isLoved;
      setState(() {});
      return isLoved;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              flex: 10,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (Colors.black12),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    //color: Colors.white,
                    child: Column(
                      children: [
                        Image(
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                            image: CachedNetworkImageProvider(
                                widget.post['image'])),
                        Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.favorite,
                                            color: Colors.red, size: 14),
                                        SizedBox(width: 2),
                                        Text(
                                          "${widget.post['likes'] + widget.post['loves']} Likes",
                                          style: TextStyle(
                                              fontFamily: 'arial',
                                              decoration: TextDecoration.none,
                                              color: Colors.grey[700],
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    AutoSizeText(
                                      "${widget.post['username']}",
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          decoration: TextDecoration.none,
                                          color: Colors.black87,
                                          fontSize: 15),
                                    ),
                                    SizedBox(height: 5),
                                    AutoSizeText(
                                      "${widget.post['title']}",
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          decoration: TextDecoration.none,
                                          color: Colors.black54,
                                          fontSize: 11),
                                    ),
                                    SizedBox(height: 5),
                                    AutoSizeText(
                                      "${widget.post['description']}",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          decoration: TextDecoration.none,
                                          color: Colors.black54,
                                          fontSize: 11),
                                    ),
                                    SizedBox(height: 8)
                                  ],
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: Row(children: [
                                    IconButton(
                                        iconSize: 40,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      post_comment_section(
                                                        post_id:
                                                            widget.post['id'],
                                                        cat_id: widget
                                                            .post['cat_id'],
                                                        user: widget.user,
                                                      )));
                                        },
                                        icon: Icon(Icons.mode_comment_outlined,
                                            color: Colors.grey[400])),
                                    LikeButton(
                                      size: 50,
                                      circleColor: const CircleColor(
                                          start: Colors.deepOrange,
                                          end: Colors.deepOrange),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Colors.deepOrange,
                                        dotSecondaryColor: Colors.deepOrange,
                                      ),
                                      likeBuilder: (isLiked) {
                                        return Icon(
                                          Icons.favorite,
                                          color: (isLoved)
                                              ? Colors.deepOrange
                                              : Colors.grey,
                                          size: 40,
                                        );
                                      },
                                      //likeCount: widget.post['loves'],
                                      onTap: onLoveButtonTapped,
                                    ),
                                    LikeButton(
                                      size: 50,
                                      circleColor: const CircleColor(
                                          start: Colors.deepOrange,
                                          end: Colors.deepOrange),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Colors.deepOrange,
                                        dotSecondaryColor: Colors.deepOrange,
                                      ),
                                      likeBuilder: (isLiked) {
                                        return Icon(
                                          Icons.insert_emoticon_sharp,
                                          color: (isHappy)
                                              ? Colors.deepOrange
                                              : Colors.grey,
                                          size: 40,
                                        );
                                      },
                                      //likeCount: widget.post['likes'],
                                      onTap: onLikeButtonTapped,
                                      // countBuilder: () {}
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
