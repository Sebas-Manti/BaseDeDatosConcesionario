#!/bin/bash

echo "=============================="
echo "🔍 CHECK SISTEMA CONCESIONARIO"
echo "=============================="

echo ""
echo "➡️ 1. Verificando estado de NGINX..."
systemctl is-active --quiet nginx
if [ $? -eq 0 ]; then
    echo "   ✔️ NGINX está activo"
else
    echo "   ❌ NGINX está DETENIDO"
fi

echo ""
echo "➡️ 2. Verificando puerto 80 (frontend)..."
ss -tulnp | grep ':80 ' >/dev/null
if [ $? -eq 0 ]; then
    echo "   ✔️ Puerto 80 abierto (frontend ok)"
else
    echo "   ❌ Puerto 80 NO está escuchando"
fi

echo ""
echo "➡️ 3. Verificando si el backend está corriendo (uvicorn)..."
pgrep -f "uvicorn" >/dev/null
if [ $? -eq 0 ]; then
    echo "   ✔️ Backend (uvicorn) activo"
else
    echo "   ❌ Backend NO está corriendo"
fi

echo ""
echo "➡️ 4. Verificando si backend escucha en 8001..."
ss -tulnp | grep ':8001 ' >/dev/null
if [ $? -eq 0 ]; then
    echo "   ✔️ Puerto 8001 abierto (backend ok)"
else
    echo "   ❌ Puerto 8001 NO está escuchando"
fi

echo ""
echo "➡️ 5. Probando endpoint interno del backend (127.0.0.1:8001/queue)..."
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8001/queue | grep "200" >/dev/null
if [ $? -eq 0 ]; then
    echo "   ✔️ Backend responde correctamente"
else
    echo "   ❌ Backend NO está respondiendo directamente"
fi

echo ""
echo "➡️ 6. Probando proxy de NGINX (127.0.0.1/api/queue)..."
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1/api/queue | grep "200" >/dev/null
if [ $? -eq 0 ]; then
    echo "   ✔️ Nginx está proxyando /api correctamente"
else
    echo "   ❌ Nginx NO está enviando tráfico al backend (502 probable)"
fi

echo ""
echo "=============================="
echo "✔️ CHECK TERMINADO"
echo "=============================="
