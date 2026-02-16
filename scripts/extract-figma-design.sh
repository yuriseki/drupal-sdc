#!/bin/bash

# Figma Design Extraction Script
# This script extracts design data from a Figma URL using the figma-developer-mcp tool

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
FIGMA_API_KEY="${FIGMA_API_KEY:-figd_yYrTPj7tpb2arM8w6-em8cBrxBbhU5ur57-GAKKV}"
OUTPUT_DIR="./figma-data"
IMAGES_DIR="./assets/figma"

# Function to display usage
usage() {
    echo "Usage: $0 <figma-url> [component-name]"
    echo ""
    echo "Example:"
    echo "  $0 'https://www.figma.com/design/ZNdvmMsbzgS7O9tPFl4xV5/511-Visual-Design--WIP-?node-id=8652-70472&m=dev' hero-banner"
    echo ""
    echo "Environment variables:"
    echo "  FIGMA_API_KEY - Your Figma API key (optional if set in config)"
    exit 1
}

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Figma URL is required${NC}"
    usage
fi

FIGMA_URL="$1"
COMPONENT_NAME="${2:-component}"

echo -e "${GREEN}=== Figma Design Extraction ===${NC}"
echo "URL: $FIGMA_URL"
echo "Component name: $COMPONENT_NAME"
echo ""

# Create output directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$IMAGES_DIR/$COMPONENT_NAME"

# Check if npx is available
if ! command -v npx &> /dev/null; then
    echo -e "${RED}Error: npx is not installed. Please install Node.js and npm.${NC}"
    exit 1
fi

echo -e "${YELLOW}Extracting design data...${NC}"

# Note: The figma-developer-mcp tool is designed to run as an MCP server
# and doesn't have a simple CLI interface for direct data extraction.
#
# To use it, you would typically:
# 1. Start the MCP server
# 2. Connect to it via MCP protocol
# 3. Call the tools through the protocol
#
# For now, this script documents the process and provides placeholders
# for when the tools are properly integrated.

echo -e "${YELLOW}Note: Direct CLI extraction is not supported by figma-developer-mcp.${NC}"
echo -e "${YELLOW}This tool requires MCP server integration.${NC}"
echo ""
echo -e "${GREEN}Alternative approaches:${NC}"
echo "1. Use the Figma REST API directly:"
echo "   curl -H 'X-Figma-Token: YOUR_TOKEN' https://api.figma.com/v1/files/FILE_KEY"
echo ""
echo "2. Fill out the template manually:"
echo "   code-instruction/figma-design-info-template.md"
echo ""
echo "3. Use Claude Code with MCP integration (recommended):"
echo "   The MCP server should be configured in your Claude Code settings"

# Example of what could be done with direct API access
extract_with_api() {
    local FILE_KEY="$1"
    local NODE_ID="$2"

    echo -e "${YELLOW}Extracting via Figma API...${NC}"

    # Extract file key and node ID from URL
    # This is a simplified example - actual URL parsing would be more complex

    # Get file data
    FILE_DATA=$(curl -s -H "X-Figma-Token: $FIGMA_API_KEY" \
        "https://api.figma.com/v1/files/$FILE_KEY?ids=$NODE_ID")

    if [ $? -eq 0 ]; then
        echo "$FILE_DATA" > "$OUTPUT_DIR/${COMPONENT_NAME}-raw.json"
        echo -e "${GREEN}✓ Raw data saved to $OUTPUT_DIR/${COMPONENT_NAME}-raw.json${NC}"
    else
        echo -e "${RED}✗ Failed to fetch data from Figma API${NC}"
    fi
}

# Parse URL to extract file key and node ID
parse_figma_url() {
    local url="$1"

    # Extract file key (between /design/ and /?)
    FILE_KEY=$(echo "$url" | sed -n 's/.*\/design\/\([^/]*\).*/\1/p')

    # Extract node ID (after node-id=)
    NODE_ID=$(echo "$url" | sed -n 's/.*node-id=\([^&]*\).*/\1/p')

    echo "File Key: $FILE_KEY"
    echo "Node ID: $NODE_ID"

    if [ -n "$FILE_KEY" ] && [ -n "$NODE_ID" ]; then
        extract_with_api "$FILE_KEY" "$NODE_ID"
    else
        echo -e "${RED}Error: Could not parse Figma URL${NC}"
        return 1
    fi
}

# Try to parse and extract
parse_figma_url "$FIGMA_URL"

echo ""
echo -e "${GREEN}=== Next Steps ===${NC}"
echo "1. Review the template: code-instruction/figma-design-info-template.md"
echo "2. Fill in the design details from Figma"
echo "3. Provide the completed information to create the SDC component"
echo ""
echo -e "${YELLOW}For MCP-based extraction, use Claude Code with the figma-expert agent${NC}"
