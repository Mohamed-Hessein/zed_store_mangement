#!/bin/bash
# Quick Test Script for Zed Store Management App

echo "🧪 Starting Test Suite"
echo "======================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Clean
echo -e "${YELLOW}Step 1: Cleaning...${NC}"
flutter clean
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Clean successful${NC}"
else
    echo -e "${RED}❌ Clean failed${NC}"
    exit 1
fi

echo ""

# Step 2: Get dependencies
echo -e "${YELLOW}Step 2: Getting dependencies...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies fetched${NC}"
else
    echo -e "${RED}❌ Dependency fetch failed${NC}"
    exit 1
fi

echo ""

# Step 3: Run build runner
echo -e "${YELLOW}Step 3: Running build runner...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build runner successful${NC}"
else
    echo -e "${RED}❌ Build runner failed${NC}"
    exit 1
fi

echo ""

# Step 4: Run the app
echo -e "${YELLOW}Step 4: Launching app...${NC}"
echo -e "${YELLOW}Make sure your device/emulator is connected!${NC}"
echo ""
flutter run -v

echo ""
echo -e "${GREEN}✅ Test script completed!${NC}"
echo -e "${YELLOW}Check the console output above for any issues.${NC}"

