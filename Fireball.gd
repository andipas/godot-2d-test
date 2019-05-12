extends Area2D

const SPEED = 160
var velocity = Vector2()
var direction = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func set_fireball_direction(dir):
	direction = dir
	if direction == -1 :
		$AnimatedSprite.flip_h = true
	else :
		$AnimatedSprite.flip_h = false

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	$AnimatedSprite.play("flash")
	queue_free()
