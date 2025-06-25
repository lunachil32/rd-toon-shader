Shader "Opabinia/OpaToon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LookUpTex("LUT", 2D) = "white" {}
        _NormalTex("Normal", 2D) = "bump" {}
        _NormalTexFactor("Normal Tex Factor", float) = 1.0
        _InverseACES("Inverse ACES", Float) = 1.0
        
        [Header(Outline)]
        _OutlineMaskTex("Outline Mask Texture", 2D) = "white" {}
        _OutlineOffsetOS("Outline Offset In object space Z axis", float) = 1.0
        _OutlineOffsetVS("Outline Offset In view space", float) = 1.0
        
        [Header(Debug)]
        [Toggle] __DEBUG_NORMAL ("[Debug] normal", float) = 0.0
        [Toggle] __DEBUG_TANGENT ("[Debug] tangent", float) = 0.0
        [Toggle] __DEBUG_VTXCOLOR ("[Debug] color", float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
        
        Pass
        {
            Name "Outline"
            CULL FRONT
            
            HLSLPROGRAM
            
            #pragma shader_feature_local _ __DEBUG_NORMAL_ON
            #pragma shader_feature_local _ __DEBUG_TANGENT_ON
            #pragma shader_feature_local _ __DEBUG_VTXCOLOR_ON

            #include "Pass/Outline.hlsl"
            
            #pragma vertex vert_outline
            #pragma fragment frag_outline
            
            ENDHLSL
        }

        Pass
        {
            Name "Forward"
            Tags { "LightMode"="UniversalForward" }
            
            HLSLPROGRAM
            
            #pragma shader_feature_local _ __DEBUG_NORMAL_ON
            #pragma shader_feature_local _ __DEBUG_TANGENT_ON
            #pragma shader_feature_local _ __DEBUG_VTXCOLOR_ON

            #include "Pass/Forward.hlsl"
            
            #pragma vertex vert
            #pragma fragment frag
            
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            
            HLSLPROGRAM
            
            #include "Pass/ShadowCaster.hlsl"
            
            #pragma vertex vert_shadowCaster
            #pragma fragment frag_shadowCaster

            ENDHLSL
        }
    }
}
