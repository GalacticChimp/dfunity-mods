    Shader "Daggerfall/RealtimeReflections/CombineReflectionTextures"
    {
        Properties
        {
            _MainTex ("Base (RGB)", 2D) = "white" {}
			_ReflTex ("Base (RGB)", 2D) = "white" {}
			_ObliqueProjectedTex ("Base (RGB)", 2D) = "white" {}
        }
        SubShader
        {            
            LOD 100
			//ZWrite Off 
			//Blend One One 
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
     
            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
           
                #include "UnityCG.cginc"

				sampler2D _MainTex;
				sampler2D _ReflTex;
				sampler2D _ObliqueProjectedTex;
     
                //struct appdata
                //{
                //    float4 vertex : POSITION;
                //};
     
                struct v2f
                {
                    float4 vertex : SV_POSITION;
					float2 uv : TEXCOORD0;
                };
           
                v2f vert (appdata_base v)
                {
                    v2f o;
					//UNITY_INITIALIZE_OUTPUT(v2f, o);
                    o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord.xy;				
                    return o;
                }
           
                fixed4 frag (v2f i) : SV_Target
                {
                    fixed4 color = tex2D(_ReflTex, i.uv); //fixed4(1.0f, 0.0f, 0.0f, 0.5f);
					fixed4 obliqueProjRefl = tex2D(_ObliqueProjectedTex, i.uv);
					bool passed = (obliqueProjRefl.r > 0.0f) | (obliqueProjRefl.g != 0.0f) | (obliqueProjRefl.b != 0.0f);
					if (passed)
						return color;
					else
						return fixed4(0.5f, 0.5f, 0.5f, 1.0f);
                }
                ENDCG
            }
        }
    }
     
