extends Node

signal level_update(new_level: int, new_power: int);
signal enemy_slain(enemies_killed: int);
signal map_level_changed(new_map_level: int);

var enemies_killed = 0;
var level = 1;
var player_power = 10;
var map_level = 1;

func _ready() -> void:
	level_update.emit(level, player_power);

func increment_enemies_killed() -> void:
	print("Enemy slain. Total killed: ", enemies_killed + 1)
	enemies_killed += 1;
	enemy_slain.emit(enemies_killed);
	if enemies_killed % 5 == 0:
		level += 1;
		player_power = 10 + (level - 1) * 5;
		level_update.emit(level, player_power);

func increment_map_level() -> void:
	map_level += 1;
	map_level_changed.emit(map_level);