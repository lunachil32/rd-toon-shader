Shader "Opabinia/OpaToon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LookUpTex("LUT", 2D) = "white" {}
        _InverseACES("Inverse ACES", Float) = 1.0
        
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
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Library/ACES.hlsl"
            #include "OpaToonInput.hlsl"
            
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

                Light mainLight = GetMainLight();
                float diffuse = dot(IN.normalWS, mainLight.direction);
                float halfLambert = diffuse * 0.5 + 0.5;
                
                half4 lookUpTexColor = SAMPLE_TEXTURE2D(_LookUpTex, sampler_LookUpTex, half2(halfLambert, 0.0f));
                mainTexColor = lerp(mainTexColor * lookUpTexColor, mainTexColor, saturate(diffuse));

                #ifdef __DEBUG_NORMAL_ON
                return half4(IN.normalWS,1.0f);
                #endif

                mainTexColor.rgb = lerp(mainTexColor.rgb, InverseACES(mainTexColor.rgb), _InverseACES);
                
                return mainTexColor;
            }
            ENDHLSL
        }
    }
}
