shader_type canvas_item;

uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_pixels : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    // Get the size of the texture in pixels
    vec2 texture_size = vec2(textureSize(TEXTURE, 0));
    
    // Convert UV to pixel coordinates
    vec2 pixel_pos = UV * texture_size;
    
    // Calculate center in pixel coordinates
    vec2 center_pixels = texture_size * 0.5;
    
    // Fixed radius of 62.5 pixels (125/2 diameter)
    float radius_pixels = 62.5;
    
    // Calculate distance in pixels
    float dist = distance(pixel_pos, center_pixels);
    
    // Get the current color
    vec4 color = texture(TEXTURE, UV);
    
    // Create mask based on fixed pixel radius
    float mask = step(dist, radius_pixels);
    
    // Create border with fixed pixel width
    float border = step(dist, radius_pixels) - step(dist, radius_pixels - border_pixels);
    
    // Apply mask to alpha channel
    color.a *= mask;
    
    // Mix in the border
    COLOR = mix(color, border_color, border);
}