#!/bin/bash

# Function to get embed code and copy to clipboard
get_embed_code() {
    local youtube_url=$1

    # Extract the video ID from the URL
    if [[ $youtube_url =~ youtube\.com ]]; then
        video_id=$(echo $youtube_url | grep -oP 'v=\K[^&]+')
    elif [[ $youtube_url =~ youtu\.be ]]; then
        video_id=$(echo $youtube_url | awk -F'[/?]' '{print $4}')
    else
        echo "Invalid YouTube URL"
        return 1
    fi

    # Construct the embed URL
    embed_url="https://www.youtube.com/embed/${video_id}"
    
    # Create the embed code
    embed_code="<iframe width=\"560\" height=\"315\" src=\"${embed_url}\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" referrerpolicy=\"strict-origin-when-cross-origin\" allowfullscreen></iframe>"
    
    # Copy the embed code to clipboard
    echo "$embed_code" | xclip -selection clipboard
    echo "Embed code copied to clipboard!"
}

# Check if URL is passed as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube URL>"
    exit 1
fi

# Call the function with the provided URL
get_embed_code "$1"
