#ifndef OPA_TOON_INPUT_INCLUDED
#define OPA_TOON_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

TEXTURE2D(_LookUpTex);
SAMPLER(sampler_LookUpTex);

TEXTURE2D(_OutlineMaskTex);
SAMPLER(sampler_OutlineMaskTex);

CBUFFER_START(UnityPerMaterial)
    float4 _MainTex_ST;
float _InverseACES;
CBUFFER_END
            
struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normal       : NORMAL;
    float4 tangent      : TANGENT;
    float2 texcoord0    : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS  : SV_POSITION;
    float2 texcoord0    : TEXCOORD0;
    float3 normalWS     : TEXCOORD1;
};

#endif