Resty Blog in weblocks
======================

Expand the simple-blog example that comes with
weblocks to support a more buzzword-compliant blog interface,
especially with regards to URLs.

# Current todo list/plans
1. change damn name to resty-blog or resty-weblogks
2. make a nicer post widget which is the default at /
3. make the menu automagically attach to each page? (use tables for sanity?)
4. make a post-comment class (aka replies) and implement what Trastabuga's been talking about on-list.
5. make renderers for comments (must use a threaded view) and a dialog that lets a user add a comment.


# History

This example started out as an official weblocks example by Evan
Monroig and Benjamin Collins, but based on some questions by
Trastabuga, is being expanded to be less alien-oriented.  By which we
mean that instead of using a single-window AJAXy model of interaction,
we'll have a blog that corresponds to the standard RESTy notions of
how a blog should behave with respect to URIs, navigation etc. We're
shooting for the equivalent of blogspot.com (heh, someday!).

# Goals

1. Demonstrate the major features of weblocks in a use-case driven, conversational manner (by discussing next steps on the NG)

2. Demonstrate how to accomplish "normal" things with weblocks, such as URLs, JS-integration, using external toolkits, sending mail etc.

# Current UI / widget-tree decisions

We have two choices:

* Original plan: top level dispatcher that embeds a menu/archive
subwidget and also draws the UI for the post.
* Suggested by Polzer: top level widget does not consume any
tokens.. [still figuring out how this works] [ng-tok]

[ng-tok]: http://groups.google.com/group/weblocks/msg/8d53486c83df7def

## URLs map to specific UIs as follows:

* /admin/user --> Admin interface where new posts can be created, old ones edited and deleted. (password guarded)
* /admin/user/sudo --> Admin interface where above is possible for all users and authors. (password guarded)

* /tag/foo/bar/baz --> Show posts with foo, bar, baz tags

* /author/douglas+adams/ 
* /author/douglas/adams/ 
* /author/adams/adams/ 
* /author/douglas_adams/ --> Show posts by author Douglas Adams 

* /2010/01/02 
* /2010/Dec/02 
* /2010/Dic/02 
* /2010/Dicembre/02 
* /2010/December/02 --> All posts on 2nd of December 2010

# Authors

In chronological order:

* Evan Monroig  <evan.monroig@gmail.com>
* Benjamin Collins <aggieben@gmail.com>
* Nandan Bagchee <nandan.bagchee@gmail.com>


