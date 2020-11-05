extends Node2D

onready var case = $case
var couleur
var visite
var type
var voisins
var voisins_accessibles

# Called when the node enters the scene tree for the first time.
func _ready():
	couleur = Color(1, 1, 1, 1)
	visite = false
	type = null
	voisins = []
	voisins_accessibles = []

# Permet de modifier les voisins de la case
# v: tableau des voisins [gauche, haut, droite, bas]
func _set_voisins(v):
	voisins = v
	_set_voisins_accessibles()

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
