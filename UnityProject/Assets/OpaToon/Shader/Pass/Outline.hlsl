#ifndef OPATOON_PASS_OUTLINE_INCLUDED
#define OPATOON_PASS_OUTLINE_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "../OpaToonInput.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normal       : NORMAL;
    float2 texcoord0    : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
};

Varyings vert_outline(Attributes IN)
{
    Varyings OUT;
    
    half4 outlineMask = SAMPLE_TEXTURE2D_LOD(_OutlineMaskTex, sampler_OutlineMaskTex, IN.texcoord0, 0);
    IN.positionOS += float4(IN.normal * 0.01 * _OutlineOffsetOS * outlineMask.r, 1.0f);

    VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS);
    float3 normalWS = TransformObjectToWorldNormal(IN.normal);
    float3 normalVS = normalize(TransformWorldToViewDir(normalWS));
    float4 outlineOffset = float4(normalVS * outlineMask.r, 0.0f) * _OutlineOffsetVS * 0.01f * abs(positionInputs.positionVS.z);
    OUT.positionCS = TransformWViewToHClip(positionInputs.positionVS + outlineOffset);
    
    return OUT;
}
            
half4 frag_outline(Varyings IN) : SV_Target
{
    return half4(0,0,0,1);
}

#endif