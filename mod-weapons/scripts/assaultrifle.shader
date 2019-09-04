textures/g3-cycle
{
	nopicmip
	nomipmaps
	dpoffsetmapping - 3.61243076174373324752 match8 167.12285800000000000000
	dpglossintensitymod  2
	dpglossexponentmod  4
	dpreflectcube cubemaps/default/sky
	{
		map textures/g3-cycle/cycling
		animmap 12.732395 textures/g3-cycle/cycling textures/g3-cycle/cycling-1 textures/g3-cycle/cycling-2 textures/g3-cycle/cycling-3 textures/g3-cycle/cycling-4 textures/g3-cycle/cycling-5 textures/g3-cycle/cycling-6 textures/g3-cycle/cycling-7 textures/g3-cycle/cycling-8 textures/g3-cycle/cycling-9 textures/g3-cycle/cycling-10 textures/g3-cycle/cycling-11 textures/g3-cycle/cycling-12 textures/g3-cycle/cycling-13 textures/g3-cycle/cycling-14 textures/g3-cycle/cycling-15 textures/g3-cycle/cycling-16 textures/g3-cycle/cycling-17 textures/g3-cycle/cycling-18 textures/g3-cycle/cycling-19 textures/g3-cycle/cycling-20 textures/g3-cycle/cycling-21 textures/g3-cycle/cycling-22 textures/g3-cycle/cycling-23 textures/g3-cycle/cycling-24 textures/g3-cycle/cycling-25 textures/g3-cycle/cycling-26 textures/g3-cycle/cycling-27 textures/g3-cycle/cycling-28 textures/g3-cycle/cycling-29 textures/g3-cycle/cycling-30 textures/g3-cycle/cycling-31 textures/g3-cycle/cycling-32 textures/g3-cycle/cycling-33 textures/g3-cycle/cycling-34 textures/g3-cycle/cycling-35 textures/g3-cycle/cycling-36 textures/g3-cycle/cycling-37 textures/g3-cycle/cycling-38 textures/g3-cycle/cycling-39
		tcmod scroll 0.36787944 0.043213918
	}
	{
		map $lightmap
		blendfunc filter
	}
}

textures/g3-starry
{
	nopicmip
	nomipmaps
	dpreflectcube env/starry/starry

	{
		map textures/g3-starry
	}

	{
		map $lightmap
		rgbGen identity
		tcGen lightmap
		blendfunc filter
	}
}

textures/g3-gold
{
	{
		map textures/tuba
		tcgen environment
	}
	{
		map $lightmap
	}
}
textures/g3-goldplain
{
	{
		map textures/tuba
	}
	{
		map $lightmap
	}
}
