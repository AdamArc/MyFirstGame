extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
@onready var img = get_node("AnimatedSprite2D")

func _ready():
	img.play("Idle")

func _physics_process(delta):
	if img.animation != "Death":
		#gravity
		velocity.y += gravity * delta
		
		if chase == true:
			img.play("Jump")
			player = get_node("../../Player/Player")
			var direction = (player.global_position - global_position).normalized()
			
			if direction.x > 0:
				if not img.flip_h: img.flip_h = true
			else:
				if img.flip_h: img.flip_h = false
			
			if chase: velocity.x = direction.x * SPEED
		else:
			img.play("Idle")
			velocity.x = 0
		
		move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false

func _on_player_death_body_entered(body):
	if body.name == "Player":
		Game.gold += 5
		chase = false
		img.play("Death")
		await img.animation_finished
		queue_free()

func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 50
		chase = false
		img.play("Death")
		await img.animation_finished
		queue_free()
