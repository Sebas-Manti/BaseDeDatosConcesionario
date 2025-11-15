async function getSchema(){
  let res = await fetch("/api/schema");
  let schema = await res.json();
  document.getElementById("diagram").textContent = JSON.stringify(schema.slice(0,50),null,2);
}

document.getElementById("gen").onclick = async ()=>{
  let prompt = document.getElementById("nl").value;
  let res = await fetch("/api/nl2sql", {method:"POST", body: JSON.stringify({prompt}), headers:{"Content-Type":"application/json"}});
  let j = await res.json();
  document.getElementById("sql").value = j.sql;
}

document.getElementById("exec_select").onclick = async ()=>{
  let sql = document.getElementById("sql").value;
  let res = await fetch("/api/exec", {method:"POST", body: JSON.stringify({sql}), headers:{"Content-Type":"application/json"}});
  let out = await res.text();
  document.getElementById("result").textContent = out;
}

document.getElementById("enqueue").onclick = async ()=>{
  let sql = document.getElementById("sql").value;
  let res = await fetch("/api/enqueue", {method:"POST", body: JSON.stringify({sql, type:"DML", user:"webuser"}), headers:{"Content-Type":"application/json"}});
  let j = await res.json();
  alert("Enqueued id: "+j.id);
}

let ws = new WebSocket((location.protocol==="https:"?"wss://":"ws://") + location.host + "/ws/queue");
ws.onmessage = (e)=>{
  let el = document.getElementById("queue");
  el.textContent += e.data + "\n";
}
getSchema();
