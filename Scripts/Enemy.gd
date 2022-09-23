extends KinematicBody2D


var movespeed = 2

var movedirection = Vector2()


func _process(_delta):
	var player = get_parent().get_node("Player") # Get a reference to the player object
	
	look_at(player.position)
	
	movedirection = Vector2(1, 0).rotated(rotation)


func _physics_process(_delta):
	var _x = move_and_collide(movedirection * movespeed)


func _on_Hitbox_body_entered(body):
	if "Bullet" in body.name:
		Global.increase_score()
		queue_free()
