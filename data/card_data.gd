extends Resource
class_name CardData

# Identificador interno permanente. Nomes podem mudar ou se repetir; IDs não.
@export var card_id: StringName = &""

@export var card_name: String = ""
@export var cost: int = 0
@export var attack: int = 0
@export var health: int = 0
@export var type_name: String = ""
@export var description: String = ""
@export var art: Texture2D
@export var type_frame: Texture2D
