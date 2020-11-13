extends Node2D

# Cases
onready var cases = [$case0, $case1, $case2, $case3, $case4, $case5, $case6, $case7, $case8, $case9, $case10, $case11, $case12, $case13, $case14, $case15, $case16, $case17, $case18, $case19, $case20, $case21, $case22, $case23, $case24]

# Variables
var nb_colonnes #nombre de colonnes dans le labyrinthe
var i_depart #index de la case départ
var i_arrivee #index de la case d'arrivée
var ordre_parcours #tableau contenant les cases parcourrues en ordre
var cases_pivots #tableau contenant les cases pivots du labyrinthe
var cases_non_visitees #tableau des cases non visitées

# Called when the node enters the scene tree for the first time.
func _ready():
	nb_colonnes = 5
	i_depart = 0
	i_arrivee = 9
	ordre_parcours = []
	cases_pivots = []
	cases_non_visitees = []
	
	# Set les indexs
	_set_indexs()
	
	# Place les murs
	_set_murs([1, 6, 8, 13, 16, 18])
	
	# Place le départ et l'arrivée
	_set_depart_arrive(i_depart, i_arrivee)
	
	# Initialise les voisins
	_set_voisins()
	
	# Parcourt le labyrinthe pour trouver les cases pivots (celles qui ont 3 voisins accessibles).
	# Servira à construire un graphe avec les cases pivots et leur poids (nombre de cases pour s'y rendre)
	_trouver_cases_pivots()
	
	# Parcours le labyrinthe pour trouver le chemin le plus court de la case début à celle de fin
	_parcours_plus_court()

# Fonction qui met-à-jour la variable index de chaque case du labyrinthe
func _set_indexs():
	for i in range(cases.size()):
		cases[i]._set_index(i)

# Change le type des cases pour des murs aux index passés en paramètres
# tab_index: tableau contenant les indexes des cases à transformer en murs
func _set_murs(tab_index):
	for i in range(tab_index.size()):
		cases[tab_index[i]]._set_type('mur')

# Change le type des cases pour le départ et l'arrivée aux index passés en paramètres
# index_depart: index de la case de départ
# index_arrive: index de la case d'arrivée
func _set_depart_arrive(index_depart, index_arrivee):
	cases[index_depart]._set_type('depart')
	cases[index_arrivee]._set_type('arrivee')

# Attribue les voisins de chaque case dans cet ordre: [gauche, haut, droite et bas]
func _set_voisins():
	var indexes_voisins = []
	var g = -1 #gauche
	var h = -1 #haut
	var d = -1 #droite
	var b = -1 #bas
	
	# pour chaque case du labyrinthe
	for i in range(cases.size()):
		g = i - 1
		h = i - nb_colonnes
		d = i + 1
		b = i + nb_colonnes
		
		# Si on est pas dans la première ou derniere colonne
		if (i % nb_colonnes != 0) and (i % nb_colonnes != (nb_colonnes -1)):
			# mur de gauche
			if _is_mur(g):
				g = 'mur'
			
			# mur du haut
			if h >= 0:
				if _is_mur(h):
					h = 'mur'
			else:
				h = 'vide'
			
			# mur de droite
			if _is_mur(d):
				d = 'mur'
			
			# mur du bas
			if b <= (cases.size() - 1): # si l'indice du voisin en bas est en dehors du tableau
				if _is_mur(b):
					b = 'mur'
			else:
				b = 'vide'
		else:
			# si on est dans la première colonne (pas de voisin de gauche)
			if i % nb_colonnes == 0:
				# mur de gauche
				g = 'vide'
				
				# mur du haut
				if h >= 0:
					if _is_mur(h):
						h = 'mur'
				else:
					h = 'vide'
				
				# mur de droite
				if _is_mur(d):
					d = 'mur'
				
				# mur du bas
				if b <= 24:
					if _is_mur(b):
						b = 'mur'
				else:
					b = 'vide'
				
			# si on est dans la dernière colonne (pas de voisin de droite)
			elif i % nb_colonnes == (nb_colonnes -1):
				# mur de gauche
				if _is_mur(g):
					g = 'mur'
				
				# mur du haut
				if h >= 0:
					if _is_mur(h):
						h = 'mur'
				else:
					h = 'vide'
				
				# mur de droite
				d = 'vide'
				
				# mur du bas
				if b <= 24:
					if _is_mur(b):
						b = 'mur'
				else:
					b = 'vide'
		
		# mise à jour des index des voisins
		indexes_voisins = [g, h, d, b]
		cases[i]._set_voisins(indexes_voisins)
		indexes_voisins = []

# Vérifie que la case passée en paramètre est un mur
# c: index de la case à vérifier
func _is_mur(c):
	if cases[c].type == 'mur':
		return true
	else:
		return false

# Fonction qui parcourt le labyrinthe pour trouver les cases qui ont 3 voisins accessibles
func _trouver_cases_pivots():
	# l'entrée du labyrinthe est la 1ere case pivot
	cases_pivots.append(cases[i_depart])
	
	# parcourt chaque case du labyrinthe et l'ajoute au tableau des cases pivots si la case n'est pas un mur, l'arrivée et qu'elle a au moins 3 voisins
	for i in range(cases.size()):
		if cases[i].type != 'mur':
			if cases[i].type != 'arrivee':
				if cases[i].voisins_accessibles.size() >= 3:
					cases_pivots.append(cases[i])
	
	# l'arrivée du labyrinthe est la dernière case pivot
	cases_pivots.append(cases[i_arrivee])
	
	# Voisins de 0
	cases_pivots[0]._set_voisins_pivots(10, 2)
	cases_pivots[0]._set_distance(0) #point de départ donc la distance est égale à 0
	
	# voisins de 10
	cases_pivots[1]._set_voisins_pivots(0, 2)
	cases_pivots[1]._set_voisins_pivots(12, 2)
	cases_pivots[1]._set_voisins_pivots(22, 4)
	
	# voisins de 12
	cases_pivots[2]._set_voisins_pivots(10, 2)
	cases_pivots[2]._set_voisins_pivots(22, 2)
	cases_pivots[2]._set_voisins_pivots(9, 5)
	
	# voisins de 22
	cases_pivots[3]._set_voisins_pivots(10, 4)
	cases_pivots[3]._set_voisins_pivots(12, 2)
	cases_pivots[3]._set_voisins_pivots(9, 5)
	
	# voisins de 9
	cases_pivots[4]._set_voisins_pivots(12, 5)
	cases_pivots[4]._set_voisins_pivots(22, 5)

# Fonction qui parcours le labyrinthe pour trouver le chemin le plus court
func _parcours_plus_court():
	# La case de départ (i_depart) possède une distance de 0
	# Toutes les autres cases pivots possèdent un distance infinie (99999)
	var case_actuelle = cases_pivots[0] #représente la case actuelle
	var distance_min
	var done = false
	
	# on ajoute les indexs des cases pivots au tableau des cases non visitées
	for i in range(cases_pivots.size()):
		cases_non_visitees.append(cases_pivots[i])
	
	while done == false:
		# calcul la distance de chaque voisin de la case actuelle et trouve la prochaine case à visiter
		distance_min = _visiter_voisins(case_actuelle)
	
		# vérifie que la case avec la plus petite distance est la case d'arrivée du labyrinthe
		if distance_min == i_arrivee:
			print(cases[distance_min].distance)
			done = true
		else:
			case_actuelle = cases[distance_min]
	
	#_afficher_solution()
	
	print("Terminé")

# Fonction qui permet de visiter les voisins d'une case pour changer leur valeur (distance)
# c: case actuelle (celle dont on veut visiter les voisins)
# return: index du voisin ayant la plus petite distance
func _visiter_voisins(c):
	var case_pivot_voisin
	var dist
	var distance_min = 100000
	var i_next_case = -1
	
	# pour chaque voisin de la case actuelle
	for i in range(c.voisins_pivots.size()):
		var index_case_voisin = c.voisins_pivots[i][0]
		case_pivot_voisin = cases[index_case_voisin] #case voisine de la case actuelle
		
		# calcul de la distance entre la case actuelle et sa case voisine
		dist = c.distance + c.voisins_pivots[i][1]
		
		# vérifie si la distance entre la case actuelle et la case voisine est plus petite que la valeur de la case voisine
		if dist < case_pivot_voisin.distance:
			# la nouvelle distance est plus petite que l'ancienne donc on la change
			case_pivot_voisin._set_distance(dist)
	
	# marquer la case actuelle comme visitée
	c._set_visite()
	
	# enlève cette case du tableau des cases non visitées
	cases_non_visitees.erase(c)
	
	# on cherche la case avec la plus petite distance dans le tableau des cases non visitées
	for i in range(cases_non_visitees.size()):
		# si la distance de la case non visitée est plus petite que la distance minimum
		if cases_non_visitees[i].distance < distance_min:
			# la case actuelle deviendra la case avec la plus petite distance du tableau des cases non visitées
			i_next_case = cases_non_visitees[i].index
			# la nouvelle distance minimum est la distance de la case à l'index i du tableau des cases non visitées
			distance_min = cases_non_visitees[i].distance
	
	return i_next_case

# Fonction récursive qui visite et marque les cases
# case: la case que l'on visite
func _visiter(case):
	#ordre_parcours.append(case)
	case._set_visite()
	
	for i in range(case.voisins_accessibles.size()):
		var voisin = cases[case.voisins_accessibles[i]]
		if voisin.visite == false:
			print('Parcourir: ', case.voisins_accessibles[i])
			_visiter(voisin)

# Fonction qui affiche (change la couleur) les cases parcourrues en ordre
func _afficher_solution():
	var couleur_parcour = Color(1, 1, 0, 0.75) #jaune
	for i in range(ordre_parcours.size()):
		# change la couleur de la case
		ordre_parcours[i]._set_couleur(couleur_parcour)
		# fait une pause de 1 seconde
		yield(get_tree().create_timer(1.0), "timeout")
