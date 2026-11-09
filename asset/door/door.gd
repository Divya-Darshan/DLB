extends Node3D

@export var is_open: bool = false
@onready var  sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var col: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	canvas_layer.visible = false



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inter"): # SPACEBAR or ENTER
		toggle_door()

func toggle_door() -> void:
	is_open = !is_open
	if sprite_3d:
		if is_open:
			col.disabled = true
			sprite_3d.frame += 2
			print("Door Opened! Current frame: ", sprite_3d.frame)
		else:
			col.disabled = false
			sprite_3d.frame -= 2
			print("Door Closed! Current frame: ", sprite_3d.frame)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		canvas_layer.visible = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		canvas_layer.visible = false


func _on_pick_pressed() -> void:
	toggle_door()
