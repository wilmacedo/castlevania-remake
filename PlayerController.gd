extends KinematicBody2D

export var gravity = 10
export var walk_speed = 180
export var jump_power = -350
export var movement = Vector2(0, 0)

var defaultScale = 3

var can_double_jump = true
var is_attacking = false

func _physics_process(delta):
	
	if not is_on_floor():
		movement.y += gravity
	else:
		can_double_jump = true
		movement.y = gravity
	
	var horizontal_axis = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement.x = horizontal_axis * walk_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		movement.y = jump_power
	elif Input.is_action_just_pressed("jump") and can_double_jump:
		can_double_jump = false
		movement.y = jump_power - 100
		
	if Input.is_action_just_pressed("attack") && !is_attacking:
		is_attacking = true
	
	move_and_slide(movement, Vector2.UP)
	
	update_animations()
	
func update_animations():
	if movement.x > 0:
		$AnimatedSprite.scale.x = defaultScale
	elif movement.x < 0:
		$AnimatedSprite.scale.x = -defaultScale
		
					
	if is_on_floor():
		if is_attacking:
			$AnimatedSprite.play("attack")
		else:	
			if abs(movement.x) > 0:
				$AnimatedSprite.play("walk")
			else:
				$AnimatedSprite.play("idle")
	else:
		if not can_double_jump:
			$AnimatedSprite.play("double_jump")
		else:
			$AnimatedSprite.play("jump")


func _on_Area2D_body_entered(body):
	position = Vector2(300, 300)
	movement = Vector2(0, 0)


func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Gargula_body_entered(body):
	if is_attacking:
		print("Special Scene")
		#special scene
		pass


func _on_Arm_body_entered(body):
	if "Enemy" in body.name:
		if is_attacking:
			body.dead()
		else:
			print("Perder vida")
