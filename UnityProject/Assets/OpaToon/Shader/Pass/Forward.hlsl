#ifndef OPATOON_PASS_FORWARD_INCLUDED
#define OPATOON_PASS_FORWARD_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "../OpaToonInput.hlsl"
#include "../Library/ACES.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float4 color        : COLOR;
    float3 normal       : NORMAL;
    float4 tangent      : TANGENT;
    float2 texcoord0    : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float4 color        : COLOR;
    float2 texcoord0    : TEXCOORD0;
    float3 positionWS   : TEXCOORD2;
    float3 normalOS     : TEXCOORD3;
    float4 tangentOS    : TEXCOORD4;
};

Varyings vert(Attributes IN)
{
    Varyings OUT;

    OUT.color = IN.color;
    
    OUT.normalOS = IN.normal;
    OUT.tangentOS = IN.tangent;
    
    VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS);
    OUT.positionWS = positionInputs.positionWS;
    OUT.positionCS = positionInputs.positionCS;
    
    OUT.texcoord0 = TRANSFORM_TEX(IN.texcoord0, _MainTex);
    
    return OUT;
}
            
half4 frag(Varyings IN) : SV_Target
{
    VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normalOS, IN.tangentOS);
    float3x3 TBN = float3x3(normalInputs.tangentWS, normalInputs.bitangentWS, normalInputs.normalWS);
    float4 normalTexColor = SAMPLE_TEXTURE2D(_NormalTex, sampler_NormalTex, IN.texcoord0);
    float3 normalTS = UnpackNormal(normalTexColor);
    normalTS = lerp(float3(0, 0, 1), normalTS, _NormalTexFactor);
    float3 normalWS = normalize(mul(normalTS, TBN));
    
    half4 mainTexColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.texcoord0);

    Light mainLight = GetMainLight();
    float diffuse = dot(normalWS, mainLight.direction);
    float halfLambert = diffuse * 0.5 + 0.5;
                
    half4 lookUpTexColor = SAMPLE_TEXTURE2D(_LookUpTex, sampler_LookUpTex, half2(diffuse, 0.0f));
    float occlusion = SAMPLE_TEXTURE2D(_OcclusionTex, sampler_OcclusionTex, IN.texcoord0).r;
    occlusion = pow(occlusion, _OcclusionTexPowFactor);
    mainTexColor = lerp(mainTexColor * lookUpTexColor, mainTexColor, min(halfLambert, occlusion));

    float3 viewDirWS = normalize(_WorldSpaceCameraPos - IN.positionWS);
    float3 lightDir = normalize(mainLight.direction);
    float3 reflectDir = reflect(-lightDir, normalWS);
    float specular = pow(saturate(dot(viewDirWS, reflectDir)), 6.0f);

    #ifdef __DEBUG_SPECULAR_ON
    return half4(specular,specular,specular,1.0f);
    #endif

    mainTexColor = lerp(mainTexColor, half4(1.0f,1.0f,1.0f,1.0f), specular);

    #ifdef __DEBUG_NORMAL_ON
        return half4(normalWS,1.0f);
    #endif

    #ifdef __DEBUG_TANGENT_ON
        return half4(IN.tangentWS,1.0f);
    #endif

    #ifdef __DEBUG_VTXCOLOR_ON
        return half4(IN.color);
    #endif
    
    mainTexColor.rgb = lerp(mainTexColor.rgb, InverseACES(mainTexColor.rgb), _InverseACES);
                
    return mainTexColor;
}

#endif