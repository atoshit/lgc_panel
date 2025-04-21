# Logic Panel for FiveM 

Logic Panel is an in-game server management panel for FiveM. It allows admins to create and manage gangs, jobs, zones, and other server elements directly from the game.

## 📋 Installation Guide

### Prerequisites
- FiveM Server
- [Node.js](https://nodejs.org/) (v16 or higher)
- [oxmysql](https://github.com/overextended/oxmysql)

### Steps

1. Download the resource and place it in your resources folder
2. Navigate to the web folder and install dependencies:
```bash
cd lgc_panel/web
npm install
```
3. Build the web interface:
```bash
npm run build
```
4. Add the resource to your server.cfg:
```bash
ensure oxmysql
ensure lgc_panel
```
5. Start your server and use F11 or /panel to open the admin panel

### Default Controls
- F11 or /panel to open
- ESC to close