extends Node2D

@onready var soil_layer: TileMapLayer = $Layers/SoilLayer
@onready var soil_water_layer: TileMapLayer = $Layers/SoilWaterLayer
@onready var grass_layer: TileMapLayer = $Layers/GrassLayer
@onready var objects: Node2D = $Objects

var plant_scene = preload("res://scenes/objects/plant.tscn");
var used_cells: Array[Vector2i];

func _on_player_tool_use(tool: Enum.Tool, player_position: Vector2) -> void:

	var x = round_position(player_position.x);
	var y = round_position(player_position.y);

	var grid_coord := Vector2i(x, y);

	# checks if the tile is soil
	var check_soil := soil_layer.get_cell_tile_data(grid_coord);

	match tool:
		Enum.Tool.HOE:
			var check_grass := grass_layer.get_cell_tile_data(grid_coord);
			
			if(check_grass && check_grass.get_custom_data("farmable")):
				soil_layer.set_cells_terrain_connect([grid_coord], 0, 0);
			
		Enum.Tool.WATER:
			# checks if the soil isn't watered
			var check_soild_water := soil_water_layer.get_cell_tile_data(grid_coord);

			if(check_soil &&!check_soild_water):
				var variaton = randi_range(0, 2);
				soil_water_layer.set_cell(grid_coord, 0, Vector2i(variaton, 0));

		Enum.Tool.FISH:
			var check_grass := grass_layer.get_cell_tile_data(grid_coord);
			if(!check_grass):
				print("fishing");

		Enum.Tool.SEED:
			if(check_soil && grid_coord not in used_cells):
				var plant := plant_scene.instantiate();
				plant.setup(grid_coord, objects)
				used_cells.append(grid_coord);

		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group("Objects"):
				if(object.position.distance_to(player_position) < 20):
					object.hit(tool)

	pass

func round_position(pos: float):

	if(pos < 0):
		return floor(pos / Data.TILE_SIZE)
	else:
		return round((pos / Data.TILE_SIZE) - 0.5)
