from flask import Flask, render_template, jsonify, session, redirect, request
import os
import subprocess
import socket
import psutil
import platform
import a2s
import requests
import threading
import time
import json


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
    },
    "factorio": {
        "ip": "127.0.0.1",
        "port": 34197
    }
}
VALID_CONTAINERS = [
    "zomboid",
    "7days2die",
    "valheim",
    "factorio"
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

def get_cpu_name():
    try:
        with open("/proc/cpuinfo") as f:
            for line in f:
                if "model name" in line:
                    return line.split(":")[1].strip()
    except:
        return "Unknown CPU"

@app.route("/api/system")
def system():
    return {
        "hostname": socket.gethostname(),
        "cpu_name": get_cpu_name(),
        "cpu": psutil.cpu_percent(),
        "ram_used": round(psutil.virtual_memory().used / (1024**3), 2),
        "ram_total": round(psutil.virtual_memory().total / (1024**3), 2),
        "disk_used": round(psutil.disk_usage('/').used / (1024**3), 2),
        "disk_total": round(psutil.disk_usage('/').total / (1024**3), 2)
    }

@app.route('/api/uptime')
def uptime():

    return {
        "uptime_seconds": int(time.time() - psutil.boot_time())
    }

@app.route('/api/version')
def version():

    return {
        "version": "0.2.0"
    }




##End VM API
## STart of Docker templates APIs


@app.route('/api/templates')
def templates():

    return {
        "templates": [
            "zomboid",
            "valheim",
            "factorio",
            "7days2die"
        ]
    }


@app.route('/api/deploy/<template>', methods=['POST'])
def deploy_template(template):

    valid_templates = [
        "zomboid",
        "valheim",
        "factorio",
        "7days2die"
    ]

    if template not in valid_templates:
        return jsonify({"error": "invalid template"}), 400

    template_path = f"/srv/platform/templates/{template}"

    build = subprocess.run(
        [
            "docker",
            "build",
            "-t",
            template,
            template_path
        ],
        capture_output=True,
        text=True
    )

    if build.returncode != 0:
        return jsonify({
            "status": "failed",
            "output": build.stderr
        }), 500

    return jsonify({
        "status": "installed",
        "template": template
    })

@app.route("/api/start/<template>", methods=["POST"])
def start_template(template):

    if template not in VALID_CONTAINERS:
        return jsonify({"error": "invalid template"}), 400

    result = subprocess.run(
        ["docker", "ps", "-a", "--format", "{{.Names}}"],
        capture_output=True,
        text=True
    )

    containers = result.stdout.splitlines()

    if template in containers:

        result = subprocess.run(
            ["docker", "start", template],
            capture_output=True,
            text=True
        )

        return jsonify({
            "status": "started",
            "template": template
        })

    if template == "zomboid":

        result = subprocess.run(
            [
                "docker",
                "run",
                "-d",
                "--name",
                "zomboid",
                "-e", "SERVER_NAME=ShazCloud",
                "-e", "ADMIN_PASSWORD=changeme",
                "-p", "16261:16261/udp",
                "-p", "16262:16262/udp",
                "-p", "8766:8766/udp",
                "-p", "8767:8767/udp",
                "zomboid"
            ],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            return jsonify({
                "status": "failed",
                "output": result.stderr
            }), 500

        return jsonify({
            "status": "deployed",
            "template": template
        })


## End of Docker templates APIs
##API docker containers

@app.route("/api/containerstats")
def container_stats():

    result = subprocess.run(
        [
            "docker",
            "stats",
            "--no-stream",
            "--format",
            "{{.Name}}|{{.CPUPerc}}|{{.MemUsage}}"
        ],
        capture_output=True,
        text=True
    )

    stats = {}

    for line in result.stdout.splitlines():

        name, cpu, mem = line.split("|")

        stats[name] = {
            "cpu": cpu,
            "memory": mem
        }

    return jsonify(stats)

@app.route('/api/docker/version')
def docker_version():

    result = subprocess.run(
        ["docker", "--version"],
        capture_output=True,
        text=True
    )

    return {
        "version": result.stdout.strip()
    }

@app.route('/api/docker/info')
def docker_info():

    result = subprocess.run(
        ["docker", "info", "--format", "{{json .}}"],
        capture_output=True,
        text=True
    )

    return result.stdout

@app.route('/api/docker/logs/<name>')
def container_logs(name):

    if name not in VALID_CONTAINERS:
        return jsonify({"error": "invalid container"}), 400

    result = subprocess.run(
        ["docker", "logs", "--tail", "25", name],
        capture_output=True,
        text=True
    )

    return {
        "container": name,
        "logs": result.stdout
    }


@app.route('/api/containers')
def get_containers():
    
    result = subprocess.run(
        ["docker", "ps", "--format", "{{.Names}}"],
        capture_output=True,
        text=True
    )

    running = result.stdout.splitlines()


    status = {}
    for name in VALID_CONTAINERS:
        status[name] = "running" if name in running else "stopped"

    return status

###DOCKER API CONTAINER SECTION###


@app.route('/api/docker/start/<name>', methods=['POST'])
def start_container(name):

    result = subprocess.run(
        ["docker", "start", name],
        capture_output=True,
        text=True
    )
    
    return jsonify({"status": "started", "container": name})


@app.route('/api/docker/stop/<name>', methods=['POST'])
def stop_container(name):
   
    result = subprocess.run(
        ["docker", "stop", name],
        capture_output=True,
        text=True
    )
      
    return jsonify({"status": "stopped", "container": name})


@app.route('/api/docker/restart/<name>', methods=['POST'])
def restart_container(name):
   
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