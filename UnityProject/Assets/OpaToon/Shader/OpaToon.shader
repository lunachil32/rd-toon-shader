Shader "Opabinia/OpaToon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        [Toggle] __DEBUG_NORMAL ("[Debug] normal", float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            Name "Forward"
            Tags { "LightMode"="UniversalForward" }
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature_local _ __DEBUG_NORMAL_ON
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
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
                float3 normalWS     : NORMAL;
                float2 texcoord0    : TEXCOORD0;
            };
            
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS);
                OUT.positionCS = positionInputs.positionCS;
                VertexNormalInputs normalInputs = GetVertexNormalInputs(IN.normal, IN.tangent);
                OUT.normalWS = normalInputs.normalWS;
                OUT.texcoord0 = TRANSFORM_TEX(IN.texcoord0, _MainTex);
                return OUT;
            }
            
            half4 frag(Varyings IN) : SV_Target
            {
                half4 mainTexColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.texcoord0);

                #ifdef __DEBUG_NORMAL_ON
                return half4(IN.normalWS,1.0f);
                #endif
                
                return mainTexColor;
            }
            ENDHLSL
        }
    }
}
