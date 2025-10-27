extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_0.tscn");

func _on_howto_pressed() -> void:
	%Main.visible = false;
	%HowTo.visible = true;


func _on_gotit_pressed() -> void:
	%HowTo.visible = false;
	%Main.visible = true;