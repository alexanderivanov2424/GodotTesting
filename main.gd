extends Control

@onready
var InputBox : TextEdit = $InputBox

@onready
var ChatLog : RichTextLabel = $ChatLog


func _ready() -> void:
	print("Ready!")
