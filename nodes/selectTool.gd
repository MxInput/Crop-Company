extends Button

func _on_pressed() -> void:
	ToolVariables.change_tool(self.name)
