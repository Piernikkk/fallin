extends Control

@onready var level: Label = %Level;
@onready var power: Label = %Power;
@onready var hp: Label = %HP;
@onready var health: ProgressBar = %HealthBar;
@onready var pause_menu: Control = %PauseMenu;

var is_paused = false;

func _ready() -> void:
	Globals.connect("level_update", Callable(self, "_on_level_up"));
	Globals.connect("map_level_changed", Callable(self, "_on_map_level_changed"));
	
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS;

func _on_player_health_changed(new_health: int) -> void:
	hp.text = str(new_health);
	health.value = new_health;

func _on_level_up(_new_level: int, new_power: int) -> void:
	# level.text = str(new_level);
	power.text = str(new_power);

func _on_map_level_changed(new_map_level: int) -> void:
	level.text = str(new_map_level);

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == Key.KEY_ESCAPE:
		toggle_paused();
		
func toggle_paused() -> void:
	is_paused = not is_paused;
	pause_menu.visible = is_paused;

	get_tree().paused = is_paused;

func _on_resume_pressed() -> void:
	toggle_paused();


func _on_quit_pressed() -> void:
	get_tree().paused = false;
	Engine.time_scale = 1.0;
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
