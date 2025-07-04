﻿#ifndef OPATOON_PASS_SHADOW_CASTER_INCLUDED
#define OPATOON_PASS_SHADOW_CASTER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct ShadowCasterAttributes
{
    float4 positionOS   : POSITION;
};

struct ShadowCasterVaryings
{
    float4 positionCS  : SV_POSITION;
};

ShadowCasterVaryings vert_shadowCaster(ShadowCasterAttributes IN)
{
    ShadowCasterVaryings OUT;
    VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS);
    OUT.positionCS = positionInputs.positionCS;
    return OUT;
}

half4 frag_shadowCaster(ShadowCasterVaryings IN) : SV_Target
{
    return half4(0,0,0,1);
}


#endif