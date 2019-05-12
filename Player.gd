extends KinematicBody2D

var velocity = Vector2()

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER  = -200
const FLOOR = Vector2(0, -1)

const FIREBALL = preload("res://Fireball.tscn")

var on_ground = false

#func _ready():
#	pass # Replace with function body.

func _process(delta):
	
	if Input.is_action_pressed("ui_right") :
		velocity.x = SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
		if sign($ShootPosition.position.x) == -1 :
			$ShootPosition.position.x *= -1
		
	elif Input.is_action_pressed("ui_left") :
		velocity.x = -SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
		if sign($ShootPosition.position.x) == 1 :
			$ShootPosition.position.x *= -1
		
	else :
		velocity.x = 0;
		if on_ground == true :
			$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("ui_up") :
		if on_ground == true :
			velocity.y = JUMP_POWER
			on_ground = false
			
	if Input.is_action_just_pressed("ui_focus_next") :
		var fireball = FIREBALL.instance()
		
		if sign($ShootPosition.position.x) == -1 :
			fireball.set_fireball_direction(-1)
		else :
			fireball.set_fireball_direction(1)
			
		get_parent().add_child(fireball)
		fireball.position = $ShootPosition.global_position
		
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
	else :
		on_ground = false
		if velocity.y < 0 :
			$AnimatedSprite.play("jump")
		else :
			$AnimatedSprite.play("fall")
			
		
	velocity = move_and_slide(velocity, FLOOR);
	
