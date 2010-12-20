### [Bjørn](https://github.com/ddemaree/37s_samples/tree/master/bjorn) ###

Bjørn is a &#8220;routing DSL for JavaScript&#8221; I wrote last year to prove out an idea for using the browser&#8217;s location hash to pass parameters to JS actions, mapping URI-like hashes to Sinatra-like block handlers. The DSL syntax is similar to the Rails <code>routes.rb</code> file, including the ability to define several routes using nested blocks. The implementation is basically a port of Sinatra&#8217;s URI router to JavaScript. While routing requests is the original intended use, you could also use Bjørn to invoke any kind of custom event, which could be useful in situations where you&#8217;re using the library without another, bigger framework like jQuery or Prototype.

As I&#8217;ve yet to release an app that uses Bjørn it&#8217;s fair to say it&#8217;s a solution in search of a problem. But the library is a pretty clear expression of how I&#8217;d organize lightweight controller actions in an MVC-style JavaScript app.

The latest Bjørn source is included in the sample code repo listed above, and you can also view the official GitHub project at <http://github.com/ddemaree/bjorn>.


### [Ticktock](https://github.com/ddemaree/37s_samples/tree/master/ticktock-parser) ###

In 2009 I had the crazy idea of developing my own product, a time tracking/diary application where entries could be written in a short, Twitter-like message syntax. While I never settled on a UI I really liked, and the overall project was too ambitious for one person to finish in any kind of short timeframe, I got the core diary feature working quite well.

The message parser, which is included in the sample code as `ticktock-parser`, was originally written in Ruby. This more than did the job, and had the benefit of being easy to read and modify. But then I did some reading about how real computer scientists write parsers, and (for fun) decided to rewrite the message parser in Ragel, with Ruby as a compile target. The Ragel parser is somewhat faster then the Ruby one, and works equally well. I've included both parsers in my sample project, including both the original Ragel source code and the functional Ruby output. I've also included the original Shoulda tests I wrote during development as well as a new test covering my README examples.

Ticktock's been dormant long enough, and it's not doing me much good as a private project, so I've just [open sourced the project](http://github.com/ddemaree/ticktock).


### [ManageMyCommunity design patterns](https://github.com/ddemaree/37s_samples/tree/master/managemycommunity) ###

My final code samples are some ActiveRecord models from ManageMyCommunity, a large intranet system I worked on for a real estate company.

These classes demonstrate two patterns I'm pretty fond of:

* The 'concern' format for model mixins (that has since been codified in Rails as `ActiveSupport::Concern`). I use this pattern both for sharing behavior across classes, and for breaking up large, complicated models (such as User) into smaller chunks, grouping like methods together into concerns.

* What I call the 'sidecar' pattern, where each record of a given class (e.g. User or Group) is paired with a more general kind of object (Party) that contains common metadata and can be used as a general association or join target. Each party model mixes in the PartyBehaviors module that sets up the callbacks for creating/updating/deleting party records and defines some common behaviors expected of a Party in this system.

Unfortunately a lot of this system pre-dates my embracing of test-driven development, so there are no tests. If I were to do this all over again today, there'd be a robust set of unit tests, with shared examples or lint tests covering the shared modules.