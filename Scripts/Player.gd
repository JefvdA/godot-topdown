extends KinematicBody2D


var bullet = preload("res://Scenes/Player/Bullet.tscn")

var movespeed = 3
var bulletspeed = 10

var movedirection = Vector2()


func _ready():
	var screenwidth = ProjectSettings.get_setting("display/window/size/width")
	var screenheight = ProjectSettings.get_setting("display/window/size/height")
	
	position = Vector2(screenwidth / 2, screenheight / 2)


func _process(_delta):
	# Calculate the movedirection and keep it's value in the variable
	movedirection = Vector2()
	if Input.is_action_pressed("up"):
		movedirection.y -= 1
	if Input.is_action_pressed("down"):
		movedirection.y += 1
	if Input.is_action_pressed("right"):
		movedirection.x += 1
	if Input.is_action_pressed("left"):
		movedirection.x -= 1
	movedirection = movedirection.normalized()
	
	# Make player look at the mouse
	look_at(get_global_mouse_position())
	
	# Shoot a bullet when the player presses 'fire'
	if Input.is_action_just_pressed("fire"):
		fire()


func _physics_process(_delta):
	# Move the player based on the movedirection calculated in _process
	var _x = move_and_slide(movedirection * movespeed * 100)
	
	var screenwidth = ProjectSettings.get_setting("display/window/size/width")
	var screenheight = ProjectSettings.get_setting("display/window/size/height")
	
	if position.x < 0:
		position.x = 0
	elif position.x > screenwidth:
		position.x = screenwidth
	
	if position.y < 0:
		position.y = 0
	elif position.y > screenheight:
		position.y = screenheight


func _on_Hitbox_body_entered(body):
	if "Enemy" in body.name:
		Global.reset()
		die()


func fire():
	var bullet_instance = bullet.instance()
	
	bullet_instance.position = position + Vector2(20, 0).rotated(rotation)
	bullet_instance.rotation = rotation
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletspeed * 100, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)


func die():
	var _x = get_tree().reload_current_scene()
