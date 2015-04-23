models/conquest/flag
{
	dpmeshcollisions
	dpglossintensitymod 1
	dpglossexponentmod 1
	{
		map "models/conquest/flag"
	}
	{
		map $lightmap
	}
}

models/conquest/flag_cloth
{
	dpmeshcollisions
	dpglossintensitymod 1
	dpglossexponentmod 4
	cull none
	{
		map "models/conquest/flag_cloth"
	}
	{
		map $lightmap
	}
}

models/conquest/flag_laser
{
	dpmeshcollisions
	dpglossintensitymod 1
	dpglossexponentmod 1
	deformVertexes autosprite2
	cull none
	{
		map "models/conquest/flag_laser"
		blendfunc add
	}
	{
		map $lightmap
	}
}

models/conquest/stand
{
	dpmeshcollisions
	dpglossintensitymod 1
	dpglossexponentmod 1
	{
		map "models/conquest/stand"
	}
	{
		map $lightmap
	}
}

