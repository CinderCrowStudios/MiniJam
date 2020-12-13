extends KinematicBody2D

const EnemyDeathEffect = preload("res://Misc/EnemyDeathEffect.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var knockback = Vector2.ZERO
var state = IDLE
var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var hurtbox = $HurtBox
onready var playerDetectionZone = $PlayerDetectionZone

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
		ATTACK:
			pass
	velocity = move_and_slide(velocity)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	

func _on_Stats_no_health():
	queue_free()
	var enemeyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemeyDeathEffect)
	enemeyDeathEffect.global_position = global_position