foot
{
	qer_editorimage textures/monty/foot
	surfaceparm alphashadow
	deformVertexes autoSprite2
	surfaceparm nonsolid
	surfaceparm nodlight
	surfaceparm nolightmap
	q3map_noclip
	q3map_notjunc
	cull disable
	{
		map textures/monty/foot
		rgbGen identity
		depthWrite
		alphaFunc GE128
	}
	{
		map $lightmap
		blendfunc filter
		rgbGen identity
		tcGen lightmap
		depthFunc equal
	}
}
