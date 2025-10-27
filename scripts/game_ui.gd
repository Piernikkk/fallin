extends Control

@onready var level: Label = %Level;
@onready var power: Label = %Power;
@onready var hp: Label = %HP;
@onready var health: ProgressBar = %HealthBar;

func _ready() -> void:
	Globals.connect("level_update", Callable(self, "_on_level_up"));
	Globals.connect("map_level_changed", Callable(self, "_on_map_level_changed"));

func _on_player_health_changed(new_health: int) -> void:
	hp.text = str(new_health);
	health.value = new_health;

func _on_level_up(_new_level: int, new_power: int) -> void:
	# level.text = str(new_level);
	power.text = str(new_power);

func _on_map_level_changed(new_map_level: int) -> void:
	level.text = str(new_map_level);
