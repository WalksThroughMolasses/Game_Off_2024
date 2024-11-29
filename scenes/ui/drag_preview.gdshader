shader_type canvas_item;

uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_width_px = 5.0;

void fragment() {
    // Get the size of the control in pixels
    vec2 pixel_size = 1.0/TEXTURE_PIXEL_SIZE;
    
    // Scale factor adjustment
    float scale_factor = 2.0;
    
    // Convert border width from pixels to UV space with scaling
    float border_width = (border_width_px * scale_factor) / min(pixel_size.x, pixel_size.y);
    
    // Convert UV to centered coordinates (-1 to 1)
    vec2 centered_uv = (UV * 2.0) - 1.0;
    
    // Calculate distance from center
    float dist = length(centered_uv);
    
    // Create image circle
    float image_mask = smoothstep(1.0 + 0.01, 1.0 - 0.01, dist);
    
    // Create outer border
    float border = smoothstep(1.0 + border_width + 0.01, 1.0 + border_width - 0.01, dist) 
                  - smoothstep(1.0 + 0.01, 1.0 - 0.01, dist);
    
    // Get the texture color
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Apply the image mask to the texture
    vec4 masked_texture = texture_color * image_mask;
    
    // Add the border
    COLOR = masked_texture + (border_color * border);
    COLOR.a = max(masked_texture.a, border);
}