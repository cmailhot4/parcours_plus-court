extends Node2D

onready var case = $case
var index
var couleur
var visite
var type
var voisins
var voisins_accessibles
var distance
var index_precedent

# Called when the node enters the scene tree for the first time.
func _ready():
	index = null
	couleur = Color(1, 1, 1, 1)
	visite = false
	type = null
	voisins = []
	voisins_accessibles = []
	distance = 99999 #infini (relatif)
	index_precedent = null

# Permet de modifier les voisins de la case
# v: tableau des voisins [gauche, haut, droite, bas]
func _set_voisins(v):
	voisins = v
	_set_voisins_accessibles()

# Permet de setter les voisins qui sont des cases accessibles
func _set_voisins_accessibles():
	for i in range(voisins.size()):
		if typeof(voisins[i]) == TYPE_INT:
			voisins_accessibles.append(voisins[i])

# Change le type de la case et associe la bonne couleur
func _set_type(t):
	type = t
	if t == 'mur':
		couleur = Color(0.66, 0.66, 0.66, 1) #gris
	elif t == 'case':
		couleur = Color( 1, 1, 1, 1 ) #blanc
	elif t == 'arrivee':
		couleur = Color( 1, 0, 0, 0.75 ) #rouge
	elif t == 'depart':
		couleur = Color( 0, 0, 1, 0.75 ) #bleu
	else:
		couleur = Color( 0.25, 0.88, 0.82, 1 ) #turquoise
	
	_set_couleur(couleur)

# Modifie la couleur de la case
# c: couleur
func _set_couleur(c):
	case.color = c

# Marque la case comme visitée
func _set_visite():
	visite = true

# Change la valeur de la case (pour les cases pivots)
# d: distance
func _set_distance(d):
	distance = d

# Change la valeur de l'index de la case
# i: index de la case (dans le tableau des cases)
func _set_index(i):
	index = i

# Change la valeur de l'index de la case précédente
# i: index de la case (dans le tableau des cases) précédente (la case par laquelle on a dû passé pour atteindre notre distance la plus courte)
func _set_index_precedent(i):
	index_precedent = i
