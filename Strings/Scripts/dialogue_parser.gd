class_name DialogueParser
extends RefCounted

const BACKTICK_IGNORE_PATTERN = r"(?<!`)"
# \E[x]  emoción         \F[x]  cambio de personaje
# \M[x]  emoción special  \m[x]  mini face
# \f[x]  mini text        \T[x]  voz/sonido
# \c[x]  color Deltarune
# ~[n]   marcador de control/avance
# /      espera input     %      cierra mensaje    %%  cierra writer
# Modificables (no se valida cantidad):
# ^[1-9] pausa
# &      newline
const _STRICT_TAGS: Array = [
	r"\\E(.)", # \E[x]
	r"\\M(.)", # \M[x]
	r"\\F(.)", # \F[x]
	r"\\m(.)", # \m[x]
	r"\\f(.)", # \f[x]
	r"\\T(.)", # \T[x]
	r"\\V(.)", # \V[x]
	r"\\C([1-9])", # \C[1-9]
	r"\\c(.)", # \c[x]
]

const _STRICT_SYMBOLS: Array = [
	"%%",
	"%",
	"/",
]

const _STRICT_INLINE_PATTERNS: Array[String] = [
	"~[0-9]+",
]

const _NON_STRICT_INLINE_PATTERNS: Array[String] = [r"\^[0-9]+"]

static var _strict_regexes_cache: Array[RegEx] = []

static var _sequence_regex_cache: RegEx = null


static func parse(text: String) -> String:
	for pattern in _STRICT_TAGS:
		var re := RegEx.create_from_string(BACKTICK_IGNORE_PATTERN + pattern)
		var replaced_text := re.sub(text, "", true)
		text = replaced_text
	for pattern in _NON_STRICT_INLINE_PATTERNS:
		var re := RegEx.create_from_string(BACKTICK_IGNORE_PATTERN + pattern)
		var replaced_text := re.sub(text, "", true)
		text = replaced_text
	for pattern in _STRICT_SYMBOLS:
		var re := RegEx.create_from_string(BACKTICK_IGNORE_PATTERN + pattern)
		var replaced_text := re.sub(text, "", true)
		text = replaced_text
	text = text.remove_char(ord("`"))
	return text.replace("#", "\n").replace("&", "\n")


static func validate_tags(original: String, translation: String) -> TagDiff:
	var diff := TagDiff.new()
	if original == "" and translation == "":
		return diff
	var original_counts: Dictionary = _count_tags(original)
	var translation_counts: Dictionary = _count_tags(translation)

	diff.has_any_tag = not original_counts.is_empty() or not translation_counts.is_empty()

	for tag: String in original_counts.keys():
		var original_count: int = original_counts[tag]
		var translation_count: int = translation_counts.get(tag, 0)
		if translation_count < original_count:
			var times: int = original_count - translation_count
			for i in range(times):
				diff.missing.append(tag)

	for tag: String in translation_counts.keys():
		var translation_count: int = translation_counts[tag]
		var original_count: int = original_counts.get(tag, 0)
		if translation_count > original_count:
			var times: int = translation_count - original_count
			for i in range(times):
				diff.extra.append(tag)

	if diff.missing.is_empty() and diff.extra.is_empty() and diff.has_any_tag:
		var orig_seq: PackedStringArray = _extract_tag_sequence(original)
		var trans_seq: PackedStringArray = _extract_tag_sequence(translation)
		if orig_seq != trans_seq:
			diff.order_mismatch = true

	diff.ok = diff.missing.is_empty() and diff.extra.is_empty() and not diff.order_mismatch
	return diff


static func _count_tags(value: String) -> Dictionary:
	var re_strip = RegEx.create_from_string(r"`.")
	var clean_string: String = re_strip.sub(value, "", true)
	var counts: Dictionary = { }

	var work: String = clean_string
	for symbol in _STRICT_SYMBOLS:
		var symbol_count: int = work.count(symbol)
		if symbol_count > 0:
			counts[symbol] = symbol_count
		work = work.replace(symbol, "")

	for pattern: String in _STRICT_INLINE_PATTERNS:
		var inline_re := RegEx.new()
		if inline_re.compile(pattern) != OK:
			continue
		for match: RegExMatch in inline_re.search_all(clean_string):
			var full: String = match.get_string(0)
			var current: int = counts.get_or_add(full, 0)
			counts[full] = current + 1

	for re: RegEx in _get_strict_regexes():
		var matches: Array[RegExMatch] = re.search_all(clean_string)
		for _m: RegExMatch in matches:
			var full: String = _m.get_string(0)

			if not counts.has(full):
				counts[full] = 0
			counts[full] += 1
	return counts


static func _get_strict_regexes() -> Array[RegEx]:
	if _strict_regexes_cache.is_empty():
		for tag in _STRICT_TAGS:
			var re := RegEx.new()

			var err: int = re.compile(str(tag))
			if err == OK:
				_strict_regexes_cache.append(re)
	return _strict_regexes_cache


static func _get_sequence_regex() -> RegEx:
	if _sequence_regex_cache == null:
		_sequence_regex_cache = RegEx.new()
		_sequence_regex_cache.compile(r"%%|\\C[1-9]|\\C|\\[EMFmfTVc].|~[0-9]+|%|/")
	return _sequence_regex_cache


static func _extract_tag_sequence(value: String) -> PackedStringArray:
	var re_strip = RegEx.create_from_string(r"`.")
	var clean_string: String = re_strip.sub(value, "", true)
	var result: PackedStringArray = PackedStringArray()
	var re: RegEx = _get_sequence_regex()
	for _m: RegExMatch in re.search_all(clean_string):
		result.append(_m.get_string(0))
	return result


class TagDiff extends RefCounted:
	var ok: bool = true
	var missing: PackedStringArray = PackedStringArray()
	var extra: PackedStringArray = PackedStringArray()
	var has_any_tag: bool = false
	var order_mismatch: bool = false


	func to_label_text() -> String:
		if ok:
			return "✓ Tags OK"
		var parts: PackedStringArray = PackedStringArray()
		if not missing.is_empty():
			parts.append("Missing: " + " ".join(missing))
		if not extra.is_empty():
			parts.append("Extra: " + " ".join(extra))
		if order_mismatch:
			parts.append("Wrong order")
		return "⚠ " + "  ·  ".join(parts)
