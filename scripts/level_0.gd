extends Node2D

@onready var flying_eye = preload("res://sprites/flying_eye.tscn");
@onready var enemies_to_slain = Globals.map_level * 2;

func _ready() -> void:
	Globals.connect("enemy_slain", Callable(self, "_on_enemy_slain"));
	await get_tree().create_timer(2.0).timeout
	spawn_enemy();
	spawn_enemy();
	
func spawn_enemy() -> void:
	var eye_instance = flying_eye.instantiate();
	%SpawnpointPath.progress_ratio = randf();
	eye_instance.position = %SpawnpointPath.global_position;
	add_child(eye_instance);
	
	
func _on_enemy_slain(enemies_killed: int) -> void:
	if enemies_killed >= enemies_to_slain:
		%hatch.visible = false;
		%hatch.collision_enabled = false;
	elif enemies_killed % 2 == 0:
		spawn_enemy();
		spawn_enemy();

func _on_hatch_body_entered(_body: Node) -> void:
	print("Level complete!", _body.name);
	Globals.increment_map_level();
	Globals.enemies_killed = 0;
	%Player.global_position = Vector2(365.0, -457.0);
	%hatch.visible = true;
	%hatch.collision_enabled = true;
	enemies_to_slain = Globals.map_level * 2;
	spawn_enemy();
	spawn_enemy();
	%Player.heal(30);