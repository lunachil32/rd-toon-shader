#ifndef OPA_TOON_INPUT_INCLUDED
#define OPA_TOON_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

TEXTURE2D(_LookUpTex);
SAMPLER(sampler_LookUpTex);

TEXTURE2D(_NormalTex);
SAMPLER(sampler_NormalTex);

TEXTURE2D(_OcclusionTex);
SAMPLER(sampler_OcclusionTex);

// Outline
TEXTURE2D(_OutlineMaskTex);
SAMPLER(sampler_OutlineMaskTex);

CBUFFER_START(UnityPerMaterial)
    float4 _MainTex_ST;
    float _NormalTexFactor;
    float _InverseACES;

// Outline
    half4 _OutlineColor;
    float _OutlineOffsetOS;
    float _OutlineOffsetVS;
CBUFFER_END

#endif