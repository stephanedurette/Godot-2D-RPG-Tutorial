class_name HeartContainerUI

extends TextureRect

func set_value(val: int):
	var region_mult = clampi(val, 0, 4)
	(texture as AtlasTexture).region.position.x = 16 * region_mult
