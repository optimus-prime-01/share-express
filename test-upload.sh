#!/bin/bash

# Quick Test Script for ShareXpress
# Usage: ./test-upload.sh

echo "🧪 ShareXpress Testing Script"
echo "=============================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="http://localhost:3000"

# Test 1: Check if server is running
echo "1️⃣  Testing server connection..."
if curl -s "$BASE_URL" > /dev/null; then
    echo -e "${GREEN}✅ Server is running${NC}"
else
    echo -e "${RED}❌ Server is not running. Please start the server first.${NC}"
    exit 1
fi
echo ""

# Test 2: Create a test file
echo "2️⃣  Creating test file..."
TEST_FILE="test-file-$(date +%s).txt"
echo "This is a test file for ShareXpress" > "$TEST_FILE"
echo -e "${GREEN}✅ Test file created: $TEST_FILE${NC}"
echo ""

# Test 3: Upload file
echo "3️⃣  Uploading file..."
UPLOAD_RESPONSE=$(curl -s -X POST "$BASE_URL/api/files" -F "myfile=@$TEST_FILE")
echo "Response: $UPLOAD_RESPONSE"
echo ""

# Extract UUID from response
UUID=$(echo "$UPLOAD_RESPONSE" | grep -o 'files/[^"]*' | cut -d'/' -f2)

if [ -z "$UUID" ]; then
    echo -e "${RED}❌ Upload failed. Could not extract UUID.${NC}"
    rm -f "$TEST_FILE"
    exit 1
fi

echo -e "${GREEN}✅ File uploaded successfully!${NC}"
echo "UUID: $UUID"
echo ""

# Test 4: Test show page
echo "4️⃣  Testing download page..."
SHOW_RESPONSE=$(curl -s "$BASE_URL/files/$UUID")
if echo "$SHOW_RESPONSE" | grep -q "ready to download"; then
    echo -e "${GREEN}✅ Download page accessible${NC}"
else
    echo -e "${YELLOW}⚠️  Download page might have issues${NC}"
fi
echo ""

# Test 5: Test download
echo "5️⃣  Testing file download..."
DOWNLOAD_FILE="downloaded-$TEST_FILE"
curl -s -o "$DOWNLOAD_FILE" "$BASE_URL/files/download/$UUID"

if [ -f "$DOWNLOAD_FILE" ]; then
    if cmp -s "$TEST_FILE" "$DOWNLOAD_FILE"; then
        echo -e "${GREEN}✅ File downloaded successfully and matches original!${NC}"
        rm -f "$DOWNLOAD_FILE"
    else
        echo -e "${RED}❌ Downloaded file doesn't match original${NC}"
    fi
else
    echo -e "${RED}❌ Download failed${NC}"
fi
echo ""

# Cleanup
echo "6️⃣  Cleaning up..."
rm -f "$TEST_FILE"
echo -e "${GREEN}✅ Test completed!${NC}"
echo ""
echo "📋 Summary:"
echo "   Upload URL: $BASE_URL/api/files"
echo "   Show URL: $BASE_URL/files/$UUID"
echo "   Download URL: $BASE_URL/files/download/$UUID"
echo ""

