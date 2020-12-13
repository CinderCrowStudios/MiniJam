extends KinematicBody2D

var knockback = Vector2.ZERO

onready var hurtbox = $HurtBox

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 500 * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * 150
