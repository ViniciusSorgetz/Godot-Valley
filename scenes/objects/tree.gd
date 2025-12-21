extends StaticBody2D

@onready var flash_sprite_2d: = $FlashSprite2d;
@onready var apple_spawn_positions: Node2D = $AppleSpawnPositions;
@onready var apples: Node2D = $Apples;
@onready var stump_sprite: Sprite2D = $Stump;
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D;

const apple_texture = preload("res://graphics/plants/apple.png");
var health := 3:
	set(value):
		health = value
		if(value <= 0):
			flash_sprite_2d.hide();
			stump_sprite.show(); 

func _ready() -> void:
	create_apples(3);

func hit(tool: Enum.Tool):
	if(tool == Enum.Tool.AXE):
		flash_sprite_2d.flash();
		get_apple();
		health -= 1;

func create_apples(num: int):
	var apple_markers = apple_spawn_positions.get_children().duplicate(true);
	for i in num:
		var position_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1));
		var sprite = Sprite2D.new();
		sprite.texture = apple_texture;
		apples.add_child(sprite);
		sprite.position = position_marker.position

func get_apple():

	var current_apples := apples.get_children();

	if(current_apples):
		current_apples.pick_random().queue_free()
		print("get apple");
