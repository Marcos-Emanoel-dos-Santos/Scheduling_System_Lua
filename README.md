# Scheduling_System_Lua

A simple CLI-based appointment scheduling system written in Lua.  
Users can create, list, edit, and delete appointments, which are always shown in chronological order — from the nearest to the farthest date.

## Features

- Create new appointments with title, description, and date.
- View all scheduled appointments, ordered by date.
- Edit or cancel existing appointments.
- Data is saved automatically to a JSON file (`db.json`).
- Lightweight and dependency-free (uses only Lua standard libraries).

## Requirements

- Lua 5.1 or later

## How to Run

```bash
lua main.lua
