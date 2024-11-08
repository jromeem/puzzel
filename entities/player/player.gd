# res://scripts/characters/player/player_state_machine.gd
class_name PlayerStateMachine
extends Node

enum State { IDLE, WALKING, CONJURING, CASTING }

var current_state: State = State.IDLE
@onready var player: CharacterBody2D = $"."
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE:
			handle_idle_state()
		State.WALKING:
			handle_walking_state()
		State.CONJURING:
			handle_conjuring_state()
		State.CASTING:
			handle_casting_state()

func handle_idle_state() -> void:
	animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("conjure"):
		transition_to(State.CONJURING)
	elif Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		transition_to(State.WALKING)

func handle_walking_state() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		transition_to(State.IDLE)
		return
		
	if Input.is_action_just_pressed("conjure"):
		transition_to(State.CONJURING)
		return
	
	animated_sprite.play("walk")
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
	player.velocity = direction * player.speed
	player.move_and_slide()

func handle_conjuring_state() -> void:
	animated_sprite.play("step")
	player.velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("conjure_end"):
		transition_to(State.IDLE)

func handle_casting_state() -> void:
	animated_sprite.play("cast")
	if not animated_sprite.is_playing():
		transition_to(State.IDLE)

func transition_to(new_state: State) -> void:
	match new_state:
		State.CONJURING:
			player.conjuring_started.emit()
		State.IDLE:
			if current_state == State.CONJURING:
				player.conjuring_ended.emit()
	
	current_state = new_state
