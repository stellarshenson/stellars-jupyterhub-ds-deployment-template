#!/bin/bash
# Cleanup Docker resources to reclaim disk space
# Usage: ./cleanup.sh [--all]
#   --all: also remove stopped containers and their writable layers

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=== Docker Disk Usage ===${NC}"
docker system df
echo ""

# Build cache
echo -e "${YELLOW}Pruning build cache...${NC}"
docker builder prune -a -f
echo ""

# Dangling images (untagged)
echo -e "${YELLOW}Pruning dangling images...${NC}"
docker image prune -f
echo ""

# Unused images (not referenced by any container)
echo -e "${YELLOW}Pruning unused images...${NC}"
docker image prune -a -f
echo ""

# Unused networks
echo -e "${YELLOW}Pruning unused networks...${NC}"
docker network prune -f
echo ""

if [[ "$1" == "--all" ]]; then
    echo -e "${RED}Removing stopped containers...${NC}"
    docker container prune -f
    echo ""

    echo -e "${RED}Pruning all unused images (post container removal)...${NC}"
    docker image prune -a -f
    echo ""

    echo -e "${RED}Removing unused volumes (NOT user data)...${NC}"
    docker volume prune -f
    echo ""
fi

echo -e "${GREEN}=== Docker Disk Usage After Cleanup ===${NC}"
docker system df
