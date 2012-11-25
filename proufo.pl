main :-	new(Frame, frame('Expertensystem Unternehmensform')),
		send(Frame, append, new(Dialog, dialog)),
		send(Dialog, size, size(500,200)),
		auswerten(start, _, _, Dialog, Frame),
		send(Frame, open).

/*frage(id, 'beschreibung', [ja, id, nein, id]).*/

frage(start, 'Sind Sie Freiberufler?', [ja, lonesome, nein, gemeinnuetzig]).
frage(lonesome, 'Moechten Sie allein arbeiten?', [ja, geld, nein, geldgemeinsam]).
frage(gemeinnuetzig, 'Sind Sie gemeinnuetzig?', [ja,  kapital, nein, kapitalungemein]).
frage(geld, 'Besitzen Sie mehr als 25.000 Euro?', []).
frage(geldgemeinsam, 'Besitzen Sie zusammen mehr als 25.000 Euro?', []).
frage(kapital, 'Besitzen Sie zusammen mehr als 25.000 Euro?', []).
frage(kapitalungemein, 'Besitzen Sie zusammen mehr als 25.000 Euro?', []).

auswerten(Id, Text, Antworten, Dialog, Frame):- frage(Id, Text, Antworten),
										 writeln('------\n auswerten'),
										 writeln(Id),
										 writeln('Antworten sind'),
										 writeln(Antworten),
										 send(Dialog, append, label(beschreibung, Text)),
										 send(Dialog, append, button(abbrechen, message(Frame, destroy))),
										 writeln('jetzt Antworten extrahieren'),
										 antwExtra(Antworten, Dialog, Frame).

antwExtra([], _, _).

antwExtra([But, Id|Rest], Dialog, Frame) :- frage(Id, Text, Antworten),
									 writeln('--------\n Bin gerade bei'),
									 writeln(Id),
									 writeln('Mit den Antworten'),
									 writeln(Antworten),
									 [Test|_] = Antworten,
									 send(Dialog, append, new(button(But, message(@prolog, auswerten, Id, Text, Antworten, Dialog, Frame)))),
									 send(Dialog, append, label(beschreibung, Test)),
							         antwExtra(Rest, Dialog, Frame).
