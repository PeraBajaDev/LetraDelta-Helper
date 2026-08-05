extends RefCounted
class_name DialogueParser


static func parse(text: String) -> String:
	# \E[x]  emoción         \F[x]  cambio de personaje
	#    \M[x]  emoción special  \m[x]  mini face
	#    \f[x]  mini text        \T[x]  voz/sonido
	#    \c[x]  color Deltarune
	#    ~[n]   marcador de control/avance
	#    /      espera input     %      cierra mensaje    %%  cierra writer
	#  Modificables (no se valida cantidad):
	#    ^[1-9] pausa            &      newline
	var patterns: Array[String] = [
		r"\\E.",
		r"\\T.",
		r"\\M.",
		r"\\m.",
		r"\\F.",
		r"\\f.",
		r"\^[1-9]",
	]
	for pattern in patterns:
		var re := RegEx.create_from_string(pattern)
		var replaced_text := re.sub(text, "", true)
		text = replaced_text
	return text.replace("#", "\n").replace("&", "\n").replace("/", "")
