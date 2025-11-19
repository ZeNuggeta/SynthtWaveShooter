shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color = vec4(1., 1., 1., 1.);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0, 128) = 1.0;
uniform float roughness : hint_range(0, 1) = 1.0;
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel = vec4(0., 0., 0., 0.);
uniform sampler2D texture_roughness : hint_roughness_g, filter_linear_mipmap, repeat_enable;
uniform float specular = 0.5;
uniform float metallic = 1.0;
uniform sampler2D texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_scale : hint_range(-16, 16) = 1.0;

uniform vec3 uv1_scale = vec3(1., 1., 1.);
uniform vec3 uv1_offset = vec3(0., 0., 0.);
uniform vec3 uv2_scale = vec3(1., 1., 1.);
uniform vec3 uv2_offset = vec3(0., 0., 0.);

uniform float FOV : hint_range(20, 120) = 68; // FOV handling from the first shader

void vertex() {
    // Apply UV scaling and offset
    UV = UV * uv1_scale.xy + uv1_offset.xy;

    // Compute the projection matrix based on the FOV
    float scale = 1.0 / tan(FOV * 0.5 * PI / -180.0);
    PROJECTION_MATRIX[0][0] = scale / (-VIEWPORT_SIZE.x / VIEWPORT_SIZE.y);
    PROJECTION_MATRIX[1][1] = scale;

    // Apply the standard transformation
    POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX.xyz, 1.0);
}

void fragment() {
    vec2 base_uv = UV;

    // Base albedo and texture
    vec4 albedo_tex = texture(texture_albedo, base_uv);
    ALBEDO = albedo.rgb * albedo_tex.rgb;

    // Metallic and texture
    float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
    METALLIC = metallic_tex * metallic;

    // Roughness and texture
    vec4 roughness_texture_channel = vec4(0.0, 1.0, 0.0, 0.0);
    float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
    ROUGHNESS = roughness_tex * roughness;

    // Specular
    SPECULAR = specular;

    // Normal mapping
    NORMAL_MAP = texture(texture_normal, base_uv).rgb;
    NORMAL_MAP_DEPTH = normal_scale;
}