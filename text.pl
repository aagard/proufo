mon_premier_program :-
	% on crée la fenêtre
	new(D, window('Ma première fenêtre')),
	% on lui donne la bonne taille
	send(D, size, size(250, 100)),
	% on crée un composant texte
	new(T, text('Hello World !')),
	% on demande à la fenêtre de l'afficher à peu près au milieu
	send(D, display, T, point(80, 40)),
	% on envoie à la fenêtre le message d'affichage.
	send(D, open).
