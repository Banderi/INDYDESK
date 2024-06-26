extends Node

var IS_INDY = true

var WORLD_ROOT = null
var UI_ROOT = null
var CAMERA = null

var FADE = null
func fadein():
	FADE.fade_target = -1
	yield(FADE,"fade_done")
func fadeout():
	FADE.fade_target = 1
	yield(FADE,"fade_done")
func is_fading():
	return FADE.fade_target != 0

func can_control_hero():
	if is_fading():
		return false
	if SPEECH_PLAYING != null:
		return false
	return true

func debug_tools_enabled():
	return false

const ANSI_ISO_8859_7 = [
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
	" ", "‘", "’", "£", "€", "₯", "¦", "§", "¨", "©", "ͺ", "«", "¬", "", "", "―",
	"°", "±", "²", "³", "΄", "΅", "Ά", "·", "Έ", "Ή", "Ί", "»", "Ό", "½", "Ύ", "Ώ",
	"ΐ", "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο",
	"Π", "Ρ", "", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω", "Ϊ", "Ϋ", "ά", "έ", "ή", "ί",
	"ΰ", "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο",
	"π", "ρ", "ς", "σ", "τ", "υ", "φ", "χ", "ψ", "ω", "ϊ", "ϋ", "ό", "ύ", "ώ", ""]
const ANSI_WINDOWS_1252 = [
	"€", "", "‚", "ƒ", "„", "…", "†", "‡", "ˆ", "‰", "Š", "‹", "Œ", "", "Ž", "",
	"", "‘", "’", "“", "”", "•", "–", "—", "˜", "™", "š", "›", "œ", "", "ž", "Ÿ",
	" ", "¡", "¢", "£", "¤", "¥", "¦", "§", "¨", "©", "ª", "«", "¬", "", "®", "¯",
	"°", "±", "²", "³", "´", "µ", "¶", "·", "¸", "¹", "º", "»", "¼", "½", "¾", "¿",
	"À", "Á", "Â", "Ã", "Ä", "Å", "Æ", "Ç", "È", "É", "Ê", "Ë", "Ì", "Í", "Î", "Ï",
	"Ð", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "×", "Ø", "Ù", "Ú", "Û", "Ü", "Ý", "Þ", "ß",
	"à", "á", "â", "ã", "ä", "å", "æ", "ç", "è", "é", "ê", "ë", "ì", "í", "î", "ï",
	"ð", "ñ", "ò", "ó", "ô", "õ", "ö", "÷", "ø", "ù", "ú", "û", "ü", "ý", "þ", "ÿ"]
func ansi_to_string(bytes : PoolByteArray):
	if bytes.size() == 0:
		return ""
	var text = bytes.get_string_from_ascii() # base string
	for b in bytes.size():
		var byte = bytes[b]
		if byte < 0x20: # ASCII control codes
			continue
		elif byte < 0x80: # normal printable characters (same as ASCII and UTF-8)  
			continue
		else: # extended ANSI characters
			text[b] = ANSI_WINDOWS_1252[byte - 0x80]
	return text
func round_vector(vector):
	vector.x = round(vector.x)
	vector.y = round(vector.y)
	return vector
func signed_u16(v):
	return -1 if v == 65535 else v

# Palettes
const PALETTE_INDY = [
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xD7, 0x00,
	0x00, 0x00, 0xB3, 0x00, 0x00, 0x00, 0x8B, 0x00, 0x00, 0x00, 0x67, 0x00, 0x00, 0x00, 0x43, 0x00,
	0xFB, 0xFB, 0xFB, 0x00, 0xE3, 0xE3, 0xE3, 0x00, 0xD3, 0xD3, 0xD3, 0x00, 0xC3, 0xC3, 0xC3, 0x00,
	0xB3, 0xB3, 0xB3, 0x00, 0xAB, 0xAB, 0xAB, 0x00, 0x9B, 0x9B, 0x9B, 0x00, 0x8B, 0x8B, 0x8B, 0x00,
	0x7B, 0x7B, 0x7B, 0x00, 0x73, 0x73, 0x73, 0x00, 0x63, 0x63, 0x63, 0x00, 0x53, 0x53, 0x53, 0x00,
	0x4B, 0x4B, 0x4B, 0x00, 0x3B, 0x3B, 0x3B, 0x00, 0x2B, 0x2B, 0x2B, 0x00, 0x23, 0x23, 0x23, 0x00,
	0x00, 0xC7, 0x43, 0x00, 0x00, 0xB7, 0x3F, 0x00, 0x00, 0xAB, 0x3F, 0x00, 0x00, 0x9F, 0x3B, 0x00,
	0x00, 0x93, 0x37, 0x00, 0x00, 0x87, 0x33, 0x00, 0x00, 0x7B, 0x33, 0x00, 0x00, 0x6F, 0x2F, 0x00,
	0x00, 0x63, 0x2B, 0x00, 0x00, 0x53, 0x23, 0x00, 0x00, 0x47, 0x1F, 0x00, 0x00, 0x37, 0x17, 0x00,
	0x00, 0x27, 0x0F, 0x00, 0x00, 0x1B, 0x0B, 0x00, 0x00, 0x0B, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x3B, 0xFB, 0x7B, 0x00, 0x6B, 0x7B, 0xC3, 0x00, 0x5B, 0x53, 0xAB, 0x00, 0x53, 0x43, 0x93, 0x00,
	0x53, 0x2B, 0x7B, 0x00, 0x4B, 0x1B, 0x63, 0x00, 0x3B, 0x13, 0x3B, 0x00, 0xAB, 0xD7, 0xFF, 0x00,
	0x8F, 0xC3, 0xF3, 0x00, 0x73, 0xB3, 0xE7, 0x00, 0x5B, 0xA3, 0xDB, 0x00, 0x43, 0x97, 0xCF, 0x00,
	0x2F, 0x8B, 0xC3, 0x00, 0x1B, 0x7F, 0xB7, 0x00, 0x0B, 0x73, 0xAF, 0x00, 0x00, 0x6B, 0xA3, 0x00,
	0xEB, 0xFF, 0xFF, 0x00, 0xD7, 0xF3, 0xF3, 0x00, 0xC7, 0xE7, 0xE7, 0x00, 0xB7, 0xDB, 0xDB, 0x00,
	0xA3, 0xCF, 0xCF, 0x00, 0x97, 0xC3, 0xC3, 0x00, 0x7F, 0xB3, 0xB3, 0x00, 0x63, 0xA3, 0xA3, 0x00,
	0x4F, 0x93, 0x93, 0x00, 0x3B, 0x83, 0x83, 0x00, 0x2B, 0x73, 0x73, 0x00, 0x1B, 0x5F, 0x5F, 0x00,
	0x0F, 0x4F, 0x4F, 0x00, 0x07, 0x3F, 0x3F, 0x00, 0x00, 0x2F, 0x2F, 0x00, 0x00, 0x1F, 0x1F, 0x00,
	0x5B, 0xFB, 0xD3, 0x00, 0x43, 0xFB, 0xC3, 0x00, 0x23, 0xFB, 0xB3, 0x00, 0x00, 0xFB, 0xA3, 0x00,
	0x00, 0xE3, 0x93, 0x00, 0x00, 0xCB, 0x83, 0x00, 0x00, 0xB3, 0x73, 0x00, 0x00, 0x9B, 0x63, 0x00,
	0x00, 0x5B, 0x8B, 0x00, 0x00, 0x4F, 0x77, 0x00, 0x00, 0x43, 0x67, 0x00, 0x00, 0x37, 0x57, 0x00,
	0x00, 0x2F, 0x47, 0x00, 0x00, 0x23, 0x37, 0x00, 0x00, 0x17, 0x27, 0x00, 0x00, 0x0F, 0x17, 0x00,
	0x00, 0xFB, 0x4F, 0x00, 0x00, 0xEF, 0x4B, 0x00, 0x00, 0xDF, 0x47, 0x00, 0x00, 0xD3, 0x47, 0x00,
	0x00, 0x9F, 0x67, 0x00, 0x00, 0x7F, 0x5B, 0x00, 0x00, 0x63, 0x43, 0x00, 0x00, 0x47, 0x27, 0x00,
	0x00, 0x2B, 0x1B, 0x00, 0x23, 0x23, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8B, 0x37, 0xDB, 0x00, 0x77, 0x2B, 0xB3, 0x00,
	0xFB, 0xFB, 0xDB, 0x00, 0xFB, 0xFB, 0xBB, 0x00, 0xFB, 0xFB, 0x9B, 0x00, 0xFB, 0xFB, 0x7B, 0x00,
	0xFB, 0xFB, 0x5B, 0x00, 0xFB, 0xFB, 0x43, 0x00, 0xFB, 0xFB, 0x23, 0x00, 0xFB, 0xFB, 0x00, 0x00,
	0xE3, 0xE3, 0x00, 0x00, 0xCB, 0xCB, 0x00, 0x00, 0xB3, 0xB3, 0x00, 0x00, 0x9B, 0x9B, 0x00, 0x00,
	0x83, 0x83, 0x00, 0x00, 0x73, 0x73, 0x00, 0x00, 0x5B, 0x5B, 0x00, 0x00, 0x43, 0x43, 0x00, 0x00,
	0xFF, 0xBF, 0x47, 0x00, 0xF7, 0xAF, 0x33, 0x00, 0xEF, 0xA3, 0x1F, 0x00, 0xE7, 0x97, 0x0F, 0x00,
	0xE3, 0x8B, 0x00, 0x00, 0xCB, 0x7B, 0x00, 0x00, 0xB3, 0x6B, 0x00, 0x00, 0x9B, 0x5B, 0x00, 0x00,
	0x7B, 0x47, 0x00, 0x00, 0x5F, 0x37, 0x00, 0x00, 0x43, 0x27, 0x00, 0x00, 0x27, 0x17, 0x00, 0x00,
	0xFB, 0x63, 0x5B, 0x00, 0xFB, 0x43, 0x43, 0x00, 0xFB, 0x23, 0x23, 0x00, 0xFB, 0x00, 0x00, 0x00,
	0xFB, 0x00, 0x00, 0x00, 0xDB, 0x00, 0x00, 0x00, 0xC3, 0x00, 0x00, 0x00, 0xAB, 0x00, 0x00, 0x00,
	0x8B, 0x00, 0x00, 0x00, 0x73, 0x00, 0x00, 0x00, 0x5B, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00,
	0xBF, 0xBB, 0xFB, 0x00, 0xAF, 0xAB, 0xF7, 0x00, 0xA3, 0x9B, 0xF3, 0x00, 0x97, 0x8F, 0xEF, 0x00,
	0x87, 0x7F, 0xEB, 0x00, 0x7F, 0x73, 0xE7, 0x00, 0x6B, 0x5B, 0xDF, 0x00, 0x47, 0x3B, 0xCB, 0x00,
	0xF7, 0xB3, 0x43, 0x00, 0xF7, 0xBB, 0x4F, 0x00, 0xF7, 0xC7, 0x5B, 0x00, 0xF7, 0xCF, 0x6B, 0x00,
	0xF7, 0xD7, 0x77, 0x00, 0xF7, 0xDF, 0x83, 0x00, 0xF7, 0xE7, 0x93, 0x00, 0xF7, 0xCF, 0x6B, 0x00,
	0x00, 0x43, 0xCB, 0x00, 0x00, 0x33, 0xBB, 0x00, 0x00, 0x23, 0xA3, 0x00, 0x00, 0x1B, 0x93, 0x00,
	0x00, 0x0B, 0x7B, 0x00, 0x00, 0x00, 0x6B, 0x00, 0x00, 0x00, 0x53, 0x00, 0x00, 0x00, 0x43, 0x00,
	0x00, 0xFF, 0xFF, 0x00, 0x00, 0xE3, 0xF7, 0x00, 0x00, 0xCF, 0xF3, 0x00, 0x00, 0xB7, 0xEF, 0x00,
	0x00, 0xA3, 0xEB, 0x00, 0x00, 0x8B, 0xE7, 0x00, 0x00, 0x77, 0xDF, 0x00, 0x00, 0x63, 0xDB, 0x00,
	0x00, 0x4F, 0xD7, 0x00, 0x00, 0x3F, 0xD3, 0x00, 0x00, 0x2F, 0xCF, 0x00, 0x77, 0xC7, 0xE3, 0x00,
	0x6B, 0xB7, 0xDB, 0x00, 0x63, 0xA7, 0xD3, 0x00, 0x5B, 0x97, 0xCB, 0x00, 0x53, 0x8B, 0xC3, 0x00,
	0xDB, 0xEB, 0xFB, 0x00, 0xD3, 0xE3, 0xFB, 0x00, 0xC3, 0xDB, 0xFB, 0x00, 0xBB, 0xD3, 0xFB, 0x00,
	0xB3, 0xCB, 0xFB, 0x00, 0xA3, 0xC3, 0xFB, 0x00, 0x9B, 0xBB, 0xFB, 0x00, 0x8F, 0xB7, 0xFB, 0x00,
	0x83, 0xB3, 0xFB, 0x00, 0x73, 0xA3, 0xFB, 0x00, 0x63, 0x9B, 0xFB, 0x00, 0x5B, 0x93, 0xF3, 0x00,
	0x5B, 0x8B, 0xEB, 0x00, 0x53, 0x8B, 0xDB, 0x00, 0x53, 0x83, 0xD3, 0x00, 0x4B, 0x7B, 0xCB, 0x00,
	0x4B, 0x7B, 0xBB, 0x00, 0x43, 0x73, 0xB3, 0x00, 0x43, 0x6B, 0xAB, 0x00, 0x3B, 0x63, 0xA3, 0x00,
	0x3B, 0x63, 0x9B, 0x00, 0x33, 0x5B, 0x93, 0x00, 0x33, 0x5B, 0x8B, 0x00, 0x2B, 0x53, 0x83, 0x00,
	0x2B, 0x4B, 0x73, 0x00, 0x23, 0x4B, 0x6B, 0x00, 0x23, 0x43, 0x5B, 0x00, 0x1B, 0x3B, 0x53, 0x00,
	0x1B, 0x3B, 0x4B, 0x00, 0x1B, 0x33, 0x43, 0x00, 0x13, 0x2B, 0x3B, 0x00, 0x0B, 0x23, 0x2B, 0x00,
	0x00, 0xAB, 0x6F, 0x00, 0x00, 0xA3, 0x6B, 0x00, 0x00, 0x9F, 0x67, 0x00, 0x00, 0xA3, 0x6B, 0x00,
	0x00, 0xAB, 0x6F, 0x00, 0xE7, 0x93, 0x07, 0x00, 0xE7, 0x97, 0x0F, 0x00, 0xEB, 0x9F, 0x17, 0x00,
	0xEF, 0xA3, 0x23, 0x00, 0xF3, 0xAB, 0x2B, 0x00, 0xF7, 0xB3, 0x37, 0x00, 0xEF, 0xA7, 0x27, 0x00,
	0xEB, 0x9F, 0x1B, 0x00, 0xE7, 0x97, 0x0F, 0x00, 0x0B, 0xCB, 0xFB, 0x00, 0x0B, 0xA3, 0xFB, 0x00,
	0x0B, 0x73, 0xFB, 0x00, 0x0B, 0x4B, 0xFB, 0x00, 0x0B, 0x23, 0xFB, 0x00, 0x0B, 0x73, 0xFB, 0x00,
	0x00, 0x13, 0x93, 0x00, 0x00, 0x0B, 0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00]
const PALETTE_YODA = [
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x8B, 0x00, 0xC3, 0xCF, 0x4B, 0x00, 
	0x8B, 0xA3, 0x1B, 0x00, 0x57, 0x77, 0x00, 0x00, 0x8B, 0xA3, 0x1B, 0x00, 0xC3, 0xCF, 0x4B, 0x00, 
	0xFB, 0xFB, 0xFB, 0x00, 0xEB, 0xE7, 0xE7, 0x00, 0xDB, 0xD3, 0xD3, 0x00, 0xCB, 0xC3, 0xC3, 0x00, 
	0xBB, 0xB3, 0xB3, 0x00, 0xAB, 0xA3, 0xA3, 0x00, 0x9B, 0x8F, 0x8F, 0x00, 0x8B, 0x7F, 0x7F, 0x00, 
	0x7B, 0x6F, 0x6F, 0x00, 0x67, 0x5B, 0x5B, 0x00, 0x57, 0x4B, 0x4B, 0x00, 0x47, 0x3B, 0x3B, 0x00, 
	0x33, 0x2B, 0x2B, 0x00, 0x23, 0x1B, 0x1B, 0x00, 0x13, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0xC7, 0x43, 0x00, 0x00, 0xB7, 0x43, 0x00, 0x00, 0xAB, 0x3F, 0x00, 0x00, 0x9F, 0x3F, 0x00, 
	0x00, 0x93, 0x3F, 0x00, 0x00, 0x87, 0x3B, 0x00, 0x00, 0x7B, 0x37, 0x00, 0x00, 0x6F, 0x33, 0x00, 
	0x00, 0x63, 0x33, 0x00, 0x00, 0x53, 0x2B, 0x00, 0x00, 0x47, 0x27, 0x00, 0x00, 0x3B, 0x23, 0x00, 
	0x00, 0x2F, 0x1B, 0x00, 0x00, 0x23, 0x13, 0x00, 0x00, 0x17, 0x0F, 0x00, 0x00, 0x0B, 0x07, 0x00, 
	0x4B, 0x7B, 0xBB, 0x00, 0x43, 0x73, 0xB3, 0x00, 0x43, 0x6B, 0xAB, 0x00, 0x3B, 0x63, 0xA3, 0x00, 
	0x3B, 0x63, 0x9B, 0x00, 0x33, 0x5B, 0x93, 0x00, 0x33, 0x5B, 0x8B, 0x00, 0x2B, 0x53, 0x83, 0x00, 
	0x2B, 0x4B, 0x73, 0x00, 0x23, 0x4B, 0x6B, 0x00, 0x23, 0x43, 0x5F, 0x00, 0x1B, 0x3B, 0x53, 0x00, 
	0x1B, 0x37, 0x47, 0x00, 0x1B, 0x33, 0x43, 0x00, 0x13, 0x2B, 0x3B, 0x00, 0x0B, 0x23, 0x2B, 0x00, 
	0xD7, 0xFF, 0xFF, 0x00, 0xBB, 0xEF, 0xEF, 0x00, 0xA3, 0xDF, 0xDF, 0x00, 0x8B, 0xCF, 0xCF, 0x00, 
	0x77, 0xC3, 0xC3, 0x00, 0x63, 0xB3, 0xB3, 0x00, 0x53, 0xA3, 0xA3, 0x00, 0x43, 0x93, 0x93, 0x00, 
	0x33, 0x87, 0x87, 0x00, 0x27, 0x77, 0x77, 0x00, 0x1B, 0x67, 0x67, 0x00, 0x13, 0x5B, 0x5B, 0x00, 
	0x0B, 0x4B, 0x4B, 0x00, 0x07, 0x3B, 0x3B, 0x00, 0x00, 0x2B, 0x2B, 0x00, 0x00, 0x1F, 0x1F, 0x00, 
	0xDB, 0xEB, 0xFB, 0x00, 0xD3, 0xE3, 0xFB, 0x00, 0xC3, 0xDB, 0xFB, 0x00, 0xBB, 0xD3, 0xFB, 0x00, 
	0xB3, 0xCB, 0xFB, 0x00, 0xA3, 0xC3, 0xFB, 0x00, 0x9B, 0xBB, 0xFB, 0x00, 0x8F, 0xB7, 0xFB, 0x00, 
	0x83, 0xB3, 0xF7, 0x00, 0x73, 0xA7, 0xFB, 0x00, 0x63, 0x9B, 0xFB, 0x00, 0x5B, 0x93, 0xF3, 0x00, 
	0x5B, 0x8B, 0xEB, 0x00, 0x53, 0x8B, 0xDB, 0x00, 0x53, 0x83, 0xD3, 0x00, 0x4B, 0x7B, 0xCB, 0x00, 
	0x9B, 0xC7, 0xFF, 0x00, 0x8F, 0xB7, 0xF7, 0x00, 0x87, 0xB3, 0xEF, 0x00, 0x7F, 0xA7, 0xF3, 0x00, 
	0x73, 0x9F, 0xEF, 0x00, 0x53, 0x83, 0xCF, 0x00, 0x3B, 0x6B, 0xB3, 0x00, 0x2F, 0x5B, 0xA3, 0x00, 
	0x23, 0x4F, 0x93, 0x00, 0x1B, 0x43, 0x83, 0x00, 0x13, 0x3B, 0x77, 0x00, 0x0B, 0x2F, 0x67, 0x00, 
	0x07, 0x27, 0x57, 0x00, 0x00, 0x1B, 0x47, 0x00, 0x00, 0x13, 0x37, 0x00, 0x00, 0x0F, 0x2B, 0x00, 
	0xFB, 0xFB, 0xE7, 0x00, 0xF3, 0xF3, 0xD3, 0x00, 0xEB, 0xE7, 0xC7, 0x00, 0xE3, 0xDF, 0xB7, 0x00, 
	0xDB, 0xD7, 0xA7, 0x00, 0xD3, 0xCF, 0x97, 0x00, 0xCB, 0xC7, 0x8B, 0x00, 0xC3, 0xBB, 0x7F, 0x00, 
	0xBB, 0xB3, 0x73, 0x00, 0xAF, 0xA7, 0x63, 0x00, 0x9B, 0x93, 0x47, 0x00, 0x87, 0x7B, 0x33, 0x00, 
	0x6F, 0x67, 0x1F, 0x00, 0x5B, 0x53, 0x0F, 0x00, 0x47, 0x43, 0x00, 0x00, 0x37, 0x33, 0x00, 0x00, 
	0xFF, 0xF7, 0xF7, 0x00, 0xEF, 0xDF, 0xDF, 0x00, 0xDF, 0xC7, 0xC7, 0x00, 0xCF, 0xB3, 0xB3, 0x00, 
	0xBF, 0x9F, 0x9F, 0x00, 0xB3, 0x8B, 0x8B, 0x00, 0xA3, 0x7B, 0x7B, 0x00, 0x93, 0x6B, 0x6B, 0x00, 
	0x83, 0x57, 0x57, 0x00, 0x73, 0x4B, 0x4B, 0x00, 0x67, 0x3B, 0x3B, 0x00, 0x57, 0x2F, 0x2F, 0x00, 
	0x47, 0x27, 0x27, 0x00, 0x37, 0x1B, 0x1B, 0x00, 0x27, 0x13, 0x13, 0x00, 0x1B, 0x0B, 0x0B, 0x00, 
	0xF7, 0xB3, 0x37, 0x00, 0xE7, 0x93, 0x07, 0x00, 0xFB, 0x53, 0x0B, 0x00, 0xFB, 0x00, 0x00, 0x00, 
	0xCB, 0x00, 0x00, 0x00, 0x9F, 0x00, 0x00, 0x00, 0x6F, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 
	0xBF, 0xBB, 0xFB, 0x00, 0x8F, 0x8B, 0xFB, 0x00, 0x5F, 0x5B, 0xFB, 0x00, 0x93, 0xBB, 0xFF, 0x00, 
	0x5F, 0x97, 0xF7, 0x00, 0x3B, 0x7B, 0xEF, 0x00, 0x23, 0x63, 0xC3, 0x00, 0x13, 0x53, 0xB3, 0x00, 
	0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xEF, 0x00, 0x00, 0x00, 0xE3, 0x00, 0x00, 0x00, 0xD3, 0x00, 
	0x00, 0x00, 0xC3, 0x00, 0x00, 0x00, 0xB7, 0x00, 0x00, 0x00, 0xA7, 0x00, 0x00, 0x00, 0x9B, 0x00, 
	0x00, 0x00, 0x8B, 0x00, 0x00, 0x00, 0x7F, 0x00, 0x00, 0x00, 0x6F, 0x00, 0x00, 0x00, 0x63, 0x00, 
	0x00, 0x00, 0x53, 0x00, 0x00, 0x00, 0x47, 0x00, 0x00, 0x00, 0x37, 0x00, 0x00, 0x00, 0x2B, 0x00, 
	0x00, 0xFF, 0xFF, 0x00, 0x00, 0xE3, 0xF7, 0x00, 0x00, 0xCF, 0xF3, 0x00, 0x00, 0xB7, 0xEF, 0x00, 
	0x00, 0xA3, 0xEB, 0x00, 0x00, 0x8B, 0xE7, 0x00, 0x00, 0x77, 0xDF, 0x00, 0x00, 0x63, 0xDB, 0x00, 
	0x00, 0x4F, 0xD7, 0x00, 0x00, 0x3F, 0xD3, 0x00, 0x00, 0x2F, 0xCF, 0x00, 0x97, 0xFF, 0xFF, 0x00, 
	0x83, 0xDF, 0xEF, 0x00, 0x73, 0xC3, 0xDF, 0x00, 0x5F, 0xA7, 0xCF, 0x00, 0x53, 0x8B, 0xC3, 0x00, 
	0x2B, 0x2B, 0x00, 0x00, 0x23, 0x23, 0x00, 0x00, 0x1B, 0x1B, 0x00, 0x00, 0x13, 0x13, 0x00, 0x00, 
	0xFF, 0x0B, 0x00, 0x00, 0xFF, 0x00, 0x4B, 0x00, 0xFF, 0x00, 0xA3, 0x00, 0xFF, 0x00, 0xFF, 0x00, 
	0x00, 0xFF, 0x00, 0x00, 0x00, 0x4B, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0x33, 0x2F, 0x00, 
	0x00, 0x00, 0xFF, 0x00, 0x00, 0x1F, 0x97, 0x00, 0xDF, 0x00, 0xFF, 0x00, 0x73, 0x00, 0x77, 0x00, 
	0x6B, 0x7B, 0xC3, 0x00, 0x57, 0x57, 0xAB, 0x00, 0x57, 0x47, 0x93, 0x00, 0x53, 0x37, 0x7F, 0x00, 
	0x4F, 0x27, 0x67, 0x00, 0x47, 0x1B, 0x4F, 0x00, 0x3B, 0x13, 0x3B, 0x00, 0x27, 0x77, 0x77, 0x00, 
	0x23, 0x73, 0x73, 0x00, 0x1F, 0x6F, 0x6F, 0x00, 0x1B, 0x6B, 0x6B, 0x00, 0x1B, 0x67, 0x67, 0x00, 
	0x1B, 0x6B, 0x6B, 0x00, 0x1F, 0x6F, 0x6F, 0x00, 0x23, 0x73, 0x73, 0x00, 0x27, 0x77, 0x77, 0x00, 
	0xFF, 0xFF, 0xEF, 0x00, 0xF7, 0xF7, 0xDB, 0x00, 0xF3, 0xEF, 0xCB, 0x00, 0xEF, 0xEB, 0xBB, 0x00, 
	0xF3, 0xEF, 0xCB, 0x00, 0xE7, 0x93, 0x07, 0x00, 0xE7, 0x97, 0x0F, 0x00, 0xEB, 0x9F, 0x17, 0x00, 
	0xEF, 0xA3, 0x23, 0x00, 0xF3, 0xAB, 0x2B, 0x00, 0xF7, 0xB3, 0x37, 0x00, 0xEF, 0xA7, 0x27, 0x00, 
	0xEB, 0x9F, 0x1B, 0x00, 0xE7, 0x97, 0x0F, 0x00, 0x0B, 0xCB, 0xFB, 0x00, 0x0B, 0xA3, 0xFB, 0x00, 
	0x0B, 0x73, 0xFB, 0x00, 0x0B, 0x4B, 0xFB, 0x00, 0x0B, 0x23, 0xFB, 0x00, 0x0B, 0x73, 0xFB, 0x00, 
	0x00, 0x13, 0x93, 0x00, 0x00, 0x0B, 0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00]

# Game enums
enum Zones {
	None = 0
	Empty = 1
	Blockade_North = 2
	Blockade_South = 3
	Blockade_East = 4
	Blockade_West = 5
	TravelStart = 6
	TravelEnd = 7
	Room = 8
	Load = 9
	Goal = 10
	Town = 11
	UNUSED12 = 12
	Win = 13
	Lose = 14
	Trade = 15
	Use = 16
	Find = 17
	Find_Weapon = 18}
enum Hotspots {
	drop_quest_item = 0
	spawn_location = 1
	drop_unique_weapon = 2
	vehicle_to = 3
	vehicle_back = 4
	drop_map = 5
	drop_item = 6
	npc = 7
	drop_weapon = 8
	door_in = 9
	door_out = 10
	UNUSED11 = 11
	lock = 12
	teleporter = 13
	ship_to_planet = 14
	ship_from_planet = 15}
enum TileFlags {
	has_transparency = 1 << 0
	is_floor = 1 << 1
	is_wall = 1 << 2
	is_draggable = 1 << 3
	is_roof = 1 << 4
	is_locator = 1 << 5
	is_weapon = 1 << 6
	is_item = 1 << 7
	is_character = 1 << 8
	UNK9 = 1 << 9
	UNK10 = 1 << 10
	UNK11 = 1 << 11
	UNK12 = 1 << 12
	UNK13 = 1 << 13
	UNK14 = 1 << 14
	UNK15 = 1 << 15
	
	# floors
	is_doorway = 1 << 16					# stairs, hutdoor, hutstairs, bridge, rivercrossing, walldoor, pyramidstairs_left&right
	
	# characters
	is_hero = 1 << 16						# indy
	is_enemy = 1 << 17						# npc493-508 (monsters)
	is_npc = 1 << 18						# npc92, npc154, alien, npc229, npc458-462, npc484-492, indyleft
	
	# tiles / map
	is_empty = 1 << 16
	is_town = 1 << 17
	is_unsolved_puzzle = 1 << 18
	is_solved_puzzle = 1 << 19
	is_unsolved_travel = 1 << 20
	is_solved_travel = 1 << 21
	is_unsolved_blockade_north = 1 << 22
	is_unsolved_blockade_south = 1 << 23
	is_unsolved_blockade_west = 1 << 24
	is_unsolved_blockade_east = 1 << 25
	is_solved_blockade_north = 1 << 26
	is_solved_blockade_south = 1 << 27
	is_solved_blockade_west = 1 << 28
	is_solved_blockade_east = 1 << 29
	is_end_zone = 1 << 30
	is_location_indicator = 1 << 31
	
	# items
	is_keycard = 1 << 16					# key
	is_tool = 1 << 17						# dynamite, bucket, shovel, spear, gasoline
	is_part = 1 << 18						# gearwheel, shield?, woodplanks
	is_valuable = 1 << 19					# treasuremap, coins, aztec71, bluesnake, aztecwheel, aztecmask, bluemask, bluedagger, jadeidol, skull, birdhead, sallet, stonetablet, obspear, skull2
	is_map = 1 << 20
	is_harmful = 1 << 21					# tequila
	is_edible = 1 << 22						# yerba_buena, medikit, bananas
	
	# weapons
	is_luger = 1 << 16						# luger, bullet
	is_arrow = 1 << 17
	is_machete = 1 << 18
	is_whip = 1 << 19}
enum CharacterType {
	hero = 1
	enemy = 2
	weapon = 4}
enum MovementType {
	none = 0
	sit = 4
	wander = 9
	patrol = 10
	animation = 12}
func value_list_flags(value, enums):
	var flags = []
	var enum_names = enums.keys()
	for enm in enum_names:
		var e = enums[enm]
		if value & e:
			flags.push_back(enm)
	return flags

# Game data loading
var GLOBAL_VAR = null
var CONST_DATA = {
	"splash": null,
	"sounds": [], # 0 K:\GAME\TEST\SCHWING.WAV
#					1 C:\INDY\MASTER\PUSH.WAV
#					2 C:\INDY\MASTER\SWITCH.WAV
#					3 C:\INDY\MASTER\SHPOONK.WAV
#					4 C:\INDY\MASTER\INDYHURT.WAV
#					5 C:\INDY\MASTER\ROAR.WAV
#					6 C:\INDY\MASTER\DOOR.WAV
#					7 K:\GAME\TEST\EXPLODE.WAV
#					8 C:\INDY\MASTER\NOGO.WAV
#					9 C:\INDY\MASTER\WHIP.WAV
#					10 C:\INDY\MASTER\GUNSHOT.WAV
#					11 C:\DESKFUN\GAMEEXE\MACHETE.WAV
#					12 C:\INDY\MASTER\SPEAR.WAV
#					13 C:\DESKFUN\GAMEEXE\ARROW.WAV
#					14 C:\INDY\MASTER\FLOURISH.MID
#					15 K:\GAME\TEST\THEME.MID
#					16 C:\INDY\MASTER\DEFEAT.MID
#					17 C:\INDY\MASTER\VICTORY.MID
	"tiles": [],
	"zones": [],
	"puzzles": [],
	"characters": {},
	"weapons": [],
}
func assert_marker(marker, size = 4):
	var found = FILE.get_buffer(size).get_string_from_ascii()
	if OS.is_debug_build():
		assert(found == marker)
	else:
		if found != marker:
			Log.error(null,GlobalScope.Error.ERR_INVALID_DATA,"Found incorrect marker at %0x08X - expected '%s', found '%s'"%[
				FILE.get_position() - size,
				marker,
				found])
			get_tree().quit()

var FILE = DataFile.new()
func load_daw(file_path):
	var r = FILE.open(file_path, File.READ)
	if r != OK:
		Log.error(null,r,"could not load DAW file!")
	
	FILE.seek(4)
	CONST_DATA["VERS"] = FILE.get_32()
	Log.generic(null,"'VERS' at 0x00000000: %d" % [CONST_DATA["VERS"]])
	
	while !FILE.end_reached():
		var offset = FILE.get_position()
		var s_name = DataStruct.as_text(FILE.read("str4"))
		var s_size = FILE.get_32()
		var end_of_section = FILE.get_position() + s_size
		Log.generic(null,"'%s' at 0x%08X: %d bytes" % [s_name, offset, s_size])
		match s_name:
			"STUP": # splash screen
				CONST_DATA.splash = FILE.get_buffer(s_size)
			"SNDS": # sound files namess
				var _unk_num = FILE.get_16()
				while FILE.get_position() < end_of_section:
					var subs_size = FILE.get_16()
					var original_path = FILE.get_buffer(subs_size).get_string_from_ascii()
					var snd_filename = Array(original_path.split("\\")).pop_back()
					CONST_DATA.sounds.push_back(snd_filename)
			"TILE": # tile bitmaps
				while FILE.get_position() < end_of_section:
					CONST_DATA.tiles.push_back({
						"name": "",
						"flags": FILE.get_32(),
						"bmp": FILE.get_buffer(1024)
					})
					var tile_id = CONST_DATA.tiles.size() - 1
					if CONST_DATA.tiles[tile_id].flags & TileFlags.is_weapon:
						CONST_DATA.weapons.push_back(tile_id)
			"ZONE": # zones data
				for i in FILE.get_16():
					assert_marker("IZON")
					var _subs_size = FILE.get_32()
					var z_width = FILE.get_16()
					var z_height = FILE.get_16()
					var z_type = FILE.get_32()
					var z_total_tiles = z_width * z_height
					var z_tiles = []
					for _t in z_total_tiles:
						z_tiles.push_back([
							signed_u16(FILE.get_16()),
							signed_u16(FILE.get_16()),
							signed_u16(FILE.get_16()),
						])
					CONST_DATA.zones.push_back({
						"name": "",
						"width": z_width,
						"height": z_height,
						"type": z_type,
						"tiles": z_tiles,
						
						"unkn_zaux": null,
						"monsters": [],
						"required_items": [],
						
						"reward_items": [],
						"npcs": [],
						"izx4": [],
						
						"hotspots": [],
						"puzzle": -1,
						"actions": [],
						
						"variable": 0,
						"random": 0,
					})
					if FILE.get_position() > end_of_section:
						break
			"ZAUX": # monsters, required items
				for i in CONST_DATA.zones.size():
					assert_marker("IZAX")
					var _subs_size = FILE.get_32()
					CONST_DATA.zones[i].unkn_zaux = FILE.get_16() # seems to correlate with monsters present in zone
					for _i in FILE.get_16():
						CONST_DATA.zones[i].monsters.push_back({
							"id": FILE.get_16(),
							"x": signed_u16(FILE.get_16()),
							"y": signed_u16(FILE.get_16()),
						})
					for _i in FILE.get_16():
						CONST_DATA.zones[i].required_items.push_back(FILE.get_16())
			"ZAX2": # reward items
				for i in CONST_DATA.zones.size():
					assert_marker("IZX2")
					var _subs_size = FILE.get_32()
					for _i in FILE.get_16():
						CONST_DATA.zones[i].reward_items.push_back(FILE.get_16())
			"ZAX3": # npcs
				for i in CONST_DATA.zones.size():
					assert_marker("IZX3")
					var _subs_size = FILE.get_32()
					for _i in FILE.get_16():
						CONST_DATA.zones[i].npcs.push_back(FILE.get_16())
			"ZAX4": # ??? ALL of these are... [1, 0] apparently?
				for i in CONST_DATA.zones.size():
					assert_marker("IZX4")
					var subs_size = FILE.get_32()
					var subs_data = FILE.get_buffer(subs_size)
					CONST_DATA.zones[i].izx4.push_back(subs_data)
			"HTSP": # hotspots (triggers)
				while FILE.get_position() < end_of_section:
					var zone_id = FILE.get_16()
					if zone_id == 65535:
						break
					for _i in FILE.get_16():
						CONST_DATA.zones[zone_id].hotspots.push_back({
							"type": FILE.get_32(),
							"x": FILE.get_16(),
							"y": FILE.get_16(),
							"enabled": FILE.get_16(),
							"args": FILE.get_16(),
						})
			"ACTN": # action scripts
				while FILE.get_position() < end_of_section:
					var zone_id = FILE.get_16()
					if zone_id == 65535:
						break
					for _a in FILE.get_16():
						assert_marker("IACT")
						var _subs_size = FILE.get_32()
						var action_data = {
							"name": "",
							"enabled": true,
							"conditions": [],
							"instructions": [],
						}
						for _c in FILE.get_16(): # conditions
							var condition = {
								"opcode": FILE.get_16(),
								"args": [
									FILE.get_16(),
									FILE.get_16(),
									FILE.get_16(),
									FILE.get_16(),
									FILE.get_16(),
								],
								"met": false
							}
							var text_length = FILE.get_16()
							condition["text"] = ansi_to_string(FILE.get_buffer(text_length))
							action_data.conditions.push_back(condition)
						for _i in FILE.get_16(): # instructions
							var instruction = {
								"opcode": FILE.get_16(),
								"args": [
									FILE.get_16(),
									FILE.get_16(),
									FILE.get_16(),
									FILE.get_16(),
									FILE.get_16(),
								],
							}
							var text_length = FILE.get_16()
							instruction["text"] = ansi_to_string(FILE.get_buffer(text_length))
							action_data.instructions.push_back(instruction)
						CONST_DATA.zones[zone_id].actions.push_back(action_data)
			"PUZ2": # puzzles
				while FILE.get_position() < end_of_section:
					var zone_id = FILE.get_16()
					if zone_id == 65535:
						break
					assert_marker("IPUZ")
					var subs_size = FILE.get_32()
					CONST_DATA.puzzles.push_back({
						"name": "",
						"type": FILE.get_32(),
						"item1_class": FILE.get_32(),
						"item2_class": FILE.get_32(),
						"ipuz_strings": FILE.get_buffer(subs_size - 16).get_string_from_ascii(),
						"item1": FILE.get_16(),
						"item2": FILE.get_16()
					})
					CONST_DATA.zones[zone_id].puzzle = CONST_DATA.puzzles.size() - 1
			"CHAR": # characters
				while FILE.get_position() < end_of_section:
					var char_id = FILE.get_16()
					if char_id == 65535:
						break
					assert_marker("ICHA")
					var _subs_size = FILE.get_32()
					var c_name = FILE.get_buffer(16).get_string_from_ascii()
					var data = {
						"name": c_name,
						"type": FILE.get_16(),
						"movement_type": FILE.get_16(),
						"sprites1": [
							# DIRECTIONS (corner): NW NE SW SE
							# DIRECTIONS (side): S W N E
							FILE.get_16(),	# N ^
							FILE.get_16(),	# S v
							FILE.get_16(),	# N ^
							FILE.get_16(),	# W <
							FILE.get_16(),	# W <
							FILE.get_16(),	# N ^
							FILE.get_16(),	# E >
							FILE.get_16()	# E >
						],
						"sprites2": [
							# frame 1
							FILE.get_16(),	# N ^
							FILE.get_16(),	# S v
							FILE.get_16(),	# N ^
							FILE.get_16(),	# W <
							FILE.get_16(),	# W <
							FILE.get_16(),	# N ^
							FILE.get_16(),	# E >
							FILE.get_16(),	# E >
							
							# frame 2
							FILE.get_16(),	# N ^
							FILE.get_16(),	# S v
							FILE.get_16(),	# N ^
							FILE.get_16(),	# W <
							FILE.get_16(),	# W <
							FILE.get_16(),	# N ^
							FILE.get_16(),	# E >
							FILE.get_16(),	# E >
						],
						"sprites": HERO_SPRITESHEET if c_name == "HERO" else SpriteFrames.new(),
						
						"weapon_refid": null,
						"weapon_health": null,
						"damage": null,
					}
					for f in 8:
						data.sprites1[f] = signed_u16(data.sprites1[f])
					for f in 16:
						data.sprites2[f] = signed_u16(data.sprites2[f])
					CONST_DATA.characters[char_id] = data
			"CHWP": # weapons
				while FILE.get_position() < end_of_section:
					var char_id = FILE.get_16()
					if char_id == 65535:
						break
					CONST_DATA.characters[char_id].weapon_refid = FILE.get_16() # id of weapon "character" if monster, or id of attack sound if weapon
					CONST_DATA.characters[char_id].weapon_health = FILE.get_16()
			"CAUX": # monster damage
				while FILE.get_position() < end_of_section:
					var char_id = FILE.get_16()
					if char_id == 65535:
						break
					CONST_DATA.characters[char_id].damage = FILE.get_16()
			"TNAM": # tiles names
				while FILE.get_position() < end_of_section:
					var tile_id = FILE.get_16()
					if tile_id == 65535:
						break
					CONST_DATA.tiles[tile_id].name = FILE.get_buffer(16).get_string_from_ascii()
			"ZNAM": # zones names
				while FILE.get_position() < end_of_section:
					var zone_id = FILE.get_16()
					if zone_id == 65535:
						break
					CONST_DATA.zones[zone_id].name = FILE.get_buffer(16).get_string_from_ascii()
			"PNAM": # puzzles names
				var num_subs = FILE.get_16()
				for puzzle_id in num_subs:
					CONST_DATA.puzzles[puzzle_id].name = FILE.get_buffer(16).get_string_from_ascii()
					if FILE.get_position() > end_of_section:
						break
			"ANAM": # action scripts names
				while FILE.get_position() < end_of_section:
					var zone_id = FILE.get_16()
					if zone_id == 65535:
						break
					while true:
						var action_id = FILE.get_16()
						if action_id == 65535:
							break
						CONST_DATA.zones[zone_id].actions[action_id].name = FILE.get_buffer(16).get_string_from_ascii()
			"ENDF":
				assert(s_size == 0)
	Log.generic(null,"DAW file loaded sucessfully!")
	
	var h = 0
	for z in CONST_DATA.zones.size():
		var zone = CONST_DATA.zones[z]
		for hotspot in zone.hotspots:
			h += 1
			if h == 449:
				pass
	print("hotspots:", h)
		
#	for p in CONST_DATA:
#		if CONST_DATA[p] is Array || CONST_DATA[p] is Dictionary:
#			print(p, ": ", CONST_DATA[p].size())
	
	return
	
	for z in CONST_DATA.zones.size():
#	for z in [120]:
#	for z in [333]:
		var zone = CONST_DATA.zones[z]
		for a in zone.actions.size():
			var action = zone.actions[a]
			
#			if action.name != "Hint1":
#			if action.name != "floatboat":
#				continue
#			var printthis = false
#			for instruction in action.instructions:
##				if instruction.opcode == InstrINDY.set_variable:
#				if instruction.opcode == 0xe:
##				if instruction.args[0] == 2:
#					printthis = true
#			if !printthis:
#				continue
				
#			for condition in action.conditions:
###				if condition.opcode == 0xd:
##				if action.name == "Hint1":
###					var strf = (condition.args as PoolByteArray).get_string_from_ascii()
###					print("%16s %16s %20s (%s)"%[action.name,condition.text,condition.args,strf])
##					print("%16s %d %16s O: 0x%02X (%s)"%[zone.name,z,action.name,condition.opcode,condition.args])
#				print("%3d_%-13s %2d_%-13s O: %s (%s)"%[z,zone.name,a,action.name,Log.get_enum_string(CondINDY, condition.opcode),condition.args])
			for instruction in action.instructions:
#				if action.conditions[0].opcode == 0xe:
#				if action.name == "Hint1":
#				if action.name == "floatboat":
				if instruction.opcode == 0xf:
#				if instruction.args[0] == 2:
#					print("%16s %d %16s I: 0x%02X (%s)"%[zone.name,z,action.name,instruction.opcode,instruction.args])
					print("%3d_%-13s %2d_%-13s I: %s (%s)"%[z,zone.name,a,action.name,Log.get_enum_string(InstrINDY, instruction.opcode),instruction.args])

# Textures
onready var IMAGE_BUFFER = Image.new()
func texture_from_data(data, width, height, palette):
	IMAGE_BUFFER.create(width, height, false, Image.FORMAT_RGBA8)
	IMAGE_BUFFER.lock()
	for y in height:
		for x in width:
			var pixel_index = y * width + x
			var pixel_raw = data[pixel_index]
			if pixel_raw == 0:
				IMAGE_BUFFER.set_pixel(x, y, Color(1,1,1,0))
			else:
				var r = float(palette[pixel_raw*4+2]) / 255.0
				var g = float(palette[pixel_raw*4+1]) / 255.0
				var b = float(palette[pixel_raw*4+0]) / 255.0
				IMAGE_BUFFER.set_pixel(x, y, Color(r,g,b,1))
	IMAGE_BUFFER.unlock()
	var texture = ImageTexture.new()
	texture.create_from_image(IMAGE_BUFFER)
	return texture
func save_texture(texture : ImageTexture, path):
	return texture.get_data().save_png(path)
func load_splashscreen(splash_screen):
	splash_screen.texture = texture_from_data(CONST_DATA.splash, 288, 288, PALETTE_INDY)
	Log.generic(null,"Splash-screen loaded!")

# Sprites
onready var HERO_SPRITESHEET = SpriteFrames.new()
onready var ATTACK_SPRITESHEET = SpriteFrames.new()
func get_sprite(i):
	if i == -1:
		return
	return load("res://assets/indy/tile"+str(i)+".png")
func generate_tileset(tile_set : TileSet):
	tile_set.clear()
	for i in CONST_DATA.tiles.size():
		tile_set.create_tile(i)
		tile_set.tile_set_texture(i,get_sprite(i))
	Log.generic(null,"Tileset generated sucessfully!")
func sprite_add_anim(spritesheet : SpriteFrames, anim_name : String, frames_list : Array, frames : Array):
	if spritesheet.has_animation(anim_name):
		spritesheet.remove_animation(anim_name)
	spritesheet.add_animation(anim_name)
	spritesheet.set_animation_speed(anim_name, 6.0)
	for f in frames:
		spritesheet.add_frame(anim_name,get_sprite(frames_list[f]))
func sprite_add_4way_anim(spritesheet : SpriteFrames, anim_name : String, frames_list : Array, frames_N : Array, frames_S : Array, frames_W : Array, frames_E : Array):
	sprite_add_anim(spritesheet, str(anim_name,"_N"), frames_list, frames_N)
	sprite_add_anim(spritesheet, str(anim_name,"_S"), frames_list, frames_S)
	sprite_add_anim(spritesheet, str(anim_name,"_W"), frames_list, frames_W)
	sprite_add_anim(spritesheet, str(anim_name,"_E"), frames_list, frames_E)
func generate_spritesheets():
	for char_id in CONST_DATA.characters:
		var character = CONST_DATA.characters[char_id]
		var c_name = character.name
		var spritesheet = character.sprites
		match character.type:
			CharacterType.hero, CharacterType.enemy:
				sprite_add_4way_anim(spritesheet, "idle", character.sprites1, [0], [1], [3], [6])
				if character.sprites2[0] != -1:
					sprite_add_4way_anim(spritesheet, "walk", character.sprites2, [0,8], [1,9], [3,11], [6,14])
			CharacterType.weapon:
				if character.sprites1[7] != -1: # "inventory" sprite
					sprite_add_anim(spritesheet, "item", character.sprites1, [7])
				if character.sprites1[0] != -1:
					sprite_add_4way_anim(spritesheet, "projectile", character.sprites1, [0], [1], [3], [6])
				if character.sprites2[0] != -1:
					# fix for WhipWeapon missing sprite:
					if c_name == "WhipWeapon":
						character.sprites2[2] = 480
					sprite_add_4way_anim(HERO_SPRITESHEET, c_name, character.sprites2, [0,8,0], [1,9,1], [3,11,3], [6,14,6])
					sprite_add_4way_anim(ATTACK_SPRITESHEET, c_name, character.sprites2, [2,10,2], [4,12,4], [5,13,5], [7,15,7])
	Log.generic(null,"Character spritesheets generated successfully!")

# Tiles & zones
var FLOOR_TILES : TileMap = null
var WALL_TILES : TileMap = null
var ROOF_TILES : TileMap = null
func to_zone_relative(tile):
	return tile - LOADED_ZONES[CURRENT_ZONE].origin
func to_tile_absolute(tile_relative):
	return tile_relative + LOADED_ZONES[CURRENT_ZONE].origin
func to_tile(vector, rounded = true):
	var tile = (vector - Vector2(16,16)) / 32.0
	if rounded:
		tile = round_vector(tile)
	return tile
func to_vector(tile):
	return (tile * 32.0) + Vector2(16,16)
func get_tile_params(tile_id):
	return CONST_DATA.tiles[tile_id]
func get_tile_flags(tile_id):
	if tile_id == -1:
		return 0
	else:
		return CONST_DATA.tiles[tile_id].flags
func is_tile_obstructed(tile):
	var flood_id = FLOOR_TILES.get_cellv(tile)
	if flood_id == -1:
		return true
	var wall_id = WALL_TILES.get_cellv(tile)
	if wall_id != -1:
		return true
	if get_object_at(tile) != null:
		return true
	return false
func get_object_at(tile):
	for obj in get_tree().get_nodes_in_group("objects"):
		if to_tile(obj.position) == tile:
			return obj
	return null
func get_tile_at(tile, layer, relative = true):
	var tile_relative = tile
	if !relative:
		tile_relative = to_zone_relative(tile)
	else:
		tile = to_tile_absolute(tile_relative)
	return GAME_DATA.zones[CURRENT_ZONE].tiles[tile_relative.y * CONST_DATA.zones[CURRENT_ZONE].width + tile_relative.x][layer]
func set_tile_at(tile, layer, tile_id, relative = true, do_not_update_tilemap = false):
	var tile_relative = tile
	if !relative:
		tile_relative = to_zone_relative(tile)
	else:
		tile = to_tile_absolute(tile_relative)
	
	var tile_layers = GAME_DATA.zones[CURRENT_ZONE].tiles[tile_relative.y * CONST_DATA.zones[CURRENT_ZONE].width + tile_relative.x]
	if !do_not_update_tilemap:
		match layer:
			0:
				FLOOR_TILES.set_cellv(tile, tile_id)
			1:
				WALL_TILES.set_cellv(tile, tile_id)
			2:
				ROOF_TILES.set_cellv(tile, tile_id)
	tile_layers[layer] = tile_id

var LOADED_ZONES = {}
func unload_all_zones():
	FLOOR_TILES.clear()
	WALL_TILES.clear()
	ROOF_TILES.clear()
	for obj in get_tree().get_nodes_in_group("objects"):
		obj.queue_free()
	TRIGGERS_LOOKUP = {}
	for zone_id in LOADED_ZONES:
		LOADED_ZONES[zone_id].loaded = false
func unload_zone(zone_id):
	if zone_id in LOADED_ZONES:
		var map_origin = LOADED_ZONES[zone_id].origin
		for y in CONST_DATA.zones[zone_id].height:
			for x in CONST_DATA.zones[zone_id].width:
				var world_tile_coords = Vector2(x, y) + map_origin
				FLOOR_TILES.set_cellv(world_tile_coords, -1)
				WALL_TILES.set_cellv(world_tile_coords, -1)
				ROOF_TILES.set_cellv(world_tile_coords, -1)
				TRIGGERS_LOOKUP.erase(world_tile_coords)
		for obj in get_tree().get_nodes_in_group(str("zone_",zone_id)):
			obj.queue_free()
		LOADED_ZONES[zone_id].loaded = false
	else:
		Log.generic(null,"Can not unload zone %d because it wasn't loaded!" % [zone_id])
func discover_zone(zone_id):
	GAME_DATA.zones[zone_id].tiles = CONST_DATA.zones[zone_id].tiles.duplicate(true)
	GAME_DATA.zones[zone_id].discoveed = true
func load_zone(zone_id, map_origin):
	if !(zone_id in GAME_DATA.zones):
		return null
	if !GAME_DATA.zones[zone_id].discovered:
		discover_zone(zone_id)
	var tiles = GAME_DATA.zones[zone_id].tiles
	
	var width = CONST_DATA.zones[zone_id].width
	var height = CONST_DATA.zones[zone_id].height
	for y in height:
		for x in width:
			var tile_layers = tiles[y * width + x]
			var world_tile_coords = Vector2(x, y) + map_origin
			
			# for object (wall) tiles, only set the tilemap for non-moveable walls
			var wall_flags = get_tile_flags(tile_layers[1])
			if wall_flags & ~(TileFlags.has_transparency + TileFlags.is_floor + TileFlags.is_wall + TileFlags.is_roof):
				print(world_tile_coords," ", value_list_flags(wall_flags,TileFlags))
#			if wall_flags & (TileFlags.is_draggable):
				var obj = spawn_object(tile_layers[1], world_tile_coords.x, world_tile_coords.y, zone_id)
				obj.tile_flags = wall_flags
				if wall_flags & TileFlags.is_draggable:
					obj.add_to_group("draggable")
				if wall_flags & TileFlags.is_locator:
					obj.add_to_group("locator")
				if wall_flags & TileFlags.is_item:
					obj.add_to_group("items")
				if wall_flags & TileFlags.is_weapon:
					obj.add_to_group("weapons")
				if wall_flags & TileFlags.is_character:
					obj.add_to_group("characters")
			else:
				WALL_TILES.set_cellv(world_tile_coords, tile_layers[1])
			
			# for floor and roof (ceiling) tiles, go ahead
			FLOOR_TILES.set_cellv(world_tile_coords, tile_layers[0])
			ROOF_TILES.set_cellv(world_tile_coords, tile_layers[2])
			
			# save hotspots (triggers) into the lookup
			for hotspot in CONST_DATA.zones[zone_id].hotspots:
				if hotspot.x == x && hotspot.y == y:
					TRIGGERS_LOOKUP[world_tile_coords] = hotspot
	
	LOADED_ZONES[zone_id] = {
		"origin": map_origin,
		"loaded": true
	}
	update_current_zone()
	JUST_ENTERED_ZONE = true
	Log.generic(null,"Loaded zone: %d at %s" % [zone_id, map_origin])
	return CONST_DATA.zones[zone_id]

var ROOMS_STACK = []
var CURRENT_ZONE = -1
var JUST_ENTERED_ZONE = false # set by load_zone() and reset by do_actions()
var JUST_ENTERED_ZONE_BY_VEHICLE = false # set by load_zone() and reset by do_actions()
func update_current_zone():
	var hero_tile = HERO_ACTOR.tile_current
	for zone_id in LOADED_ZONES:
		if LOADED_ZONES[zone_id].loaded:
			var map_origin = LOADED_ZONES[zone_id].origin
			if hero_tile >= map_origin && hero_tile <= map_origin + Vector2(CONST_DATA.zones[zone_id].width, CONST_DATA.zones[zone_id].height):
				CURRENT_ZONE = zone_id
				return
	CURRENT_ZONE = -1
func room_enter(zone_id):
	var map_origin = null
	if zone_id in LOADED_ZONES: # we already calculated the map origin previously
		map_origin = LOADED_ZONES[zone_id].origin
	else: # calculate origin using the player position and the door_out trigger tile
		for hotspot in CONST_DATA.zones[zone_id].hotspots:
			if hotspot.type == Hotspots.door_out:
				map_origin = HERO_ACTOR.tile_current - Vector2(hotspot.x, hotspot.y)
	
	if map_origin == null:
		Log.generic(null,"Can not enter room (zone %d) because it lacks a 'door_out' tile!!" % [zone_id])
	else:
		yield(fadeout(),"completed")
		ROOMS_STACK.push_back(CURRENT_ZONE)
		unload_all_zones()
		load_zone(zone_id, map_origin)
		yield(fadein(),"completed")
func room_exit():
	var prev_zone_id = ROOMS_STACK[0] # the outer zone MUST BE IN THE STACK.
	var map_origin = null
	if prev_zone_id in LOADED_ZONES: # we already calculated the map origin previously
		map_origin = LOADED_ZONES[prev_zone_id].origin
	else: # calculate origin using the player position and the door_out trigger tile
		for hotspot in CONST_DATA.zones[prev_zone_id].hotspots:
			if hotspot.type == Hotspots.door_in && hotspot.args == CURRENT_ZONE:
				map_origin = HERO_ACTOR.tile_current - Vector2(hotspot.x, hotspot.y)
	
	if map_origin == null:
		Log.generic(null,"Can not exit room because the previous zone lacks a linked 'door_in' tile!!")
	else:
		yield(fadeout(),"completed")
		unload_all_zones()
		ROOMS_STACK.pop_front()
		load_zone(prev_zone_id, map_origin)
		yield(fadein(),"completed")


# SCRIPTS - ACTIONS - HOTSPOTS - TRIGGERS
func force_script_update():
	return _process(0.0)
func _process(delta):
	if SPEECH_PLAYING != null:
		return false
	if is_fading():
		return false
	if !is_in_game():
		return false
	
	# actions
	var action_was_executed = false
	for a in CONST_DATA.zones[CURRENT_ZONE].actions.size():
		var action = CONST_DATA.zones[CURRENT_ZONE].actions[a]
		var action_disabled = GAME_DATA.zones[CURRENT_ZONE].actions[a]
		if !action_disabled && do_action_script(action):
			print(a,":",action.name)
			action_was_executed = true
	JUST_ENTERED_ZONE = false

	# hotspots
	var hotspot_was_triggered = false
	if HERO_ACTOR.state == HERO_ACTOR.States.walk_grid_centered:
		hotspot_was_triggered = do_hotspots(HERO_ACTOR.tile_current)
	
	# return results
	return action_was_executed || hotspot_was_triggered

var TRIGGERS_LOOKUP = {}
func do_hotspots(tile): # hotspots (tile-based triggers)
	if tile in TRIGGERS_LOOKUP:
		var hotspot = TRIGGERS_LOOKUP[tile]
		if hotspot.enabled:
			print("(%d,%d) <%d> %s %s %s" % [
				hotspot.x, hotspot.y,
				hotspot.type, Log.get_enum_string(Game.Hotspots, hotspot.type),
				"" if hotspot.args == 65535 else str("(",hotspot.args,")"),
				"" if hotspot.enabled else "(off)"])
			match hotspot.type:
				Hotspots.door_in:
					room_enter(hotspot.args)
				Hotspots.door_out:
					room_exit()
				_:
					pass
			return true
	return false

var GAME_EXP = 0
func do_action_script(action):
	if !action.enabled:
		return
	for condition in action.conditions:
		if !evaluate_action_condition(condition, action):
			return false
	for instruction in action.instructions:
		perform_action_instruction(instruction, action)
	return true
enum CondYODA {
	zone_not_initialised = 0x0
	zone_entered = 0x1
	bumped_into = 0x2
	used_item_on = 0x3
	standing_on = 0x4
	variable_is = 0x5
	random_is = 0x6
	random_is_greater_than = 0x7
	random_is_less_than = 0x8
	enter_by_vehicle = 0x9
	tile_is = 0xa
	monster_is_dead = 0xb
	all_monsters_are_dead = 0xc
	has_item = 0xd
	required_item_is = 0xe
	starting_item_is = 0xf
	zone_is_solved = 0x10
	no_item_placed = 0x11
	item_placed = 0x12
	health_is_less_than = 0x13
	health_is_greater_than = 0x14
	UNUSED15 = 0x15
	find_item_is = 0x16
	used_item_is_not = 0x17
	hero_is_at = 0x18
	global_var_is = 0x19
	global_var_is_less_than = 0x1a
	global_var_is_greater_than = 0x1b
	exp_is = 0x1c
	drops_quest_item_at = 0x1d
	has_any_required_item = 0x1e
	variable_is_not = 0x1f
	random_is_not = 0x20
	global_var_is_not = 0x21
	tile_var_is = 0x22
	exp_greater_than = 0x23
	#
	game_not_completed = 0x1024
	game_is_completed = 0x1025
}
enum CondINDY {
	UNUSED0 = 0x0
	standing_on = 0x1
	bumped_into = 0x2
	used_item_on = 0x3
	zone_not_initialised = 0x4
	zone_entered = 0x5
	variable_is = 0x6
	UNUSED7 = 0x7
	UNUSED8 = 0x8
	game_is_completed = 0x9 # ??
	has_item = 0xa
	UNUSEDB = 0xb
	random_is_greater_than = 0xc
	random_is = 0xd
	random_is_less_than = 0xe
	zone_is_solved = 0xf # maybe?
	enter_by_vehicle = 0x10
	monster_is_dead = 0x11
	all_monsters_are_dead = 0x12
	tile_is = 0x13
	item_placed = 0x14 # maybe?
	required_item_is = 0x15 # maybe?
	health_is_less_than = 0x16
	##
	health_is_greater_than = 0x1017
	starting_item_is = 0x1018
	no_item_placed = 0x1019
	find_item_is = 0x101a
	used_item_is_not = 0x101b
	hero_is_at = 0x101c
	global_var_is = 0x101d
	global_var_is_less_than = 0x101e
	global_var_is_greater_than = 0x101f
	exp_is = 0x1020
	drops_quest_item_at = 0x1021
	has_any_required_item = 0x1022
	variable_is_not = 0x1023
	random_is_not = 0x1024
	global_var_is_not = 0x1025
	tile_var_is = 0x1026
	exp_greater_than = 0x1027
	game_not_completed = 0x1028
}
func evaluate_action_condition(condition, action):
	if CURRENT_ZONE == 333:
		pass
	var opcodes = CondINDY if IS_INDY else CondYODA
	match condition.opcode:
		opcodes.zone_not_initialised: # Evaluates to true exactly once (used for initialisation)
			if !condition.met:
				condition.met = true
				return true
		opcodes.zone_entered: # Evaluates to true if hero just entered the zone
			return JUST_ENTERED_ZONE
		opcodes.bumped_into: # This MUST ignore draggable items!
			var obj = get_object_at(HERO_ACTOR.last_bumped_tile)
			if obj == null || !obj.is_in_group("draggable"):
				return HERO_ACTOR.last_bumped_tile == to_tile_absolute(Vector2(condition.args[0], condition.args[1]))
		opcodes.used_item_on:
			pass
		opcodes.standing_on: # Check if hero is at `args[0]`x`args[1]` and the floor tile is `args[2]`
			return HERO_ACTOR.tile_current == to_tile_absolute(Vector2(condition.args[0], condition.args[1])) && get_tile_at(HERO_ACTOR.tile_current, 0, false) == condition.args[2]
		opcodes.variable_is: # Current zone's `variable` value is equal to `args[0]`
			return GAME_DATA.zones[CURRENT_ZONE].variable == condition.args[0]
		opcodes.random_is: # Current zone's `random` value is equal to `args[0]`
			return GAME_DATA.zones[CURRENT_ZONE].random == condition.args[0]
		opcodes.random_is_greater_than: # Current zone's `random` value is greater than `args[0]`
			return GAME_DATA.zones[CURRENT_ZONE].random > condition.args[0]
		opcodes.random_is_less_than: # Current zone's `random` value is less than `args[0]`
			return GAME_DATA.zones[CURRENT_ZONE].random < condition.args[0]
		opcodes.enter_by_vehicle:
			return JUST_ENTERED_ZONE_BY_VEHICLE
		opcodes.tile_is, opcodes.tile_var_is: # Check if tile at `args[0]`x`args[1]`x`args[2]` is equal to `args[3]`
			return get_tile_at(Vector2(condition.args[1], condition.args[2]), condition.args[3]) == signed_u16(condition.args[0])
		opcodes.monster_is_dead: # True if monster `args[0]` is dead
			pass
		opcodes.all_monsters_are_dead: # True if all the monsters on this zone have been defeated
			pass
		opcodes.has_item: # True if inventory contains `args[0]`.  If `args[0]` is `0xFFFF` check if inventory contains the item provided by the current zone's puzzle
			pass
		opcodes.required_item_is:
			pass
		opcodes.starting_item_is: # True if `args[0]` is equal to world starting item id
			pass
		opcodes.zone_is_solved: # True if the current zone is solved
			  # INDY: Used in map 150, also in early maps in Indy with leaked text "Pick"
			pass
		opcodes.game_not_completed:
			return !GAME_DATA.is_won
		opcodes.game_is_completed:
			return GAME_DATA.is_won
		opcodes.no_item_placed: # Returns true if the user did not place an item
			  # INDY: game_not_completed: # Never used
			pass
		opcodes.item_placed: # Returns true if the user placed an item
			  # INDY: game_completed: # Never used
			pass
		opcodes.health_is_less_than: # Hero's health is less than `args[0]`
			pass
		opcodes.health_is_greater_than: # Hero's health is greater than `args[0]`
			pass
#		opcodes.unused:
#			pass
		opcodes.find_item_is: # True if the item provided by current zone is `args[0]`, related to 0x10
			pass
		opcodes.used_item_is_not:
			pass
		opcodes.hero_is_at: # True if hero's x/y position is `args_0`x`args_1`.
			pass
		opcodes.global_var_is: # Current zone's `global_var` value is equal to `args[0]`
			return GLOBAL_VAR == condition.args[0]
		opcodes.global_var_is_less_than: # Current zone's `global_var` value is less than `args[0]`
			return GLOBAL_VAR < condition.args[0]
		opcodes.global_var_is_greater_than: # Current zone's `global_var` value is greater than `args[0]`
			return GLOBAL_VAR > condition.args[0]
		opcodes.exp_is: # (games_won_is): # Total game experience is equal to `args[0]`, used in map 94 (Dagobah) a lot
			return GAME_EXP == condition.args[0]
		opcodes.drops_quest_item_at: # Used in map 57, 139, 160 a lot, related to script cmd 15/16? Checks goals?
			pass
		opcodes.has_any_required_item: # Determines if inventory contains any of the required items needed for current zone
			pass
		opcodes.variable_is_not: # Current zone's `variable` value is not equal to `args[0]`
			return GAME_DATA.zones[CURRENT_ZONE].variable != condition.args[0]
		opcodes.random_is_not: # Current zone's `random` value is not equal to `args[0]`
			return GAME_DATA.zones[CURRENT_ZONE].random != condition.args[0]
		opcodes.global_var_is_not: # Current zone's `global_var` value is not equal to `args[0]`
			return GLOBAL_VAR != condition.args[0]
		opcodes.exp_greater_than: # (games_won_is_greater_than): # True, if total game experience is greater than `args[0]`
			return GAME_EXP > condition.args[0]
		_:
			pass
	return false
enum InstrYODA {
	set_tile = 0x0
	remove_tile = 0x1
	move_tile = 0x2
	draw_tile = 0x3
	speak_hero = 0x4
	speak_npc = 0x5
	redraw_tile = 0x6
	redraw_tiles_rect = 0x7
	redraw = 0x8
	wait = 0x9
	play_sound = 0xa
	stop_sound = 0xb
	roll_random = 0xc
	set_variable = 0xd
	incr_variable = 0xe
	set_tile_var = 0xf # same as 'set_tile'
	hide_hero = 0x10 # release camera
	show_hero = 0x11 # lock camera
	move_hero_to = 0x12
	move_hero_by = 0x13 # move camera
	disable_action = 0x14
	enable_hotspot = 0x15 # enable object?
	disable_hotspot = 0x16 # disable object?
	enable_monster = 0x17
	disable_monster = 0x18
	enable_all_monsters = 0x19
	disable_all_monsters = 0x1a
	drop_item = 0x1b
	add_item = 0x1c
	remove_item = 0x1d
	mark_as_solved = 0x1e # open? show?
	win_game = 0x1f
	lose_game = 0x20
	change_zone = 0x21
	set_global_var = 0x22
	incr_global_var = 0x23
	set_random = 0x24
	add_health = 0x25
}
enum InstrINDY {
	set_tile = 0x0
	move_vehicle_progressive = 0x1
	remove_tile = 0x2
	move_tile = 0x3
	draw_tile = 0x4
	speak_hero = 0x5
	wait = 0x6
	redraw_tile = 0x7
	redraw_tiles_rect = 0x8
	set_variable = 0x9
	incr_variable = 0xa
	play_sound = 0xb
	stop_sound = 0xc
	roll_random = 0xd
	__UNKN_0xE = 0xe # ??? no args
	__UNKN_0xF = 0xf # ??? no args
	set_tile_var = 0x10 # same as 'set_tile'
	hide_hero = 0x11
	show_hero = 0x12
	move_hero_to = 0x13 # release_camera?
	move_hero_by = 0x14 # lock camera?
	disable_action = 0x15
	enable_hotspot = 0x16
	disable_hotspot = 0x17
	enable_monster = 0x18
	disable_monster = 0x19
	enable_all_monsters = 0x1a
	disable_all_monsters = 0x1b
	speak_npc = 0x1c
	add_item = 0x1d
	remove_item = 0x1e
	mark_as_solved = 0x1f
	win_game = 0x20
	lose_game = 0x21
	change_zone = 0x22
	set_global_var = 0x23
	incr_global_var = 0x24
	set_random = 0x25
	add_health = 0x26
	##
	redraw = 0x1027
	drop_item = 0x1028
}
func perform_action_instruction(instruction, action):
	if CURRENT_ZONE == 333:
		pass
		
	var opcodes = InstrINDY if IS_INDY else InstrYODA
	match instruction.opcode:
		opcodes.set_tile, opcodes.set_tile_var: # Place tile `args[3]` at `args[0]`x`args[1]`x`args[2]`. To remove a tile `args[3]` can be set to `0xFFFF`.
			set_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2], instruction.args[3])
		opcodes.move_vehicle_progressive:
#			var prev_tile = get_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2])
#			set_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2], -1)
#			set_tile_at(Vector2(instruction.args[3], instruction.args[4]), instruction.args[2], prev_tile)
			pass
		opcodes.remove_tile: # Remove tile at `args[0]`x`args[1]`x`args[2]`
			set_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2], -1)
		opcodes.move_tile: # Move tile from `args[0]`x`args[0]`x`args[2]` to `args[3]`x`args[4]`x`args[2]`
			var prev_tile = get_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2])
			set_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2], -1)
			set_tile_at(Vector2(instruction.args[3], instruction.args[4]), instruction.args[2], prev_tile)
		opcodes.draw_tile:
			pass
		opcodes.speak_hero: # Show speech bubble next to hero. Uses `text` attribute.
							# The characters `¢` and `¥` are used as placeholders for provided and required items of the current zone, respectively.
			speech_bubble(HERO_ACTOR.tile_current, instruction.text)
		opcodes.speak_npc: # Show speech bubble at `args[0]`x`args[1]`. Uses `text` attribute.
			speech_bubble(to_tile_absolute(Vector2(instruction.args[0], instruction.args[1])), instruction.text)
		opcodes.redraw_tile: # Redraw tile at `args[0]`x`args[1]`
			pass
		opcodes.redraw_tiles_rect: # Redraw the part of the current scene, specified by a rectangle positioned at `args[0]`x`args[1]` with width `args[2]` and height `args[3]`
			pass
		opcodes.redraw: # Redraw the whole scene immediately
			return
		opcodes.wait: # Pause script execution for `args[0]` ticks
			pause_game(instruction.args[0]) 
		opcodes.play_sound: # Play sound specified by `args[0]`
			play_sound(instruction.args[0])
		opcodes.stop_sound: # / map transition cutscene (intro)?
			return # 0, 0, 0, 0
		opcodes.roll_random: # Roll between 1 and `args[0]` and set into map `random` value
			randomize()
			GAME_DATA.zones[CURRENT_ZONE].random = (randi() % instruction.args[0]) + 1
			print("set rand to ",GAME_DATA.zones[CURRENT_ZONE].random)
		opcodes.set_variable: # Set current zone's `variable` value to a `args[0]`
			GAME_DATA.zones[CURRENT_ZONE].variable = instruction.args[0]
		opcodes.incr_variable: # Add `args[0]` to current zone's `variable` value
			GAME_DATA.zones[CURRENT_ZONE].variable += instruction.args[0]
		opcodes.hide_hero: # (release_camera?)
			pass # 7, 14, 0, 57, 0
		opcodes.show_hero: # (lock_camera?)
			pass
		opcodes.move_hero_to: # Set hero's position to `args[0]`x`args[1]` ignoring impassable tiles.
							  # Execute hotspot actions, redraw the current scene and move camera if the hero is not hidden
			pass
		opcodes.move_hero_by: # Moves hero relative to the current location by `args[0]` in x and `args[1]` in y direction
			pass
		opcodes.disable_action: # Disable current action, note that there's no way to activate the action again
			action["enabled"] = false # 0, 0, 0
		opcodes.enable_hotspot: # (show_object?): # Enable hotspot `args[0]` so it can be triggered
			pass
		opcodes.disable_hotspot: # (hide_object?): # Disable hotspot `args[0]` so it can't be triggered anymore
			pass
		opcodes.enable_monster: # Enable monster `args[0]`
			pass
		opcodes.disable_monster: # Disable monster `args[0]`
			pass
		opcodes.enable_all_monsters:
			pass
		opcodes.disable_all_monsters:
			pass
		opcodes.drop_item: # Drops item `args[0]` for pickup at `args[1]`x`args[2]`. If the item is 0xFFFF, it drops the current sector's find item instead
			pass
			pause_game()
		opcodes.add_item: # Add tile with id `args[0]` to inventory
			pass
		opcodes.remove_item: # Remove one instance of item `args[0]` from the inventory
			pass
		opcodes.mark_as_solved: # Marks current sector solved for the overview map /// 'Open'? 'Show'? Sets a bunch of values to 1. Used in map 52 on opening a box
			pass
		opcodes.win_game: # Ends the current story by winning
			pass
		opcodes.lose_game: # Ends the current story by losing
			pass
		opcodes.change_zone: # Change current zone to `args[0]`. Hero will be placed at `args[1]`x`args[2]` in the new zone
			pass
		opcodes.set_global_var: # Set GLOBAL_VAR value to a `args[0]`
			GLOBAL_VAR = instruction.args[0]
		opcodes.incr_global_var: # Add `args[0]` to GLOBAL_VAR
			GLOBAL_VAR += instruction.args[0]
		opcodes.set_random: # Set current zone's `random` value to a `args[0]`
			GAME_DATA.zones[CURRENT_ZONE].random = instruction.args[0]
		opcodes.add_health: # Increase hero's health by `args[0]`. New health is capped at hero's max health (0x300). Argument 0 can also be negative to subtract from hero's health
			HERO_ACTOR.health += instruction.args[0]
func pause_game(ticks = null):
	pass
			
# Objects, actors
var HERO_ACTOR = null
onready var OBJECT_SCN = load("res://scenes/Object.tscn")
func spawn_object(tile_id, x, y, zone_id):
	var obj = OBJECT_SCN.instance()
	obj.texture = get_sprite(tile_id)
	obj.position = to_vector(Vector2(x,y))
	obj.tile_id = tile_id
	obj.linked_zone_id = zone_id
	WALL_TILES.add_child(obj)
	return obj
func spawn_monster(char_id, x, y): # TODO
	pass

# Game stuff
var SPEECH_PLAYING = null
onready var SPEECH_SCN = load("res://scenes/SpeechBubble.tscn")
func speech_bubble(tile, text):
	pause_game()
	SPEECH_PLAYING = SPEECH_SCN.instance()
	SPEECH_PLAYING.TILE = tile
	UI_ROOT.add_child(SPEECH_PLAYING)
	SPEECH_PLAYING.set_text(text)
func play_sound(sound_id, from = 0.0):
	Sounds.play_sound(Game.CONST_DATA.sounds[sound_id], null, 1.0, "Master", 0.0)

# Game world data
const GAME_DATA_DUMMY = {
	"is_won": false,
	"seed_unkn": null,
	"indoor_zones_unk": [],
	"zones": {},
	"map": [],
	"inventory": [],
	"current_zone": null,
	"unk2": null,
	"unk3": null,
	"selected_weapon": null,
	"hero_x_coord": null,
	"hero_y_coord": null,
	"unk4": null,
	"unk5": null,
	"unk6": null,
	"game_timer": null,
	"unk7": null,
	"weapon_stats_unk1": null,
	"weapon_stats_unk2": null,
}
var GAME_DATA = {}
func clear_game_data():
	GAME_DATA = GAME_DATA_DUMMY.duplicate(true)
	unload_all_zones()
func is_in_game():
	return CURRENT_ZONE != -1
func new_game(): # TODO
	yield(fadeout(),"completed")
	clear_game_data()
#	generate_new_game() # TODO
#	Game.play_sound(15)
	load_zone(120, Vector2())
	HERO_ACTOR.teleport(Vector2(11, 5))
	refresh_inventory_display()
	yield(fadein(),"completed")

func load_game(file_path):
	Cursor.drag(null)
	clear_inventory()
	yield(fadeout(),"completed")

	# open save file!
	var r = FILE.open(file_path, File.READ)
	if r != OK:
		Log.error(null,r,"could not load WLD file!")
	
	# flush game data
	clear_game_data()
	
#	assert_in_file(SAV, "INDYSAV", 7)
	var file_type = FILE.get_buffer(7).get_string_from_ascii()
	var sav_version = FILE.get_buffer(2).get_string_from_ascii().to_int()
	Log.generic(null,"'%s' Savegame version: %d" % [file_type,sav_version])
	GAME_DATA.seed_unkn = FILE.get_32()
	
	# unkn. value for indoor zones (rooms)
	for _m in FILE.get_16():
		GAME_DATA.indoor_zones_unk.push_back(FILE.get_16())
	
	# 10x10 map tiles
	GAME_DATA.map = []
	for i in 100:
		GAME_DATA.map.push_back({
			"discovered": FILE.get_16(),
			"unk1": FILE.get_16(),
			"solved": FILE.get_16(),
			"zone_id": signed_u16(FILE.get_16()),
			"unk2": [
				signed_u16(FILE.get_16()),
				signed_u16(FILE.get_16()),
				signed_u16(FILE.get_16()),
				signed_u16(FILE.get_16()),
				signed_u16(FILE.get_16()),
			]
		})
	
	# actual zones data
	var prev_zone_args = []
	while true:
		assert(!FILE.end_reached())
		var map_x = null
		var map_y = null
		var zone_id = null
		var discovered = null
		
		var a = FILE.get_16()
		var b = FILE.get_16()
		if a == 65535 && b == 65535: # end of the list
			break
		
		var is_room = false
		if a in prev_zone_args: # we assume that the zone id is part of the parent's hotspots list
			is_room = true
			zone_id = a
			discovered = bool(b)
		else:
			prev_zone_args = []
			map_x = a
			map_y = b
			zone_id = FILE.get_16()
			discovered = bool(FILE.get_16())
		var unk1 = FILE.get_16() # 00 00
		
		var unk2 = null
		var unk3 = null
		var unk4 = null
		
		var unk5 = null # 01 00
		var zone_tiles = []
		var hotspots = []
		var unk_32bytes = []
		var actions = []
		
		# zone tiles + 3 header unkn. values
		if discovered:
			unk2 = FILE.get_16()
			unk3 = FILE.get_16()
			unk4 = FILE.get_16()
			var total_tiles = CONST_DATA.zones[zone_id].width * CONST_DATA.zones[zone_id].height
			for _t in total_tiles:
				zone_tiles.push_back([
					signed_u16(FILE.get_16()),
					signed_u16(FILE.get_16()),
					signed_u16(FILE.get_16()),
				])
			unk5 = FILE.get_16() # 01 00
		# hotspots
		for _i in FILE.get_16():
			var enabled = bool(FILE.get_16())
			var args = FILE.get_16()
			hotspots.push_back({
				"enabled": enabled,
				"args": args,
			})
			prev_zone_args.push_back(args)
		if discovered:
			# ??
			for _i in FILE.get_16():
				var arr = []
				for _n in 16:
					arr.push_back(signed_u16(FILE.get_16()))
				unk_32bytes.push_back(arr)
			# actions
			for _i in FILE.get_16():
				actions.push_back(bool(FILE.get_16()))
		
		GAME_DATA.zones[zone_id] = {
			"map_x": map_x,
			"map_y": map_y,
			"discovered": discovered,
			"unk1": unk1,
			"unk2": unk2,
			"unk3": unk3,
			"unk4": unk4,
			"tiles": zone_tiles,
			"unk5": unk5,
			"hotspots": hotspots,
			"unk_32bytes": unk_32bytes,
			"actions": actions,
			
			# TODO:
			"random":0,
			"variable":0,
		}
	
	# game stats
	for _i in FILE.get_16():
		GAME_DATA.inventory.push_back(FILE.get_16())
	GAME_DATA.current_zone = FILE.get_16()
	GAME_DATA.unk2 = FILE.get_16()
	GAME_DATA.unk3 = FILE.get_16()
	GAME_DATA.selected_weapon = FILE.get_16()
	GAME_DATA.hero_x_coord = FILE.get_16()
	GAME_DATA.hero_y_coord = FILE.get_16()
	GAME_DATA.unk4 = FILE.get_16()
	GAME_DATA.unk5 = FILE.get_16()
	GAME_DATA.unk6 = FILE.get_16()
	GAME_DATA.game_timer = FILE.get_32()
	GAME_DATA.unk7 = FILE.get_16()
	GAME_DATA.weapon_stats_unk1 = FILE.get_16()
	GAME_DATA.weapon_stats_unk2 = FILE.get_16()
	
	assert(FILE.get_position() == FILE.get_len())

	refresh_inventory_display()
	
	load_zone(GAME_DATA.current_zone, Vector2())
	HERO_ACTOR.teleport(to_tile(Vector2(GAME_DATA.hero_x_coord, GAME_DATA.hero_y_coord)) + LOADED_ZONES[GAME_DATA.current_zone].origin)
	yield(fadein(),"completed")

var INV_UI_LIST = null
var INV_SELECTED = null
onready var INV_ITEM_SCN = load("res://scenes/InventoryItem.tscn")
func add_item(tile_id):
	pass
func remove_item(inv_index):
	pass
func clear_inventory():
	for n in INV_UI_LIST.get_children():
		n.queue_free()
func equip_item(tile_id):
	if !(tile_id in CONST_DATA.weapons):
		play_sound(8)
		return false
	else:
		play_sound(0)
		set_equipped_item(tile_id)
		return true
func set_equipped_item(tile_id):
	if tile_id != null:
		INV_SELECTED.item_node.tile_id = tile_id
		INV_SELECTED.show()
	else:
		INV_SELECTED.hide()
func refresh_inventory_display():
	clear_inventory()
	for tile_id in GAME_DATA.inventory:
		var item_node = INV_ITEM_SCN.instance()
		item_node.tile_id = tile_id
		INV_UI_LIST.add_child(item_node)
	
	# equipped weapon
	if GAME_DATA.selected_weapon != 65535:
		set_equipped_item(CONST_DATA.weapons[GAME_DATA.selected_weapon])
	else:
		set_equipped_item(null)
