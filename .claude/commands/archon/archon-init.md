# /init - Archon Startup Command

**Purpose**: Automated startup sequence for Archon microservices with Docker restart and health validation.

**Use Cases**:
- Daily startup routine for development work
- Recovery from connection problems or service failures  
- Clean restart after system changes or Docker issues
- Quick validation that all services are healthy

## Command Execution

```bash
# Start Docker Desktop if not running
open /Applications/Docker.app

# Wait for Docker to be ready
sleep 15 && docker --version

# Navigate to Archon directory and restart services
cd /Users/cjnv3/Documents/Archon-one/Archon-one
docker-compose down
docker-compose up --build -d

# Check service status
docker-compose ps

# Health validation
curl -s http://localhost:3737 > /dev/null && echo "✅ UI (3737) - Ready"
curl -s http://localhost:8181/health > /dev/null && echo "✅ Server (8181) - Healthy" 
curl -s http://localhost:8051 > /dev/null && echo "✅ MCP (8051) - Running"
curl -s http://localhost:8052/health > /dev/null && echo "✅ Agents (8052) - Healthy"

echo ""
echo "🚀 Archon is ready!"
echo "📱 UI: http://localhost:3737"
echo "🔌 MCP: http://localhost:8051"
echo "⚙️ API: http://localhost:8181"
```

## Service Architecture

**Microservices Started**:
- **Frontend (3737)**: React UI for knowledge management and project dashboard
- **Server (8181)**: FastAPI backend with Socket.IO for real-time updates  
- **MCP Server (8051)**: Model Context Protocol interface for AI coding assistants
- **Agents (8052)**: PydanticAI agents for document processing and RAG operations

**Docker Network**: `archon-one_app-network` with inter-service communication

## Prerequisites Verified

- Docker Desktop installed and running
- Environment variables configured in `.env`
- Supabase database setup with `migration/complete_setup.sql`
- All required ports available (3737, 8181, 8051, 8052)

## Troubleshooting

**If Docker fails to start**:
```bash
# Manually start Docker Desktop
open /Applications/Docker.app
# Wait longer for startup
sleep 30
```

**If services fail health checks**:
```bash
# Check logs for specific service
docker-compose logs archon-server
docker-compose logs archon-mcp
docker-compose logs archon-agents
docker-compose logs frontend
```

**If ports are occupied**:
```bash
# Check what's using the ports
lsof -i :3737
lsof -i :8181
lsof -i :8051
lsof -i :8052
```

## Next Steps After Init

1. **Configure API Keys**: Go to Settings → Select LLM provider
2. **Test Knowledge Base**: Upload a document or crawl a website
3. **Setup MCP Integration**: Copy connection config for your AI coding assistant
4. **Create Projects**: Start organizing your development work

## Command Output Expected

```
✅ UI (3737) - Ready
✅ Server (8181) - Healthy  
✅ MCP (8051) - Running
✅ Agents (8052) - Healthy

🚀 Archon is ready!
📱 UI: http://localhost:3737
🔌 MCP: http://localhost:8051
⚙️ API: http://localhost:8181
```