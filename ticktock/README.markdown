# About Ticktock, and this code #

In winter 2009 I had the crazy idea of developing my own product, a time-tracking/diary application where entries could be written in a short, Twitter-like message syntax. The craziest part is that while the UI never quite came together (despite being redesigned from scratch twice), I actually got the core diary feature working quite well.

The message parser, which is included here, was originally written in Ruby as a series of `String#scan` and `String#sub!` calls. This was more than adequate and had the benefit of being easy to read and modify.

Being a (now reformed) premature optimizer, and interested in how the big guys write parsers, I decided later on to rewrite the message parser in Ragel. The Ragel-based parser doesn't support every syntax variant the Ruby one does. For example, the Ruby parser allowed multi-word tags enclosed in double quotes, e.g. `#"my tag"` as well as normal hashtags (`#my_tag`), but the Ragel parser only supports the latter. This was partly a product decision, as it didn't seem necessary to support alternate formats for every token a message could contain, and having proven out the multi-word tag or subject format I could add it back in if my future/hypothetical users ever requested them.

Ticktock's been dormant long enough, and it's not doing me much good as a private project, so I've just made the source code for the whole app public:

    https://github.com/ddemaree/ticktock
    
Included here are the sources for the message and time-format parsers, as well as both the original Shoulda/Test-Unit test coverage and a brand-new test covering all the syntax examples listed below.


## Guide to Ticktock message syntax ##

Each of the following kinds of keys can be combined in any order when entering messages into the log. However, the conventional format (and the one Ticktock will give you for editing your entries) looks like this:

    (DATE) (DURATION) (@SUBJECT|[SUBJECT]) Message body with #tags #inline

### Dates ###

Dates can be written in the following ways:

* **MM/DD/YYYY** format: `03/09/2009 Cleaned the gutters`

* **YYYY-MM-DD** (aka 'database style') format: `2009-04-15 Cleaned the gutters again`

### Durations ###

Can be written in any of the following ways:

* **Hours and minutes** separated by a colon:

        0:45 Cardio workout

* **Hours, minutes and seconds** separated by a colon:

        8:23:42 Watched Lost marathon

* **Hours, minutes and/or seconds** in shorthand format:

        1h 14m Replenished bodily fluids


### Subjects (Projects) ###

Each message can have one subject, which is a `Project` in the Ticktock web application and returned from the message parser as the `:subject` attribute.

Projects/subjects are referred to by a proper name or nickname/username, and can be specified using Twitter-style `@name` syntax. Subject names must consist only of letters, numbers or underscores:

        @yoga Finally got into full wheel pose! #mybackhurts

### Tags ###

Tags can be included anywhere in the message body, and unlike other parameters will be preserved in place no matter where you put them. (That's to say: when you edit a message Ticktock will move other attributes to their conventional spots at the start of the message text, but tags will stay put.)

Tags are always specified in a Twitter-like hashtag format, and must consist of letters, numbers or underscores:

        Brunch with #Lauren