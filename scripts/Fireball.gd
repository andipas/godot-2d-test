extends Area2D

const SPEED = 160
var velocity = Vector2()
var direction = 1 
var is_entered = false
var damage = 1;
var is_damaged = false


func set_fireball_direction(dir):
	direction = dir
	if direction == -1 :
		$AnimatedSprite.flip_h = true
	else :
		$AnimatedSprite.flip_h = false
		

func _physics_process(delta):
	if is_entered == false:
		velocity.x = SPEED * delta * direction
		translate(velocity)
		$AnimatedSprite.play("shoot")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	is_entered = true;
	
	if body.has_method("damage") && is_damaged == false:
		body.damage(damage)
		is_damaged = true
	
	$AnimatedSprite.play("flash")

func _on_AnimatedSprite_animation_finished():
	if is_entered == true:
		queue_free()
