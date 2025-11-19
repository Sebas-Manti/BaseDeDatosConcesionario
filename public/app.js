const nlBox = document.getElementById("nl-box");
const sqlBox = document.getElementById("sql-box");
const resultDiv = document.getElementById("result");
const queueDiv = document.getElementById("queue");

document.getElementById("nl-to-sql").onclick = async () => {
    const res = await fetch("/api/nl2sql", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt: nlBox.value })
    });
    const data = await res.json();
    sqlBox.value = data.sql;
};

document.getElementById("run-sql").onclick = async () => {
    const res = await fetch("/api/exec", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sql: sqlBox.value })
    });
    const data = await res.json();
    if (Array.isArray(data)) {
        // Mostrar tabla
        let html = "<table border='1'><tr>";
        if (data.length > 0) {
            Object.keys(data[0]).forEach(k => html += `<th>${k}</th>`);
            html += "</tr>";
            data.forEach(row => {
                html += "<tr>";
                Object.values(row).forEach(v => html += `<td>${v}</td>`);
                html += "</tr>";
            });
        }
        html += "</table>";
        resultDiv.innerHTML = html;
    } else {
        resultDiv.textContent = JSON.stringify(data, null, 2);
    }
};

document.getElementById("enqueue-sql").onclick = async () => {
    const res = await fetch("/api/enqueue", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sql: sqlBox.value })
    });
    const data = await res.json();
    alert("SQL agregado a cola: " + data.id);
};

async function refreshQueue() {
    const res = await fetch("/api/queue");
    const data = await res.json();
    queueDiv.textContent = JSON.stringify(data, null, 2);
}

// Polling cada 2 segundos
setInterval(refreshQueue, 2000);

// Inicializar esquema MER
async function renderSchema() {
    const res = await fetch("/api/schema");
    const schema = await res.json();

    let mermaidStr = "erDiagram\n";
    const tables = {};

    schema.forEach(row => {
        if (!tables[row.TABLE_NAME]) tables[row.TABLE_NAME] = [];
        let colName = row.COLUMN_NAME.replace(/[^a-zA-Z0-9_]/g, "_");
        let colType = row.COLUMN_TYPE.replace(/[^a-zA-Z0-9_]/g, "_");
        tables[row.TABLE_NAME].push(`${colName} ${colType}`);
    });

    for (const t in tables) {
        let tableName = t.replace(/[^a-zA-Z0-9_]/g, "_");
        mermaidStr += `    ${tableName} {\n`;
        tables[t].forEach(col => mermaidStr += `        ${col}\n`);
        mermaidStr += `    }\n`;
    }

    document.getElementById("schema-mer").innerHTML = `<div class="mermaid">${mermaidStr}</div>`;

    mermaid.init(undefined, document.querySelectorAll('.mermaid'));
}

renderSchema();
