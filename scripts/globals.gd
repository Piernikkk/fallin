extends Node

signal level_update(new_level: int, new_power: int);

var enemies_killed = 0;
var level = 1;
var player_power = 10;
var map_level = 0;

func _ready() -> void:
	level_update.emit(level, player_power);

func increment_enemies_killed() -> void:
	enemies_killed += 1;
	if enemies_killed % 5 == 0:
		level += 1;
		player_power = 10 + (level - 1) * 5;
		level_update.emit(level, player_power);
