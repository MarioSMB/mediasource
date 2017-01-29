Metal_PM004
{
	dpreflectcube cubemaps/default/sky
 	{
		map textures/sportsterchrome.tga
		rgbgen lightingDiffuse
	}
}
sportsterchrome
{
	dpreflectcube cubemaps/default/sky
 	{
		map textures/sportsterchrome.tga
		rgbgen lightingDiffuse
	}
}
copper
{
	qer_editorimage textures/caethaver2_base/brushedmetal6.tga
	
	q3map_bounceScale 0.5
	dpoffsetmapping - 2
	dpglossintensitymod  3
	dpglossexponentmod  4

	{
		map textures/caethaver2_base/brushedmetal6.tga
		

	}
	{
		map $lightmap
		rgbGen identity
		tcGen lightmap
		blendfunc filter
	}
}
lightsabreblade
{
	qer_editorimage textures/lightsabreblade.tga
	surfaceparm trans
	cull back
	qer_trans 0.50

	{
		map textures/lightsabreblade.tga
		blendfunc blend
		rgbGen vertex
	}	
}
