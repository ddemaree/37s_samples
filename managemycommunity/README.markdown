# ManageMyCommunity Patterns #

This code is (unfortunately) not functional outside of its original Rails app, and (even more unfortunately) doesn't have any unit tests. I didn't begin to take testing seriously until about 2 years ago, when this app had already been in production for a while and my client's budget didn't allow me time to go back and build up a regression test suite from scratch.

It's included here to demonstrate two Ruby/Rails patterns I really like and have used a few times:

* A "sidecar" or "skyhook" pattern for polymorphism. ActiveRecord objects of any particular type are joined with another row/object of a more generic type, which can serve as a generic target for ownership, authorship and other common associations, as well as provide a single data source for searching and querying where you'd otherwise need to use an actual search engine (which would have been a good fit for this project, but not possible given the client's budget) or query multiple tables and somehow merge the results.

    In these files, the `User` and `Group` models are both considered "parties", and therefore both can have various kinds of content associated with them. Each party's record is polymorphically associated with a `Party` row/object, which provides common querying and searching, and could conceivably also be an association target.

* The "concern" pattern where various related behaviors are grouped together into modules, which use the `Module.included` method to run certain macros (to create associations or set up other behaviors) at include time.

    Before the party model was adopted on this project, many associations and methods common to both `User` and `Group` had been refactored into the `MMC::ParentModel` and `MMC::PartyBehaviors` modules that get mixed into both `User` and `Group`.