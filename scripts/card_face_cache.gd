extends Node

const CARD_SCENE = preload("res://scenes/card.tscn")
var faces: Dictionary = {}

func get_face(data: CardData) -> Texture2D:
	if faces.has(data):
		return faces[data]
	var viewport := SubViewport.new()
	viewport.name = "Face_" + str(data.card_id)
	viewport.size = Vector2i(336, 468)
	viewport.transparent_bg = true
	viewport.disable_3d = true
	viewport.gui_disable_input = true
	viewport.world_2d = World2D.new()
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(viewport)
	var card: Card = CARD_SCENE.instantiate()
	viewport.add_child(card)
	card.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	card.position = Vector2.ZERO
	card.size = Vector2(336, 468)
	card.can_drag = false
	card.setup(data)
	card.set_process(false)
	var texture := viewport.get_texture()
	faces[data] = texture
	return texture
