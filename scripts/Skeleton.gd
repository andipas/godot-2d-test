extends KinematicBody2D

const GRAVITY = 20
const SPEED = 10
const FLOOR = Vector2(0, -1)

var direction = 1;

var velocity = Vector2()

var last_time_flip = 0

var timer = null
var flip_delay = 0.1
var can_flip = true

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(flip_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
func on_timeout_complete():
	can_flip = true;

func _physics_process(delta):
	
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	
	$Sprite/AnimationPlayer.play("walk")
	
	if direction == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	if can_flip && ($RayCast2D.is_colliding() == false || is_on_wall()):
		direction *= -1
		$RayCast2D.position.x *= -1
		can_flip = false
		timer.start()
			
	velocity = move_and_slide(velocity, FLOOR)
	
#	print("x =" + str(velocity.x) + " dir = " + str(direction));
		
		
	
	