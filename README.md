# Chirp iOS App

Chirp is a basic twitter client app that can be used to read and compose tweets, using the [Twitter API](https://apps.twitter.com/).

Time spent: 28 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] The current signed in user will be persisted across restarts
- [x] User can view last 20 tweets from their home timeline
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh.
- [x] User should display the relative timestamp for each tweet "8m", "7h"
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap the profile image in any tweet to see another user's profile
   - [x] Contains the user header view: picture and tagline
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
   - [x] Profile view should include that user's timeline
- [x] User can navigate to view their own profile
   - [x] Contains the user header view: picture and tagline
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers

The following **optional** features are implemented:

- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet
- [x] Links in tweets are clickable
- [x] User can switch between timeline, mentions, or profile view through a tab bar
- [ ] Pulling down the profile page should blur and resize the header image.

The following **additional** features are implemented:

- [x] Mentions tab shows all tweets that the username has been tagged in
- [x] Refresh control is an animated Twitter icon
- [x] User can unfavorite, which decrements the favorite count

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/xMJOkEj.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/eh2irA8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/fXAXPRz.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/z2oVMpi.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/bkHYiMv.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/AQVSz0f.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/uOieHk0.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

Working around API rate limits; learning how to work with the API requests (such as for retweeting) and completion blocks; implementing unretweeting.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [BDBOAuth1Manager](https://github.com/TTTAttributedLabel/TTTAttributedLabel)
- [TTTAttributedLabel](https://github.com/bdbergeron/BDBOAuth1Manager)

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
