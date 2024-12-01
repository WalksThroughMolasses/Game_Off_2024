shader_type canvas_item;

uniform sampler2D mask_texture;
uniform float smoothness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Get the color from the main texture (your sprite)
    vec4 main_tex = texture(TEXTURE, UV);
    
    // Get the mask value (using R channel since we're going from black to white)
    float mask = texture(mask_texture, UV).a;
    
    // Apply smoothness to the mask edge
    float smooth_mask = smoothstep(0.0, smoothness, mask);
    
    // Apply the mask to the main texture's alpha
    main_tex.a *= smooth_mask;
    
    COLOR = main_tex;
}