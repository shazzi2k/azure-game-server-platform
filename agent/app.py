from flask import Flask, render_template, jsonify, session, redirect, request
import os
import subprocess
import socket
import psutil
import platform
import a2s
import requests
import threading

app = Flask(__name__)



DOCKER_GAMES = {
    "zomboid": {
        "ip": "127.0.0.1",
        "port": 16261
    },
    "7days2die": {
        "ip": "127.0.0.1",
        "port": 26900
    },
    "valheim": {
        "ip": "127.0.0.1",
        "port": 2457
    }
}
VALID_CONTAINERS = [
    "zomboid",
    "7days2die",
    "valheim"
]


##TEST ENDPOINTS

@app.route("/api/health")
def health():
    return {
        "status": "online"
    }
@app.route("/")
def root():
    return {
        "service": "shazcloud-agent",
        "status": "online"
    }
##End TEST ENDPOINTS
##VM API

@app.route("/api/system")
def system():
    return {
        "hostname": socket.gethostname(),
        "cpu": psutil.cpu_percent(),
        "ram_used": round(psutil.virtual_memory().used / (1024**3), 2),
        "ram_total": round(psutil.virtual_memory().total / (1024**3), 2),
        "disk_used": round(psutil.disk_usage('/').used / (1024**3), 2),
        "disk_total": round(psutil.disk_usage('/').total / (1024**3), 2)
    }

##End VM API
##API docker containers

@app.route('/api/containers')
def get_containers():
    
    if name not in VALID_CONTAINERS:
        return jsonify({"error": "invalid container"}), 400

    result = subprocess.run(
        ["docker", "ps", "--format", "{{.Names}}"],
        capture_output=True,
        text=True
    )

    running = result.stdout.splitlines()

    containers = ["zomboid", "7days2die", "valheim"]

    status = {}
    for name in containers:
        status[name] = "running" if name in running else "stopped"

    return status

###DOCKER API CONTAINER SECTION###


@app.route('/api/docker/start/<name>', methods=['POST'])
def start_container(name):

    if name not in VALID_CONTAINERS:
        return jsonify({"error": "invalid container"}), 400
    
    result = subprocess.run(
        ["docker", "start", name],
        capture_output=True,
        text=True
    )
    
    return jsonify({"status": "started", "container": name})


@app.route('/api/docker/stop/<name>', methods=['POST'])
def stop_container(name):
    if name not in VALID_CONTAINERS:
        return jsonify({"error": "invalid container"}), 400

    result = subprocess.run(
        ["docker", "stop", name],
        capture_output=True,
        text=True
    )
      
    return jsonify({"status": "stopped", "container": name})


@app.route('/api/docker/restart/<name>', methods=['POST'])
def restart_container(name):
    if name not in VALID_CONTAINERS:
        return jsonify({"error": "invalid container"}), 400

    result = subprocess.run(
        ["docker", "restart", name],
        capture_output=True,
        text=True
    )
     
    return jsonify({"status": "restarted", "container": name})

###END DOCKER API CONTAINER SECTION###

####RUNNING THE FLASK APP####

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)