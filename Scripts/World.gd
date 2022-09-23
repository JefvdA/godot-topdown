extends Node2D


var enemy = preload("res://Scenes/Enemy.tscn")

var enemy_spawn_timer = Timer.new() # Create a timer for spawning ennemies

# Exported variables for all the waves
export (Array, int) var waves_max_enemies
export (Array, float) var waves_spawn_interval

# Constants
const WAVE_INTERVAL = 5

# Internal variables for handling the waves
var enemies_remaining = 0
var spawn_interval = 0
var waiting_for_alive_enemies = false

func _ready():
	# Set spawn variables, to variables of current wave
	enemies_remaining = waves_max_enemies[Global.wave]
	spawn_interval = waves_spawn_interval[Global.wave]
	
	# Setup  the enemy_spawn_timer
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.wait_time = spawn_interval
	enemy_spawn_timer.start()
	enemy_spawn_timer.connect("timeout", self, "spawn_enemy")


func _process(_delta):
	if waiting_for_alive_enemies and get_tree().get_nodes_in_group("Enemies").size() == 0:
		start_new_wave()


func spawn_enemy():
	if enemies_remaining == 0: # Don't spawn an enemy if there are no more enemies remaining
		return
	
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var screen_height = ProjectSettings.get_setting("display/window/size/height")

	# Generate a random number that will determine what side the enemy spawns
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomnumber = rng.randi_range(0, 3)

	# Calculate position where enemy should spawn
	var x = 0
	var y = 0
	if randomnumber == 0: # Then spawn to the left of the screen
		x = -256
		y = rng.randf_range(0, screen_height)
	elif randomnumber == 1: # Then spawn to the right of the screen
		x = screen_width + 256
		y = rng.randf_range(0, screen_height)
	elif randomnumber == 2: # Then spawn to the top of the screen
		x = rng.randf_range(0, screen_width)
		y = -256
	elif randomnumber == 3: # Then spawn to the bottom of the screen
		x = rng.randf_range(0, screen_width)
		y = screen_height + 256

	# Add enemy to the scene, and spawn it at the newly calculated position
	var enemy_instance = enemy.instance()
	add_child(enemy_instance)
	enemy_instance.position = Vector2(x, y)
	
	enemies_remaining -= 1
	if enemies_remaining == 0:
		end_current_wave()


func end_current_wave():
	var wave_interval_timer = Timer.new()
	add_child(wave_interval_timer)
	wave_interval_timer.wait_time = WAVE_INTERVAL
	wave_interval_timer.one_shot = true
	wave_interval_timer.start()
	wave_interval_timer.connect("timeout", self, "start_wave_interval")


func start_wave_interval():
	waiting_for_alive_enemies = true


func start_new_wave():
	waiting_for_alive_enemies = false
	
	Global.increase_wave()
	enemies_remaining = waves_max_enemies[Global.wave]
	enemy_spawn_timer = waves_spawn_interval[Global.wave]
