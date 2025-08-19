#!/bin/bash
set -e

# Archon Good Morning Script
# Purpose: Automated daily startup sequence for Archon microservices

echo "🌅 Good morning! Starting Archon for the day..."
echo ""

# Step 1: Ensure Docker Desktop is running
echo "1️⃣ Checking Docker status..."
if ! docker info > /dev/null 2>&1; then
    echo "   Docker not running, starting Docker Desktop..."
    open /Applications/Docker.app
    echo "   Waiting for Docker to start..."
    sleep 15
    
    # Wait up to 60 seconds for Docker to be ready
    for i in {1..12}; do
        if docker info > /dev/null 2>&1; then
            break
        fi
        echo "   Still waiting for Docker... ($i/12)"
        sleep 5
    done
    
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker failed to start after 60 seconds"
        echo "   Please start Docker Desktop manually and try again"
        exit 1
    fi
fi

docker_version=$(docker --version)
echo "   ✅ Docker ready: $docker_version"
echo ""

# Step 2: Navigate to project directory
echo "2️⃣ Navigating to Archon directory..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"
echo "   ✅ Working directory: $(pwd)"
echo ""

# Step 3: Stop existing containers and restart
echo "3️⃣ Restarting Archon services..."
echo "   Stopping existing containers..."
docker-compose down > /dev/null 2>&1 || true

echo "   Building and starting services..."
docker-compose up --build -d

echo "   ✅ Services started"
echo ""

# Step 4: Wait for services to be ready
echo "4️⃣ Waiting for services to initialize..."
sleep 10

# Step 5: Health validation
echo "5️⃣ Validating service health..."

# Check UI (3737)
if curl -s http://localhost:3737 > /dev/null; then
    echo "   ✅ UI (3737) - Ready"
else
    echo "   ⚠️ UI (3737) - Not responding"
fi

# Check Server (8181)
if curl -s http://localhost:8181/health > /dev/null; then
    echo "   ✅ Server (8181) - Healthy"
else
    echo "   ⚠️ Server (8181) - Not healthy"
fi

# Check MCP Server (8051) 
if curl -s http://localhost:8051 > /dev/null; then
    echo "   ✅ MCP (8051) - Running"
else
    echo "   ⚠️ MCP (8051) - Not responding"
fi

# Check Agents (8052)
if curl -s http://localhost:8052/health > /dev/null; then
    echo "   ✅ Agents (8052) - Healthy"
else
    echo "   ⚠️ Agents (8052) - Not healthy"
fi

echo ""

# Step 6: Show container status
echo "6️⃣ Container status:"
docker-compose ps

echo ""
echo "🌅 Good morning! Archon is ready for the day!"
echo ""
echo "📱 Web UI:    http://localhost:3737"
echo "🔌 MCP Server: http://localhost:8051"  
echo "⚙️ API Server: http://localhost:8181"
echo "🤖 Agents:    http://localhost:8052"
echo ""
echo "Next steps:"
echo "• Configure API keys in Settings"
echo "• Upload documents or crawl websites"
echo "• Connect your AI coding assistant via MCP"
echo ""