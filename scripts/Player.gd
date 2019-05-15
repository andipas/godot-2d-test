extends KinematicBody2D

var velocity = Vector2()

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER  = -200
const FLOOR = Vector2(0, -1)

const FIREBALL = preload("res://scenes/Fireball.tscn")

var on_ground = false

var is_shooting = false

func _ready():
	set_process(true)
	

func _process(delta):
	
	if Input.is_action_pressed("ui_right") :
		Move(1)
		
	elif Input.is_action_pressed("ui_left") :
		Move(-1)
	else :
		velocity.x = 0;
		if on_ground == true && is_shooting == false :
			$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("ui_up") :
		is_shooting = false
		if on_ground == true :
			velocity.y = JUMP_POWER
			on_ground = false
			
	if Input.is_action_just_pressed("ui_focus_next") && is_shooting == false :
		if is_on_floor():
			velocity.x = 0
			
		is_shooting = true;
		$AnimatedSprite.play("shoot")
		var fireball = FIREBALL.instance()
		
		var dir = 1;
		if sign($ShootPosition.position.x) == -1 :
			dir = -1;
		
		fireball.set_fireball_direction(dir)
			
		get_parent().add_child(fireball)
		var x = $ShootPosition.global_position.x
		var y = $ShootPosition.global_position.y
		
		x -= 20
		if dir == -1 :
			x -= 10
		
		fireball.position = Vector2(x,y)
		
		var str_fp = 'FP: ' + str(fireball.position.x) + ', ' + str(fireball.position.y)
		var str_sp = 'SP: ' + str($ShootPosition.global_position.x) + ', ' + str($ShootPosition.global_position.y)
		
		get_parent().find_node("LabelSP").set_text(str_sp)
		get_parent().find_node("LabelFP").set_text(str_fp)
		
	velocity.y += GRAVITY
	
	if is_on_floor():
		if on_ground == false:
			is_shooting = false
		on_ground = true
	else :
		if is_shooting == false :
			on_ground = false
			if velocity.y < 0 :
				$AnimatedSprite.play("jump")
			else :
				$AnimatedSprite.play("fall")
			
		
	velocity = move_and_slide(velocity, FLOOR);

func Move(dir):
	var flip = false
	if dir == -1:
		flip = true
	velocity.x = SPEED * dir
	$AnimatedSprite.flip_h = flip
	
	var sign_x = sign($ShootPosition.position.x) 
	if sign_x == -1 && dir == 1 :
		$ShootPosition.position.x *= -1
	elif sign_x == 1 && dir == -1 :
		$ShootPosition.position.x *= -1
	
	if is_shooting == false :
		$AnimatedSprite.play("run")
	
	
#func _draw():
#	var x = $ShootPosition.global_position.x
#	var y = $ShootPosition.global_position.y
#	draw_line(Vector2(0, 0), Vector2((x + 10), y), Color(255, 0, 0), 1)

func _on_AnimatedSprite_animation_finished():
	is_shooting = false
