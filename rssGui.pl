:- consult(xml).
:- pce_autoload(finder, library(find_file)).
:- pce_global(@finder, new(finder)).

rssGui :-
  new(Frame, frame('RSS Reader')),
  new(RssFeeds, browser),
  send(Frame, append(RssFeeds)),
  send(new(NewsList, browser(news)), right, RssFeeds),
  send(RssFeeds, select_message, message(@prolog, newsDisplay, RssFeeds, NewsList)),
  send(new(Buttons, dialog), below(RssFeeds)),
  send(Buttons, append(button(load, message(@prolog, load, RssFeeds)))),
  send(Frame, open).

newsDisplay(RssFeeds, NewsList) :-
  get(RssFeeds, selection, Channel),
  get(Channel, object, News), 
  get(News, size, SizeVal),
  send(NewsList, clear),
  foreach(between(1, SizeVal, LineNumber), sendVector(NewsList, News, LineNumber)).

sendVector(Browser, Vector, Index) :-
  get(Vector, element, Index, Value),
  send(Browser, append, Value).

load(Browser) :-
  get(@finder, file, exists := @on, FileName),
  readConfig(FileName, URLs),
  send(Browser, clear),
  foreach(member(URL, URLs), readAndListChannels(Browser, URL)).

readAndListChannels(Browser, URL) :-
  catch((rssFetch(URL, XML),
        rssRead(XML, RSS),
        foreach(member(channel(Name, News), RSS), send(Browser, append, create(dict_item, Name, Name, News)))), _, readAndListChannels(Browser, URL)).


