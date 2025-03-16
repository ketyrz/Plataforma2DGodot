extends Camera2D

var player: Node2D

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("player not found")
	
	
func _process(_delta: float) -> void:
	position = player.position
