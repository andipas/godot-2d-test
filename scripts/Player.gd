extends KinematicBody2D

var velocity = Vector2()

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER  = -200
const FLOOR = Vector2(0, -1)

const FIREBALL = preload("res://scenes/Fireball.tscn")

var on_ground = false
var is_shooting = false

var direction = 1

func _ready():
	set_process(true)
	

func _process(delta):
	
	if Input.is_action_pressed("ui_right") :
		direction = 1
		Move()
		
	elif Input.is_action_pressed("ui_left") :
		direction = -1
		Move()
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
		shoot()
		
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
			
		
	velocity = move_and_slide(velocity, FLOOR)
	
#	for frPos in firebals:
#		var str_sp = 'FP: ' + str(frPos.x) + ', ' + str(frPos.y)
#		get_parent().find_node("Label").set_text(str_sp)
	

func Move():
	var flip = false
	if direction == -1:
		flip = true
	velocity.x = SPEED * direction
	$AnimatedSprite.flip_h = flip
	
	var sign_x = sign($ShootPosition.position.x) 
	if sign_x == -1 && direction == 1 :
		$ShootPosition.position.x *= -1
	elif sign_x == 1 && direction == -1 :
		$ShootPosition.position.x *= -1
	
	if is_shooting == false :
		$AnimatedSprite.play("run")
		
func shoot():
	# если на земле то останавливаемся для каста			
	if is_on_floor():
		velocity.x = 0
		
	is_shooting = true;
	$AnimatedSprite.play("shoot")
	var fireball = FIREBALL.instance()
	
	var direction = 1;
	if sign($ShootPosition.position.x) == -1 :
		direction = -1;
	
	fireball.set_fireball_direction(direction)
		
	get_parent().add_child(fireball)
	fireball.position = $ShootPosition.global_position

	
func _draw():
	draw_circle($ShootPosition.position, 2, Color(255, 0, 0))

func _on_AnimatedSprite_animation_finished():
	is_shooting = false
