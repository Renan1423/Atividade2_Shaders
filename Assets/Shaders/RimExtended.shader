Shader "Custom/RimExtended"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap ("Normal Map (RGB)", 2D) = "bump" {}
        _RimColor ("Rim Color", Color) = (1.0, 1.0, 1.0, 0.0)
        _RimStrength ("Rim Strength", Range(1.0, 4.0)) = 1.45
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard Lambert

        sampler2D _MainTex;
        sampler2D _NormalMap;
        float4 _RimColor;
        float _RimConcentration;
        float _RimStrength;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 viewDir;
        };

        void surf (Input In, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, In.uv_MainTex);
            float Lc = saturate(dot(normalize(In.viewDir), o.Normal));
            half rim = 1.0 - Lc;

            o.Normal = UnpackNormal(tex2D(_NormalMap, In.uv_NormalMap));
            o.Alpha = c.a;
            o.Albedo = c.rgb;
            o.Emission = _RimStrength * (_RimColor.rgb * smoothstep(0.2, 0.6, rim));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
