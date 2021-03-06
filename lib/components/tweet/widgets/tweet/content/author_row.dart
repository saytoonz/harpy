import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/cached_circle_avatar.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/utils/string_utils.dart';

/// Builds the tweet author's avatar, display name, username and the creation
/// date of the tweet.
class TweetAuthorRow extends StatelessWidget {
  const TweetAuthorRow(
    this.tweet, {
    this.avatarRadius,
    this.fontSizeDelta = 0,
    this.iconSize = 16,
  });

  final TweetData tweet;

  final double avatarRadius;

  final double fontSizeDelta;

  final double iconSize;

  void _onUserTap() {
    app<HarpyNavigator>().pushUserProfile(user: tweet.userData);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: _onUserTap,
          child: CachedCircleAvatar(
            imageUrl: tweet.userData.appropriateUserImageUrl,
            radius: avatarRadius,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _onUserTap,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        tweet.userData.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyText2.apply(
                          fontSizeDelta: fontSizeDelta,
                        ),
                      ),
                    ),
                    if (tweet.userData.verified)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified_user, size: iconSize),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _onUserTap,
                child: Text(
                  '@${tweet.userData.screenName} \u00b7 '
                  '${tweetTimeDifference(tweet.createdAt)}',
                  style: theme.textTheme.bodyText1.apply(
                    fontSizeDelta: fontSizeDelta,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
