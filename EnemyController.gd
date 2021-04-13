extends KinematicBody2D

var gravity = 10
var walk_speed = 120
var FLOOR = Vector2(0, -1)
var movement = Vector2(0, 0)

var is_dead = false

var direction = -1

func dead():
	is_dead = true
	movement = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	if not is_dead:
		movement.x = walk_speed * direction
		
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("walk")
		
		movement.y += gravity
		
		movement = move_and_slide(movement, FLOOR)
	
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
		
	if not $RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1


func _on_AnimatedSprite_animation_finished():
	if is_dead:
		queue_free()
