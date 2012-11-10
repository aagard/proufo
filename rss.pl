:- consult(library(sgml)).
:- consult(library(http/http_open)).

% Read Config
readConfig(FileName, Lines) :-
  open(FileName, read, ConfigStream),
  read_stream(ConfigStream, Lines).

read_stream(ReadStream, Lines) :-
  read_line_to_codes(ReadStream, Line),
  read_stream(ReadStream, Line, Lines).
read_stream(ReadStream, end_of_file, []) :- close(ReadStream), !.
read_stream(ReadStream, OldLine, [Atom | Lines]) :-
  read_line_to_codes(ReadStream, NewLine),
  string_to_atom(OldLine, Atom),
  read_stream(ReadStream, NewLine, Lines).

% Fetch Rsses
rssFetch(URL, XML) :-
  http_open(URL, XmlStream, []),
  load_xml_file(XmlStream, XML),
  close(XmlStream).

% Parse the RSS
rssRead([], []).
rssRead([element(channel, _, Elements) | _], [Rss | Rsses]) :-
  channelRead(Elements, Rss), rssRead(Elements, Rsses).
rssRead([element(rss, _, Elements) | _], Rss) :-
  rssRead(Elements, Rss).
rssRead([_ | Elements], Rss) :-
  rssRead(Elements, Rss).

channelRead(Elements, channel(Name, Titles)) :-
  titleRead(Elements, Name), itemsRead(Elements, Titles).

itemsRead([], []).
itemsRead([element(item, _, Elements) | Items], [ Title | Titles ]) :-
  titleRead(Elements, Title), itemsRead(Items, Titles).
itemsRead([_ | Items], Titles) :-
  itemsRead(Items, Titles).

titleRead([element(title, _, [Text | _]) | _], Text) :- !.
titleRead([_ | Elements], Text) :-
  titleRead(Elements, Text).

% Text Display
displayRss(Channels) :-
  foreach(member(channel(Name, Titles), Channels),
      (writef("*** %w ***\n", [Name]), displayTitles(Titles), nl)).

displayTitles(Titles) :-
  foreach(member(Title, Titles), writef("\t%w\n", [Title])).

% main
readAndDisplayRss(URL) :-
  catch((rssFetch(URL, XML), 
        rssRead(XML, RSS), 
        displayRss(RSS)), _, readAndDisplayRss(URL)).

main :-
  readConfig('feeds.txt', FeedURLs),
  foreach(member(URL, FeedURLs), readAndDisplayRss(URL)),
  halt.
