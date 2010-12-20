# Hello. #

My name's David Demaree, and I'm a Ruby/iOS developer & designer. At present I'm the senior Rails developer for Metromix here in Chicago. But I'm looking for a new challenge, and so I'd like to come join your team at 37signals.

You may remember me from an e-mail I sent last weekend, applying for the UI designer/product manager position that's also being filled. That's a job I want. I think my approach to solving design problems and working closely with a pair of amazing Rails programmers to make something great will be a good complement to the existing 37signals team. And my background and skills -- art and design, but also web & mobile programming, with some product management mixed in -- are ones I think you'd find useful.

But be it as a designer or a programmer, I want to become part of the 37signals team. So I'm writing today to tell you a bit more about my programming background and (I hope) establish myself as a generalist who'd be a good fit in whatever capacity.

I believe that if you're going to do something it's important to try to do it well. During college I learned PHP & MySQL from an O'Reilly book because I wanted to automate some stuff on my website. Within a few months, just for fun, I'd written a simple RSS feed reader and started to learn about object-oriented programming and good coding practices. That's been my standard procedure whenever I have an unmet need or get curious about how something works: read, experiment, read some more, and repeat til it's mastered.

Rails found me about five years ago when a friend/co-worker saw me writing some PHP code on a break, happened to have heard about this great new Ruby-based web thing from his friend Sam Stephenson (I think you may know him ;), and suggested I try it out. I tried it out, I loved it, and I've worked almost exclusively in Ruby since 2006.

I don't remember what Rails version my first production app used, but based on the timing (launch was spring 2006) it was probably 1.0 or 1.1. It's still running, and still looks more or less the same as it did when I deployed it: <http://businesspov.com/>

At the first RailsConf in 2006, I gave a talk on "web 2.0" concepts in user experience. It wasn't _at all_ technical, except in the sense of trying to get people to move beyond "tags" and "feeds" in their domain models and frame features in a context their users will understand. Though I didn't know it at the time, my talk was about domain modeling.

Here are some comments about my session from folks who were there:

> &ldquo;Next up was David Demaree&rsquo;s session on how to introduce regular users to web 2.0 ideas like tags and rss. This was perfectly in line for me because it sounds like his work mirrors mine quite a bit. He did a good job explaining how to think when designing a site with more features and how a normal user parses it, and the methods you should go about introducing features.&rdquo;

> &ldquo;David Demaree was in the number two slot, delivering some key points on creating search-easy websites and apps and really making it obvious what you’re you&rsquo;re trying to offer. While not much of what he said was directly related to Rails (actually, none of it), the basic concept of making your work accessible and clear to your targeted audience is a good one.&rdquo;

During three years of freelance consulting I worked on about a dozen projects, most of them either internal tools that aren't publicly accessible, or sites that have since gone out of production. But a few are still up.

The most notable one was T-26 (<http://www.t26.com/>), the digital type store founded by 37signals co-founder Carlos Segura, which I ported from PHP to Rails 1.2 in winter 2007, and worked on until I quit full-time freelancing in spring 2009. Working on T-26 taught me a lot about architecting a large Rails system, and even now is probably my favorite app I've ever worked on.

My current project is Metromix.com, a network of local entertainment sites owned by Gannett and the Tribune Company. Metromix is divided into two platforms: "affiliate" (sites managed by producers in each city) and "express" (sites based on data from a third-party provider such as Localeze). Here are links to one of each:

**Affiliate:** <http://chicago.metromix.com>    
**Express:** <http://seattle.metromix.com>

Metromix is a fairly demanding system: 7 Rails projects (mostly 2.1.1, with some newer 2.3.4 ones, all using Bundler 1.0 since this summer), tied together by REST web services and some shared libraries/gems. At the view layer there's a mix of ERb and Haml. For Ajax and UI behavior we use both Prototype (on the older affiliate app) and jQuery (on the newer apps), along with some framework-agnostic JS code shared between projects.

I've been leading a push towards more modernization and standardization--toward one Rails version, one template engine, one way of doing ad calls--but our resources are constrained (this being the newspaper industry) and so it's been enough work just to keep the legacy stuff running.

MySQL is our main data storage tool, paired with memcached (for caching and sessions) and a multi-core Solr setup (for search, with each product having its own Solr core/index). We've also just started using CouchDB as a feed staging area; third-party data gets imported to Couch, normalized by a processing daemon, then output to MySQL for use by the public-facing apps. On the side I've also experimented with MongoDB and Redis.

In my spare time I'm working on an open-source voting & governance tool for the jQuery Core Team (<http://github.com/wycats/jquery-governance>), with Yehuda Katz and a great group of volunteers. The project is Rails 3 with all the usual trimmings: Devise, RSpec 2, Cucumber, Factory Girl, Haml & Sass, Resque. My contributions so far have been implementing the first version of the member management admin, setting up e-mail notifications to the membership whenever a motion is created or its state changed, and hanging out in the Campfire room and lending ActiveRecord help to some of the other members.

Finally, outside work, I'm an amateur photographer with an active Flickr stream (<http://flickr.com/demaree>) and an aspiring mixologist. (One of my OmniFocus items right now is "learn how to make bitters.") The stack of books on my desk includes a number of web & programming titles, like Stoyan Stefanov's _JavaScript Patterns_ and Khoi Vinh's new book about grid layouts. It also includes some books about business (_All The Devils Are Here_ is my idea of a trashy page-turner), history and philosophy. Every once in a while a novel makes it into the stack, but only when it really grabs me.

One more data point that you won't learn from my resumé, code or website: I'm slightly addicted to human input devices. This is a broad category that (for me) includes everything from pens to touchscreens, and I'm constantly trying new ones. Right now on my desk you'll find both a Magic Trackpad _and_ Magic Mouse (the former gets more use than the latter), as well as a Razer DeathAdder gaming mouse, the smaller, now-discontinued wired Apple Keyboard, a wide variety of pens (including the hugely disappointing Sharpie Liquid Pencil) and a leather folio holding a pad of thick, smooth yellow paper.

The job posting asked for some paragraphs about some code I was particularly proud of, so I created a GitHub project called `37s_samples`. Most of what I have to say about those examples is in the README, and you can drill down into the code to get a better sense of my style and (such as it is) expertise. The samples are in Ruby and JavaScript, and where possible I've included working tests.

<http://github.com/ddemaree/37s_samples>

Other than that, everything written on [the website I made for the UI designer position](http://does37signalsneedanotherdavid.us/) still stands. I love making software. I love helping my customers (and my customers' customers) get things done more easily. 37signals gets it more than almost any other company I can think of, and I would be honored to have the chance to talk with you about joining the team and building some great products together.

Best regards, and thanks,

**David Demaree**         
<ddemaree@gmail.com>    
312 268-2027

<http://does37signalsneedanotherdavid.us/>   