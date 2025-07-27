extends Control

@onready
var InputBox : TextEdit = $InputBox

@onready
var ChatLog : RichTextLabel = $ChatLog

func _ready() -> void:
	print("Ready!")
	print(InputBox.text)
	
func _process(delta: float) -> void:
	print("tick" + str(delta))


func _on_create_game_pressed() -> void:
	pass # Replace with function body.
	
	
