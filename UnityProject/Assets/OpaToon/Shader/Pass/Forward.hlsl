#ifndef OPATOON_PASS_FORWARD_INCLUDED
#define OPATOON_PASS_FORWARD_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "../OpaToonInput.hlsl"
#include "../Library/ACES.hlsl"

Varyings vert(Attributes IN)
{
    Varyings OUT;
    VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normal, IN.tangent);
    OUT.normalWS = normalInputs.normalWS;
    
    #ifdef _OUTLINE_ON
        half4 outlineMask = SAMPLE_TEXTURE2D_LOD(_OutlineMaskTex, sampler_OutlineMaskTex, IN.texcoord0, 0);
        IN.positionOS += float4(IN.normal * 0.01 * outlineMask.r, 1.0f);
    #endif
    
    VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS);
    OUT.positionCS = positionInputs.positionCS;
    OUT.texcoord0 = TRANSFORM_TEX(IN.texcoord0, _MainTex);
    
    return OUT;
}
            
half4 frag(Varyings IN) : SV_Target
{
    half4 mainTexColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.texcoord0);

    Light mainLight = GetMainLight();
    float diffuse = dot(IN.normalWS, mainLight.direction);
    float halfLambert = diffuse * 0.5 + 0.5;
                
    half4 lookUpTexColor = SAMPLE_TEXTURE2D(_LookUpTex, sampler_LookUpTex, half2(halfLambert, 0.0f));
    mainTexColor = lerp(mainTexColor * lookUpTexColor, mainTexColor, saturate(diffuse));

    #ifdef __DEBUG_NORMAL_ON
    return half4(IN.normalWS,1.0f);
    #endif

    mainTexColor.rgb = lerp(mainTexColor.rgb, InverseACES(mainTexColor.rgb), _InverseACES);

    #ifdef _OUTLINE_ON
        return half4(0,0,0,1);
    #endif
                
    return mainTexColor;
}

#endif