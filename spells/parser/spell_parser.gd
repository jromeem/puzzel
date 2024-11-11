class_name SpellParser extends Node

func _init(text) -> void:
	spell_input = text
	spell_components["spell_input"] = text 
	is_valid = process_spell()
	
var is_valid = false
var spell_input: String
var spell_prefixes: Array[String]
var spell_root: String
var spell_suffixes: Array[String]
var spell_components: Dictionary = {
	"prefixes": spell_prefixes,
	"root": spell_root,
	"suffixes": spell_suffixes,
	"spell_input": spell_input
}

# Define roots, prefixes, and suffixes for validation
var lesser_roots = ["pyri", "aqua", "volt", "zeph", "terr", "lux", "nox", "ferrum"]
var higher_roots = ["ignis", "glaci", "fulgur", "aether", "gaia", "lumen", "umbra", "prisma", "corpus", "mentis", "luxus", "chron", "sensus", "vita", "mortis", "ordo"]
var roots = lesser_roots + higher_roots

var prefixes = {
	"targeting": ["ma", "in", "ex"],
	"amplification": ["ka", "epi", "tri"],
	"control": ["ra", "su", "pa"],
	"utility": ["ve", "xo", "dis"]
}

var suffixes = {
	"power": ["lo", "ri", "sha"],
	"duration": ["len", "tan"],
	"effect_modifiers": ["nu", "dra", "via", "tos", "rum", "sol"]
}

# Constants for spell formatting
const SPELL_FORMATS = {
	"prefixes": "[wave amp=25.0 freq=3.0][color=purple]%s[/color][/wave]",
	"root": "[wave amp=50.0 freq=5.0][color=blue]%s[/color][/wave]",
	"suffixes": "[wave amp=25.0 freq=3.0][color=green]%s[/color][/wave]"
}

func format_spell_text() -> String:
	if not is_valid:
		return spell_input
	var formatted_text = spell_input
	spell_components["spell_input"] = spell_input
	
	# Handle arrays of prefixes and suffixes
	for prefix in spell_components["prefixes"]:
		if prefix.length() > 0:
			formatted_text = formatted_text.replace(
				prefix,
				SPELL_FORMATS["prefixes"] % prefix
			)
	
	# Handle single root
	if spell_components["root"].length() > 0:
		formatted_text = formatted_text.replace(
			spell_components["root"],
			SPELL_FORMATS["root"] % spell_components["root"]
		)
	
	# Handle arrays of suffixes
	for suffix in spell_components["suffixes"]:
		if suffix.length() > 0:
			formatted_text = formatted_text.replace(
				suffix,
				SPELL_FORMATS["suffixes"] % suffix
			)
	
	return formatted_text

func process_spell() -> bool:
	# Make a copy of the input to work with
	var remaining_text = spell_input
	
	# Track detected components for highlighting
	var detected_prefixes = []
	var detected_root = ""
	var detected_suffixes = []
	
	# Track used categories to ensure one prefix/suffix per category
	var used_prefix_categories = {}
	var used_suffix_categories = {}
	
	# Step 1: Detect prefixes
	var prefix_found = true
	while prefix_found and remaining_text.length() > 0:
		prefix_found = false
		for category in prefixes:
			if category in used_prefix_categories:
				continue  # Skip if category already used
				
			for prefix in prefixes[category]:
				if remaining_text.begins_with(prefix):
					detected_prefixes.append(prefix)
					spell_components["prefixes"].append(prefix)
					used_prefix_categories[category] = true
					remaining_text = remaining_text.substr(prefix.length())
					prefix_found = true
					break
	
	# Step 2: Detect root (mandatory)
	var root_found = false
	for root in roots:
		if remaining_text.begins_with(root):
			detected_root = root
			spell_components["root"] = root
			remaining_text = remaining_text.substr(root.length())
			root_found = true
			break
	
	if not root_found:
		return false  # No valid root found
	
	# Step 3: Detect suffixes
	while remaining_text.length() > 0:
		var suffix_found = false
		
		# Try to match a suffix
		for category in suffixes:
			if category in used_suffix_categories:
				continue  # Skip if category already used
				
			for suffix in suffixes[category]:
				if remaining_text.begins_with(suffix):
					detected_suffixes.append(suffix)
					spell_components["suffixes"].append(suffix)
					used_suffix_categories[category] = true
					remaining_text = remaining_text.substr(suffix.length())
					suffix_found = true
					break
			
			if suffix_found:
				break
		
		if not suffix_found:
			return false  # Unknown component found
		
		# If we've processed all remaining text, break the loop
		if remaining_text.length() == 0:
			break
	
	# All text should be consumed by valid components
	if remaining_text.length() > 0:
		return false
	
	return true
