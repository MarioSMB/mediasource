// empty
textures/empty
{
    //cull none
    surfaceparm nopicmip
	surfaceparm notrans
	{
		map textures/empty
		//depthWrite
		alphaFunc GT0
		rgbgen vertex
	}
}
