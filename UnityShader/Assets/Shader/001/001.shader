﻿Shader "Unlit/001"
{
    Properties //属性块
    {
        _Int("Int",Int) = 2 
        _Float("Float",float) =1.5
        _Range("Range",Range(0.0,1.0)) =1.0
        _Color("Color",Color) =(1,1,1,1)
        _Vector("Vector",Vector) =(1,4,3,8)
        _MainTex ("Texture", 2D) = "white" {} //_MainTex:变量类型名称 Texture：变量名称[面板显示名字] 这两个尽量保持一致   2D：类型[图片类型] white：默认值
        _Cube("Cube",Cube) = "white"{}
        _3D("3D",3D) ="black"{}
    }
    SubShader
    {
        //标签 可选【key = value】
        Tags { 
            "Queue" = "Transparent" //渲染顺序
            "RenderType"="Opaque"   //渲染类型 【着色器替换功能】
            "DisableBatching" = "True" //是否关闭合批
            "ForceNoShadowCasting" ="True" //是否投射阴影
            "IgnoreProjector" ="True" //收不收Projector【处理阴影的】的影响 ，通常用于透明物体
            "CanUseSpriteAltas" "False" //是否是作用于图片的Shader 通常用于UI
            "PreviewType" = "Plane" //Shader预览类型 
            }
        //可选【渲染设置】
        Cull off
        ZTest Always

        LOD 100
        //必须存在【多一个Pass通道就会增加一个Draw Call】
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
