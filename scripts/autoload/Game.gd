extends Node

var WORLD_ROOT = null
var FADE = null
func fadein():
	FADE.fade_target = -1
	yield(FADE,"fade_done")
func fadeout():
	FADE.fade_target = 1
	yield(FADE,"fade_done")

func can_control_hero():
	if FADE.fade_target != 0:
		return false
	return true

func debug_tools_enabled():
	return false

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
var DATA = {
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
}
func assert_marker(marker):
	var found = DAW.get_buffer(4).get_string_from_ascii()
	if OS.is_debug_build():
		assert(found == marker)
	else:
		if found != marker:
			Log.error(null,GlobalScope.Error.ERR_INVALID_DATA,"Found incorrect marker at %0x08X - expected '%s', found '%s'"%[DAW.get_position()-4,marker,found])
			get_tree().quit()

var DAW = DataFile.new()
func load_daw(file_path):
	var r = DAW.open(file_path, File.READ)
	if r != OK:
		Log.error(null,r,"could not load DAW file!")
	
	DAW.seek(4)
	DATA["VERS"] = DAW.get_32()
	Log.generic(null,"'VERS' at 0x00000000: %d" % [DATA["VERS"]])
	
	while !DAW.end_reached():
		var offset = DAW.get_position()
		var s_name = DataStruct.as_text(DAW.read("str4"))
		var s_size = DAW.get_32()
		var end_of_section = DAW.get_position() + s_size
		Log.generic(null,"'%s' at 0x%08X: %d bytes" % [s_name, offset, s_size])
		match s_name:
			"STUP": # splash screen
				DATA.splash = DAW.get_buffer(s_size)
			"SNDS": # sound files namess
				var _unk_num = DAW.get_16()
				while DAW.get_position() < end_of_section:
					var subs_size = DAW.get_16()
					var original_path = DAW.get_buffer(subs_size).get_string_from_ascii()
					var snd_filename = Array(original_path.split("\\")).pop_back()
					DATA.sounds.push_back(snd_filename)
			"TILE": # tile bitmaps
				while DAW.get_position() < end_of_section:
					DATA.tiles.push_back({
						"name": "",
						"flags": DAW.get_32(),
						"bmp": DAW.get_buffer(1024)
					})
			"ZONE": # zones data
				for i in DAW.get_16():
					assert_marker("IZON")
					var _subs_size = DAW.get_32()
					var z_width = DAW.get_16()
					var z_height = DAW.get_16()
					var z_type = DAW.get_32()
					var z_total_tiles = z_width * z_height
					var z_tiles = []
					for _t in z_total_tiles:
						z_tiles.push_back({
							"x": signed_u16(DAW.get_16()),
							"y": signed_u16(DAW.get_16()),
							"z": signed_u16(DAW.get_16()),
						})
					DATA.zones.push_back({
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
						"actions": []
					})
					if DAW.get_position() > end_of_section:
						break
			"ZAUX": # monsters, required items
				for i in DATA.zones.size():
					assert_marker("IZAX")
					var _subs_size = DAW.get_32()
					DATA.zones[i].unkn_zaux = DAW.get_16()
					for _i in DAW.get_16():
						DATA.zones[i].monsters.push_back({
							"id": DAW.get_16(),
							"x": signed_u16(DAW.get_16()),
							"y": signed_u16(DAW.get_16()),
						})
					for _i in DAW.get_16():
						DATA.zones[i].required_items.push_back(DAW.get_16())
			"ZAX2": # reward items
				for i in DATA.zones.size():
					assert_marker("IZX2")
					var _subs_size = DAW.get_32()
					for _i in DAW.get_16():
						DATA.zones[i].reward_items.push_back(DAW.get_16())
			"ZAX3": # npcs
				for i in DATA.zones.size():
					assert_marker("IZX3")
					var _subs_size = DAW.get_32()
					for _i in DAW.get_16():
						DATA.zones[i].npcs.push_back(DAW.get_16())
			"ZAX4": # ???
				for i in DATA.zones.size():
					assert_marker("IZX4")
					var subs_size = DAW.get_32()
					var subs_data = DAW.get_buffer(subs_size)
					DATA.zones[i].izx4.push_back(subs_data)
			"HTSP": # hotspots (triggers)
				while DAW.get_position() < end_of_section:
					var zone_id = DAW.get_16()
					if zone_id == 65535:
						break
					for _i in DAW.get_16():
						DATA.zones[zone_id].hotspots.push_back({
							"type": DAW.get_32(),
							"x": DAW.get_16(),
							"y": DAW.get_16(),
							"enabled": DAW.get_16(),
							"args": DAW.get_16(),
						})
			"ACTN": # action scripts
				while DAW.get_position() < end_of_section:
					var zone_id = DAW.get_16()
					if zone_id == 65535:
						break
					for _a in DAW.get_16():
						assert_marker("IACT")
						var _subs_size = DAW.get_32()
						var action_data = {
							"name": "",
							"conditions": [],
							"instructions": [],
						}
						for _c in DAW.get_16(): # conditions
							var condition = {
								"opcode": DAW.get_16(),
								"args": [
									DAW.get_16(),
									DAW.get_16(),
									DAW.get_16(),
									DAW.get_16(),
									DAW.get_16(),
								],
								"met": false
							}
							var text_length = DAW.get_16()
							condition["text"] = DAW.get_buffer(text_length).get_string_from_ascii()
							action_data.conditions.push_back(condition)
						for _i in DAW.get_16(): # instructions
							var instruction = {
								"opcode": DAW.get_16(),
								"args": [
									DAW.get_16(),
									DAW.get_16(),
									DAW.get_16(),
									DAW.get_16(),
									DAW.get_16(),
								],
							}
							var text_length = DAW.get_16()
							instruction["text"] = DAW.get_buffer(text_length).get_string_from_ascii()
							action_data.instructions.push_back(instruction)
						DATA.zones[zone_id].actions.push_back(action_data)
			"PUZ2": # puzzles
				while DAW.get_position() < end_of_section:
					var zone_id = DAW.get_16()
					if zone_id == 65535:
						break
					assert_marker("IPUZ")
					var subs_size = DAW.get_32()
					DATA.puzzles.push_back({
						"name": "",
						"type": DAW.get_32(),
						"item1_class": DAW.get_32(),
						"item2_class": DAW.get_32(),
						"ipuz_strings": DAW.get_buffer(subs_size - 16).get_string_from_ascii(),
						"item1": DAW.get_16(),
						"item2": DAW.get_16()
					})
					DATA.zones[zone_id].puzzle = DATA.puzzles.size() - 1
			"CHAR": # characters
				while DAW.get_position() < end_of_section:
					var char_id = DAW.get_16()
					if char_id == 65535:
						break
					assert_marker("ICHA")
					var _subs_size = DAW.get_32()
					var c_name = DAW.get_buffer(16).get_string_from_ascii()
					var data = {
						"name": c_name,
						"type": DAW.get_16(),
						"movement_type": DAW.get_16(),
						"sprites1": [
							# DIRECTIONS (corner): NW NE SW SE
							# DIRECTIONS (side): S W N E
							DAW.get_16(),	# N ^
							DAW.get_16(),	# S v
							DAW.get_16(),	# N ^
							DAW.get_16(),	# W <
							DAW.get_16(),	# W <
							DAW.get_16(),	# N ^
							DAW.get_16(),	# E >
							DAW.get_16()	# E >
						],
						"sprites2": [
							# frame 1
							DAW.get_16(),	# N ^
							DAW.get_16(),	# S v
							DAW.get_16(),	# N ^
							DAW.get_16(),	# W <
							DAW.get_16(),	# W <
							DAW.get_16(),	# N ^
							DAW.get_16(),	# E >
							DAW.get_16(),	# E >
							
							# frame 2
							DAW.get_16(),	# N ^
							DAW.get_16(),	# S v
							DAW.get_16(),	# N ^
							DAW.get_16(),	# W <
							DAW.get_16(),	# W <
							DAW.get_16(),	# N ^
							DAW.get_16(),	# E >
							DAW.get_16(),	# E >
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
					DATA.characters[char_id] = data
			"CHWP": # weapons
				while DAW.get_position() < end_of_section:
					var char_id = DAW.get_16()
					if char_id == 65535:
						break
					DATA.characters[char_id].weapon_refid = DAW.get_16() # id of weapon "character" if monster, or id of attack sound if weapon
					DATA.characters[char_id].weapon_health = DAW.get_16()
			"CAUX": # monster damage
				while DAW.get_position() < end_of_section:
					var char_id = DAW.get_16()
					if char_id == 65535:
						break
					DATA.characters[char_id].damage = DAW.get_16()
			"TNAM": # tiles names
				while DAW.get_position() < end_of_section:
					var tile_id = DAW.get_16()
					if tile_id == 65535:
						break
					DATA.tiles[tile_id].name = DAW.get_buffer(16).get_string_from_ascii()
			"ZNAM": # zones names
				while DAW.get_position() < end_of_section:
					var zone_id = DAW.get_16()
					if zone_id == 65535:
						break
					DATA.zones[zone_id].name = DAW.get_buffer(16).get_string_from_ascii()
			"PNAM": # puzzles names
				var num_subs = DAW.get_16()
				for puzzle_id in num_subs:
					DATA.puzzles[puzzle_id].name = DAW.get_buffer(16).get_string_from_ascii()
					if DAW.get_position() > end_of_section:
						break
			"ANAM": # action scripts names
				while DAW.get_position() < end_of_section:
					var zone_id = DAW.get_16()
					if zone_id == 65535:
						break
					while true:
						var action_id = DAW.get_16()
						if action_id == 65535:
							break
						DATA.zones[zone_id].actions[action_id].name = DAW.get_buffer(16).get_string_from_ascii()
			"ENDF":
				assert(s_size == 0)
	Log.generic(null,"DAW file loaded sucessfully!")

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
	splash_screen.texture = texture_from_data(DATA.splash, 288, 288, PALETTE_INDY)
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
	for i in DATA.tiles.size():
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
	for char_id in DATA.characters:
		var character = DATA.characters[char_id]
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
func to_tile(vector, rounded = true):
	var tile = (vector - Vector2(16,16)) / 32.0
	if rounded:
		tile = round_vector(tile)
	return tile
func to_vector(tile):
	return (tile * 32.0) + Vector2(16,16)
func get_tile_data(tile_id):
	return DATA.tiles[tile_id]
func get_tile_flags(tile_id):
	if tile_id == -1:
		return 0
	else:
		return DATA.tiles[tile_id].flags
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
func set_tile_at(tile, level, tile_id, relative = true): # TODO
	var tile_relative = tile
	if !relative:
		tile_relative = tile - LOADED_ZONES[CURRENT_ZONE].origin
	else:
		tile = tile + LOADED_ZONES[CURRENT_ZONE].origin
	
	var zone_data = DATA.zones[CURRENT_ZONE]
	var tile_layers = zone_data.tiles[tile_relative.y * zone_data.width + tile_relative.x]
	match level:
		0:
			FLOOR_TILES.set_cellv(tile, tile_id)
		1:
			WALL_TILES.set_cellv(tile, tile_id)
		2:
			ROOF_TILES.set_cellv(tile, tile_id)
	tile_layers[level] = tile_id

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
		var zone_data = DATA.zones[zone_id]
		var map_origin = LOADED_ZONES[zone_id].origin
		for y in zone_data.height:
			for x in zone_data.width:
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
func load_zone(zone_id, map_origin):
	var zone_data = DATA.zones[zone_id]
	for y in zone_data.height:
		for x in zone_data.width:
			var tile_layers = zone_data.tiles[y * zone_data.width + x]
			var world_tile_coords = Vector2(x, y) + map_origin
			
			# for object (wall) tiles, only set the tilemap for non-moveable walls
			var wall_flags = get_tile_flags(tile_layers.y)
			if wall_flags & ~(TileFlags.has_transparency + TileFlags.is_wall):
				print(world_tile_coords," ", value_list_flags(wall_flags,TileFlags))
			if wall_flags & TileFlags.is_draggable:
				spawn_object(tile_layers.y, world_tile_coords.x, world_tile_coords.y, zone_id)
			else:
				WALL_TILES.set_cellv(world_tile_coords, tile_layers.y)
			
			# for floor and roof (ceiling) tiles, go ahead
			FLOOR_TILES.set_cellv(world_tile_coords, tile_layers.x)
			ROOF_TILES.set_cellv(world_tile_coords, tile_layers.z)
			
			# save hotspots (triggers) into the lookup
			for hotspot in zone_data.hotspots:
				if hotspot.x == x && hotspot.y == y:
					TRIGGERS_LOOKUP[world_tile_coords] = hotspot
	
	LOADED_ZONES[zone_id] = {
		"origin": map_origin,
		"loaded": true
	}
	update_current_zone()
	Log.generic(null,"Loaded zone: %d at %s" % [zone_id, map_origin])
	return zone_data
func save_zone_data(): # TODO
	pass

var ROOMS_STACK = []
var CURRENT_ZONE = -1
func update_current_zone():
	var hero_tile = HERO_ACTOR.tile_current
	for zone_id in LOADED_ZONES:
		if LOADED_ZONES[zone_id].loaded:
			var map_origin = LOADED_ZONES[zone_id].origin
			var zone_data = DATA.zones[zone_id]
			if hero_tile >= map_origin && hero_tile <= map_origin + Vector2(zone_data.width, zone_data.height):
				CURRENT_ZONE = zone_id
				return
	CURRENT_ZONE = -1
func room_enter(zone_id):
	var map_origin = null
	if zone_id in LOADED_ZONES: # we already calculated the map origin previously
		map_origin = LOADED_ZONES[zone_id].origin
	else: # calculate origin using the player position and the door_out trigger tile
		var zone_data = DATA.zones[zone_id]
		for hotspot in zone_data.hotspots:
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
		do_actions()
func room_exit():
	var prev_zone_id = ROOMS_STACK[0] # the outer zone MUST BE IN THE STACK.
	var map_origin = null
	if prev_zone_id in LOADED_ZONES: # we already calculated the map origin previously
		map_origin = LOADED_ZONES[prev_zone_id].origin
	else: # calculate origin using the player position and the door_out trigger tile
		var zone_data = DATA.zones[prev_zone_id]
		for hotspot in zone_data.hotspots:
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
		do_actions()

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

func do_actions(): # actions (scripts)
	# this is SUPER INEFFICIENT... would need to do a complete system rewrite to optimize, eh.
	var action_was_executed = false
	for action in DATA.zones[CURRENT_ZONE].actions:
		if do_action_script(action):
			action_was_executed = true
	return action_was_executed
func do_action_script(action):
	if action.name == "PopDoor":
		pass
	for condition in action.conditions:
		if !evaluate_action_condition(condition):
			return false
	print(action.name)
	for instruction in action.instructions:
		perform_action_instruction(instruction)
	return true
func evaluate_action_condition(condition):
	match condition.opcode:
		0x0: # zone_not_initialised
			pass # doc: Evaluates to true exactly once (used for initialisation)
		0x1: # zone_entered
			pass # doc: Evaluates to true if hero just entered the zone
		0x2: # bump
			if HERO_ACTOR.last_bumped_tile == Vector2(condition.args[0], condition.args[1]) + LOADED_ZONES[CURRENT_ZONE].origin:
				return true
		0x3: # placed_item_is
			pass
		0x4: # standing_on
			pass # doc: |
			pass # Check if hero is at `args[0]`x`args[1]` and the floor tile is
			pass # `args[2]`
		0x5: # counter_is
			pass # doc: Current zone's `counter` value is equal to `args[0]`
		0x6: # random_is
			pass # doc: Current zone's `random` value is equal to `args[0]`
		0x7: # random_is_greater_than
			pass # doc: Current zone's `random` value is greater than `args[0]`
		0x8: # random_is_less_than
			pass # doc: Current zone's `random` value is less than `args[0]`
		0x9: # enter_by_plane
			pass
		0xa: # tile_at_is
			pass # doc: |
			pass # Check if tile at `args[0]`x`args[1]`x`args[2]` is equal to
			pass # `args[3]`
		0xb: # monster_is_dead
			pass # doc: True if monster `args[0]` is dead.
		0xc: # has_no_active_monsters
			pass # doc: undefined
		0xd: # has_item
			pass # doc: |
			pass # True if inventory contains `args[0]`.  If `args[0]` is `0xFFFF`
			pass # check if inventory contains the item provided by the current
			pass # zone's puzzle
		0xe: # required_item_is
			pass
		0xf: # ending_is
			pass # doc: True if `args[0]` is equal to current goal item id
		0x10: # zone_is_solved
			pass # doc: True if the current zone is solved
		0x11: # no_item_placed
			pass # doc: Returns true if the user did not place an item
		0x12: # item_placed
			pass # doc: Returns true if the user placed an item
		0x13: # health_is_less_than
			pass # doc: Hero's health is less than `args[0]`.
		0x14: # health_is_greater_than
			pass # doc: Hero's health is greater than `args[0]`.
		0x15: # unused
			pass
		0x16: # find_item_is
			pass # doc: True the item provided by current zone is `args[0]`
		0x17: # placed_item_is_not
			pass
		0x18: # hero_is_at
			pass # doc: True if hero's x/y position is `args_0`x`args_1`.
		0x19: # shared_counter_is
			pass # doc: Current zone's `shared_counter` value is equal to `args[0]`
		0x1a: # shared_counter_is_less_than
			pass # doc: Current zone's `shared_counter` value is less than `args[0]`
		0x1b: # shared_counter_is_greater_than
			pass # doc: Current zone's `shared_counter` value is greater than `args[0]`
		0x1c: # games_won_is
			pass # doc: Total games won is equal to `args[0]`
		0x1d: # drops_quest_item_at
			pass
		0x1e: # has_any_required_item
			pass # doc: |
			pass # Determines if inventory contains any of the required items needed
			pass # for current zone
		0x1f: # counter_is_not
			pass # doc: Current zone's `counter` value is not equal to `args[0]`
		0x20: # random_is_not
			pass # doc: Current zone's `random` value is not equal to `args[0]`
		0x21: # shared_counter_is_not
			pass # doc: Current zone's `shared_counter` value is not equal to `args[0]`
		0x22: # is_variable
			pass # doc: |
			pass # Check if variable identified by `args[0]`⊕`args[1]`⊕`args[2]` is
			pass # set to `args[3]`. Internally this is implemented as opcode 0x0a,
			pass # check if tile at `args[0]`x`args[1]`x`args[2]` is equal to
			pass # `args[3]`
		0x23: # games_won_is_greater_than
			pass # doc: True, if total games won is greater than `args[0]`
	return false
func perform_action_instruction(instruction):
	match instruction.opcode:
		0x0: # place_tile
			pass # doc: |
			pass # Place tile `args[3]` at `args[0]`x`args[1]`x`args[2]`. To remove a
			pass # tile `args[3]` can be set to `0xFFFF`.
		0x1: # remove_tile
			pass # doc: Remove tile at `args[0]`x`args[1]`x`args[2]`
		0x2: # INDY: Remove tile at `args[0]`x`args[1]`x`args[2]`			YODA: Move tile from `args[0]`x`args[0]`x`args[2]` to `args[3]`x`args[4]`x`args[2]`
			set_tile_at(Vector2(instruction.args[0], instruction.args[1]), instruction.args[2], -1)
		0x3: # draw_tile
			pass
		0x4: # speak_hero
			pass # doc: |
			pass # Show speech bubble next to hero. _Uses `text` attribute_.

			pass # Script execution is paused until the speech bubble is dismissed.
		0x5: # speak_npc -- Show speech bubble at `args[0]`x`args[1]`. _Uses `text` attribute_. The characters `¢` and `¥` are used as placeholders for provided and required items of the current zone, respectively.
			pass
			pass
			pass
			pass

			pass # Script execution is paused until the speech bubble is dismissed.
		0x6: # set_tile_needs_display
			pass # doc: Redraw tile at `args[0]`x`args[1]`
		0x7: # set_rect_needs_display
			pass # doc: |
			pass # Redraw the part of the current scene, specified by a rectangle
			pass # positioned at `args[0]`x`args[1]` with width `args[2]` and height
			pass # `args[3]`.
		0x8: # wait
			pass # doc: Pause script execution for one tick.
		0x9: # redraw
			pass # doc: Redraw the whole scene immediately
		0xa: # play_sound
			pass # doc: Play sound specified by `args[0]`
		0xb: # INDY: Play sound specified by `args[0]` 				YODA: stop_sound
			play_sound(instruction.args[0])
		0xc: # INDY: ?? (4 args)									YODA: roll_dice between 1 and `args[0]`
			pass # 0, 0, 0, 0
			pass
			pass
		0xd: # set_counter
			pass # doc: Set current zone's `counter` value to a `args[0]`
		0xe: # add_to_counter
			pass # doc: Add `args[0]` to current zone's `counter` value
		0xf: # set_variable
			pass # doc: |
			pass # Set variable identified by `args[0]`⊕`args[1]`⊕`args[2]` to
			pass # `args[3]`.  Internally this is implemented as opcode 0x00, setting
			pass # tile at `args[0]`x`args[1]`x`args[2]` to `args[3]`.
		0x10: # hide_hero
			pass # doc: Hide hero
		0x11: # INDY: ?? tile (4 args) 					YODA: show_hero
			pass # 7, 14, 0, 57, 0
		0x12: # move_hero_to
			pass # pass # doc: |
			pass # Set hero's position to `args[0]`x`args[1]` ignoring impassable
			pass # tiles.  Execute hotspot actions, redraw the current scene and move
			pass # camera if the hero is not hidden.
		0x13: # move_hero_by
			pass # doc: |
			pass # Moves hero relative to the current location by `args[0]` in x and
			pass # `args[1]` in y direction.
		0x14: # disable_action
			pass # doc: |
			pass # Disable current action, note that there's no way to activate the
			pass # action again.
		0x15: # INDY: ?? (3 args)						YODA: Enable hotspot `args[0]` so it can be triggered.
			pass # 0, 0, 0
		0x16: # disable_hotspot
			pass # doc: Disable hotspot `args[0]` so it can't be triggered anymore.
		0x17: # enable_monster
			pass # doc: Enable monster `args[0]`
		0x18: # disable_monster
			pass # doc: Disable monster `args[0]`
		0x19: # enable_all_monsters
			pass # doc: Enable all monsters
		0x1a: # disable_all_monsters
			pass # doc: Disable all monsters
		0x1b: # drop_item
			pass # doc: |
			pass # Drops item `args[0]` for pickup at `args[1]`x`args[2]`. If the
			pass # item is 0xFFFF, it drops the current sector's find item instead.

			pass # Script execution is paused until the item is picked up.
		0x1c: # add_item
			pass # doc: Add tile with id `args[0]` to inventory
		0x1d: # remove_item
			pass # doc: Remove one instance of item `args[0]` from the inventory
		0x1e: # mark_as_solved
			pass # doc: |
			pass # Marks current sector solved for the overview map.
		0x1f: # win_game
			pass # doc: Ends the current story by winning.
		0x20: # lose_game
			pass # doc: Ends the current story by losing.
		0x21: # change_zone
			pass # doc: |
			pass # Change current zone to `args[0]`. Hero will be placed at
			pass # `args[1]`x`args[2]` in the new zone.
		0x22: # set_shared_counter
			pass # doc: Set current zone's `shared_counter` value to a `args[0]`
		0x23: # add_to_shared_counter
			pass # doc: Add `args[0]` to current zone's `shared_counter` value
		0x24: # set_random
			pass # doc: Set current zone's `random` value to a `args[0]`
		0x25: # add_health
			pass # doc: |
			pass # Increase hero's health by `args[0]`. New health is capped at
			pass # hero's max health (0x300). Argument 0 can also be negative
			pass # subtract from hero's health.
			
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
func spawn_monster(char_id, x, y): # TODO
	pass


func play_sound(sound_id):
	Sounds.play_sound(Game.DATA.sounds[sound_id],null,1.0,"Master")

func new_game():
	FADE.modulate.a = 1.0
	load_zone(120, Vector2())
	HERO_ACTOR.position = to_vector(Vector2(11, 5))
	yield(fadein(),"completed")
	do_actions()
