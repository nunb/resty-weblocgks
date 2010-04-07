Resty Blog in weblocks
----------------

resty-blog expands the resty-weblocgks example that comes with weblocks to support a more buzzword-compliant blog interface, especially with regards to URLs.

History
-------

This example started out as an official weblocks example by aggieben, but based on some questions by Trastabuga, is being expanded to be less alien-oriented.
By which we mean that instead of using a single-window AJAXy model of interaction, we'll have a blog that corresponds to the standard RESTy notions of how a blog
should behave with respect to URIs, navigation etc. We're shooting for the equivalent of blogspot.com (heh, someday!).

Goal
-----

Goals of this project:

1. Demonstrate the major features of weblocks in a use-case driven, conversational manner (by discussing next steps on the NG)
2. Demonstrate how to accomplish "normal" things with weblocks, such as URLs, JS-integration, using external toolkits, sending mail etc.

Current UI
-----------

URLs map to specific UIs

/admin/user --> Admin interface where new posts can be created, old ones edited and deleted. (password guarded)
/admin/user/sudo --> Admin interface where above is possible for all users and authors. (password guarded)

/tag/foo/bar/baz --> Show posts with foo, bar, baz tags

/author/douglas+adams/ 
/author/douglas/adams/ 
/author/adams/adams/ 
/author/douglas_adams/ --> Show posts by author Douglas Adams 

/2010/01/02 
/2010/Dec/02 
/2010/Dic/02 
/2010/Dicembre/02 
/2010/December/02 --> All posts on 2nd of December 2010

Authors
-------
Benjamin Collins <aggieben@gmail.com>
Nandan Bagchee <nandan.bagchee@gmail.com>


