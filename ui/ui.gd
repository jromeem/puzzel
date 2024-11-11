class_name UI extends Control

var isReady = false
var spellword: Spell
var processed_text = ''
const MAX_HISTORY_LINES = 20

signal spell_ready(components)

@onready var line_edit: LineEdit = $Container/LineEdit
@onready var label: RichTextLabel = $Container/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ''
	line_edit.text = ''
	line_edit.mouse_filter = line_edit.MOUSE_FILTER_IGNORE

func toggle_ui():
	isReady = !isReady
	set_ready(isReady)

func set_ready(ready_val: bool):
	if ready_val:
		enable_line_edit()
	else:
		emit_spell_ready()
		process_line_input()
		disable_line_edit()
	line_edit.text = ""

func enable_line_edit():
	line_edit.mouse_filter = line_edit.MOUSE_FILTER_STOP
	line_edit.grab_focus()

func disable_line_edit():
	line_edit.mouse_filter = line_edit.MOUSE_FILTER_IGNORE
	line_edit.release_focus()

func emit_spell_ready(): 
	spellword = Spell.new(processed_text)
	if spellword.is_valid:
		spell_ready.emit(spellword.spell_components)

func process_line_input():
	if line_edit.text.length() == 0:
		return
	
	add_to_history(spellword.format_spell_text() + "\n")
	trim_history_if_needed()

func add_to_history(text: String):
	label.text += text

func trim_history_if_needed():
	if label.get_line_count() > MAX_HISTORY_LINES:
		label.text = label.text.strip_edges(true, false)
		label.text = label.text.erase(0, label.text.find('\n', 0))

func _on_text_changed(new_text: String):
	# Only allow a-zA-Z characters
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z]")
	var cleaned_text = regex.sub(new_text, "", true).strip_edges()
	
	# If the cleaned text is different from input, update the LineEdit
	if cleaned_text != new_text:
		line_edit.text = cleaned_text
		line_edit.set_caret_column(cleaned_text.length())
		
	# Convert to lowercase for consistent validation
	processed_text = cleaned_text.to_lower()
		
# Optional: Add this function to restrict input characters in real-time
func _gui_input(event: InputEvent):
	if event is InputEventKey:
		if event.keycode == KEY_BACKSPACE or event.keycode == KEY_DELETE:
			return
		
		var typed_char = char(event.unicode)
		if not typed_char.to_lower().is_valid_identifier():
			get_viewport().set_input_as_handled()
