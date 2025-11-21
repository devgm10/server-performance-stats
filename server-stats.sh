#!/bin/bash

# ANSI Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"

# Draw progress bar ███░░░
draw_bar() {
    local percent=$1
    local size=30
    local filled=$((percent * size / 100))
    local empty=$((size - filled))

    printf "%s" "$(printf '█%.0s' $(seq 1 $filled))"
    printf "%s" "$(printf '░%.0s' $(seq 1 $empty))"
}

while true; do
    clear
    echo -e "${CYAN}========== Zenya Server Dashboard ==========${RESET}"
    echo "Host: $(hostname) | Date: $(date)"

    #############################################
    # CPU USAGE
    #############################################
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    printf "\n${GREEN}CPU Usage:${RESET} %.2f%%  " "$cpu_usage"
    draw_bar ${cpu_usage%.*}
    echo ""

    #############################################
    # MEMORY USAGE
    #############################################
    read total used free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
    mem_percent=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")

    echo -e "\n${YELLOW}Memory Usage:${RESET} $mem_percent%  ($used MB / $total MB)"
    draw_bar $mem_percent
    echo ""

    #############################################
    # DISK USAGE
    #############################################
    disk_percent=$(df -h / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
    disk_total=$(df -h / | awk 'NR==2 {print $2}')
    disk_used=$(df -h / | awk 'NR==2 {print $3}')

    echo -e "\n${MAGENTA}Disk Usage:${RESET} $disk_percent%  ($disk_used / $disk_total)"
    draw_bar $disk_percent
    echo ""

    #############################################
    # TOP 5 PROCESSES BY CPU
    #############################################
    echo -e "\n${BLUE}🧠 Top 5 Processes by CPU:${RESET}"
    ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

    #############################################
    # TOP 5 PROCESSES BY MEMORY
    #############################################
    echo -e "\n${BLUE}💽 Top 5 Processes by Memory:${RESET}"
    ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6

    echo -e "\n${CYAN}============================================${RESET}"

    sleep 1
done