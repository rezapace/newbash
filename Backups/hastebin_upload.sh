#!/bin/bash

hb() {
    local url="https://hastebin.com/documents"
    local file="$1"
    local token="04e09728ee2b9ed5a92a365274009ccbb1b6a5edcf0674e155f91bb263653bba97da8c1f84bf967fd4c3d37aa2828270c09d5d5780b3f4992a329198ec48d4fa"

    if [ -z "$file" ]; then
        echo "Usage: hb <file>"
        return 1
    fi

    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi

    response=$(curl -s -X POST "$url" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: text/plain" \
        --data-binary "@$file")

    echo "Server response: $response"

    key=$(echo $response | jq -r .key)
    if [ -z "$key" ] || [ "$key" == "null" ]; then
        echo "Error: $response"
    else
        echo "Document URL: https://hastebin.com/$key"
        echo "Raw document URL: https://hastebin.com/raw/$key"
        echo ""
        echo "To view the document, use the following curl command:"
        echo "curl -H \"Authorization: Bearer $token\" https://hastebin.com/raw/$key"
    fi
}

echo "Enter the path of the text file you want to upload:"
read file_path
hb "$file_path"