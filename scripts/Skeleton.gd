extends KinematicBody2D

const GRAVITY = 20
const SPEED = 30
const FLOOR = Vector2(0, -1)

var direction = 1;
var velocity = Vector2()
var hp = 3

var last_time_flip = 0

var timer = null
var flip_delay = 0.1
var can_flip = true

var is_dead = false

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(flip_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
	
func on_timeout_complete():
	can_flip = true;

func _physics_process(delta):
	if is_dead == false :
		move()
	else :
		$CollisionShape2D.disabled = true
		
func damage(damage):
	if hp > 0:
		hp = hp - damage
	
	if hp <= 0:
		dead()

func move():
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	
	$AnimatedSprite.play("walk")
	
	if direction == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

	if can_flip && ($RayCast2D.is_colliding() == false || is_on_wall()):
		direction *= -1
		$RayCast2D.position.x *= -1
		can_flip = false
		timer.start()
			
	velocity = move_and_slide(velocity, FLOOR)
	
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("die")	
	