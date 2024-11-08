class_name Dino extends CharacterBody2D

enum State { IDLE, WALKING_LEFT, WALKING_RIGHT, CONJURING, CASTING }
enum Tile { LEFT = 0, MIDDLE = 1, RIGHT = 2}

@onready var dino: CharacterBody2D = $Dino
