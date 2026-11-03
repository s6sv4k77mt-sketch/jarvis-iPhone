<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>J.A.R.V.I.S. Mark VII - Stark OS</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome per Icone Futuristiche -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts: Orbitron & Rajdhani -->
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;600;800;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            /* Colori dinamici gestiti da JS in base alla batteria */
            --hud-primary: #00f3ff;
            --hud-secondary: #0066ff;
            --hud-bg-panel: rgba(2, 16, 36, 0.7);
            --hud-border: rgba(0, 243, 255, 0.35);
            --hud-glow: rgba(0, 243, 255, 0.2);
            --dark-bg: #030a16;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--hud-primary);
            font-family: 'Rajdhani', sans-serif;
            overflow: hidden;
            touch-action: manipulation;
            user-select: none;
            -webkit-user-select: none;
            transition: color 0.5s ease;
        }

        .font-orbitron {
            font-family: 'Orbitron', sans-serif;
        }

        /* Ambient Scanlines */
        .scanline {
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.3) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.02), rgba(0, 255, 0, 0.01), rgba(0, 0, 255, 0.02));
            background-size: 100% 4px, 6px 100%;
            pointer-events: none;
            z-index: 50;
            opacity: 0.6;
        }

        /* Glassmorphism Dynamic HUD Panel */
        .hud-panel {
            background: var(--hud-bg-panel);
            border: 1px solid var(--hud-border);
            box-shadow: 0 0 15px var(--hud-glow), inset 0 0 15px var(--hud-glow);
            backdrop-filter: blur(8px);
            border-radius: 12px;
            position: relative;
            transition: all 0.5s ease;
        }

        .hud-panel::before {
            content: '';
            position: absolute;
            top: -2px; left: -2px; width: 10px; height: 10px;
            border-top: 2px solid var(--hud-primary);
            border-left: 2px solid var(--hud-primary);
            transition: border-color 0.5s ease;
        }

        .hud-panel::after {
            content: '';
            position: absolute;
            bottom: -2px; right: -2px; width: 10px; height: 10px;
            border-bottom: 2px solid var(--hud-primary);
            border-right: 2px solid var(--hud-primary);
            transition: border-color 0.5s ease;
        }

        /* Reattore Arc Animato */
        .arc-container {
            position: relative;
            width: 200px;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @media (min-width: 768px) {
            .arc-container {
                width: 280px;
                height: 280px;
            }
        }

        .arc-ring {
            position: absolute;
            border-radius: 50%;
            border: 2px solid transparent;
            box-sizing: border-box;
        }

        .ring-1 {
            width: 100%; height: 100%;
            border-top-color: var(--hud-primary);
            border-bottom-color: var(--hud-primary);
            animation: rotateClockwise 8s linear infinite;
            filter: drop-shadow(0 0 8px var(--hud-primary));
            transition: border-color 0.5s ease;
        }

        .ring-2 {
            width: 82%; height: 82%;
            border-left-color: var(--hud-secondary);
            border-right-color: var(--hud-secondary);
            animation: rotateCounterClockwise 6s linear infinite;
            transition: border-color 0.5s ease;
        }

        .ring-3 {
            width: 65%; height: 65%;
            border: 2px dashed var(--hud-primary);
            animation: rotateClockwise 12s linear infinite;
            opacity: 0.7;
            transition: border-color 0.5s ease;
        }

        .arc-core {
            width: 45%; height: 45%;
            background: radial-gradient(circle, #ffffff 0%, var(--hud-primary) 50%, var(--hud-secondary) 90%);
            border-radius: 50%;
            box-shadow: 0 0 30px var(--hud-primary), 0 0 60px var(--hud-secondary);
            transition: all 0.5s ease;
        }

        .arc-core.active {
            animation: pulseGlow 1.2s infinite alternate;
        }

        .arc-core.speaking {
            animation: speakPulse 0.4s infinite alternate;
        }

        @keyframes rotateClockwise {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @keyframes rotateCounterClockwise {
            from { transform: rotate(0deg); }
            to { transform: rotate(-360deg); }
        }

        @keyframes pulseGlow {
            0% { transform: scale(0.95); box-shadow: 0 0 20px var(--hud-primary); }
            100% { transform: scale(1.1); box-shadow: 0 0 50px var(--hud-primary), 0 0 80px #ffffff; }
        }

        @keyframes speakPulse {
            0% { transform: scale(1); filter: brightness(1); }
            100% { transform: scale(1.15); filter: brightness(1.6); }
        }

        /* Dynamic HUD Buttons */
        .hud-btn {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--hud-primary);
            color: var(--hud-primary);
            text-shadow: 0 0 5px var(--hud-primary);
            transition: all 0.3s ease;
        }
        .hud-btn:active, .hud-btn:hover {
            background: var(--hud-glow);
            box-shadow: 0 0 15px var(--hud-primary);
            transform: translateY(-1px);
        }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: rgba(0, 0, 0, 0.2); }
        ::-webkit-scrollbar-thumb { background: var(--hud-primary); border-radius: 2px; }

        .tab-active {
            background: var(--hud-primary) !important;
            color: #000 !important;
            font-weight: bold;
        }
    </style>
</head>
<body class="h-screen w-screen p-3 flex flex-col justify-between relative select-none">
    <div class="scanline"></div>

    <!-- HEADER TOP BAR -->
    <header class="w-full flex justify-between items-center z-10 hud-panel p-3 px-5 mb-2">
        <div class="flex items-center space-x-3">
            <i class="fa-solid fa-atom text-2xl animate-spin" style="animation-duration: 10s;"></i>
            <div>
                <h1 class="font-orbitron text-lg md:text-2xl font-black tracking-widest">J.A.R.V.I.S.</h1>
                <p class="text-[10px] md:text-xs opacity-80 tracking-wider font-semibold">MARK VII // STARK OS IPAD EDITION</p>
            </div>
        </div>

        <!-- Clock & Power Alert -->
        <div class="flex items-center space-x-4">
            <div id="powerAlert" class="hidden md:flex items-center space-x-2 text-xs font-bold px-3 py-1 rounded bg-red-950 border border-red-500 text-red-400 animate-pulse">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span id="powerAlertText">ENERGIA CRITICA</span>
            </div>
            <div class="text-right">
                <div id="timeDisplay" class="font-orbitron text-lg md:text-2xl font-bold tracking-wider">00:00:00</div>
                <div id="dateDisplay" class="text-[10px] md:text-xs tracking-widest uppercase opacity-80">---, -- ----</div>
            </div>
        </div>
    </header>

    <!-- MAIN GRID -->
    <main class="flex-1 grid grid-cols-1 md:grid-cols-12 gap-3 my-1 z-10 overflow-hidden">
        
        <!-- LEFT PANEL: BATTERIA & METEO -->
        <section class="md:col-span-3 hud-panel p-3 flex flex-col justify-between space-y-3 overflow-y-auto">
            
            <!-- BATTERY WIDGET -->
            <div>
                <h2 class="font-orbitron text-xs md:text-sm font-bold border-b border-cyan-800/50 pb-1 mb-2 flex items-center justify-between">
                    <span><i class="fa-solid fa-bolt mr-2"></i>RESERVE D'ENERGIA</span>
                    <span id="batteryPercentText" class="text-xs font-bold">100%</span>
                </h2>
                
                <div class="space-y-2 text-xs">
                    <div class="flex justify-between items-center">
                        <span id="batteryStatusLabel">Stato Carica</span>
                        <span id="chargingState" class="font-semibold">In Scarica</span>
                    </div>
                    <div class="w-full bg-black/50 h-3 rounded-full overflow-hidden border border-cyan-900/50 p-0.5">
                        <div id="batteryBar" class="h-full rounded-full transition-all duration-700" style="width: 100%; background-color: var(--hud-primary);"></div>
                    </div>
                    <div id="batteryRangeHint" class="text-[10px] opacity-70 italic text-right">Sistema in sicurezza (>40%)</div>
                </div>
            </div>

            <!-- METEO WIDGET -->
            <div class="border-t border-cyan-800/40 pt-2">
                <h2 class="font-orbitron text-xs md:text-sm font-bold border-b border-cyan-800/50 pb-1 mb-2 flex items-center justify-between">
                    <span><i class="fa-solid fa-cloud-sun mr-2"></i>METEO LUSSO</span>
                    <button onclick="fetchWeather()" class="text-[10px] underline hover:opacity-80">Aggiorna</button>
                </h2>

                <div class="flex items-center justify-between bg-black/20 p-2 rounded">
                    <div>
                        <div id="weatherTemp" class="font-orbitron text-xl md:text-2xl font-bold">--°C</div>
                        <div id="weatherDesc" class="text-xs capitalize">Caricamento...</div>
                        <div id="weatherCity" class="text-[10px] opacity-70">Bologna, IT</div>
                    </div>
                    <div id="weatherIcon" class="text-3xl pr-2">
                        <i class="fa-solid fa-spinner animate-spin"></i>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-1 text-[10px] mt-2 opacity-80">
                    <div>Umidità: <span id="weatherHumidity">--%</span></div>
                    <div>Vento: <span id="weatherWind">-- km/h</span></div>
                </div>
            </div>

            <!-- SYSTEM DIAGNOSTICS -->
            <div class="border-t border-cyan-800/40 pt-2 text-xs space-y-1">
                <div class="flex justify-between">
                    <span>RETE NEURALE</span>
                    <span id="cpuVal">94%</span>
                </div>
                <div class="w-full bg-black/40 h-1 rounded overflow-hidden">
                    <div id="cpuBar" class="bg-current h-full w-[94%] transition-all duration-500"></div>
                </div>
            </div>
        </section>

        <!-- CENTER PANEL: ARC REACTOR & QUICK VOICE CONTROLS -->
        <section class="md:col-span-5 hud-panel p-3 flex flex-col items-center justify-between relative">
            <div class="w-full flex justify-between items-center text-[10px] md:text-xs opacity-70">
                <span>[ PROTOCOLLO STARK ]</span>
                <span id="jarvisStatus" class="font-orbitron font-bold">SYSTEM READY</span>
                <span>[ IPAD A16 ]</span>
            </div>

            <!-- ANIMATED ARC REACTOR CORE -->
            <div class="my-auto py-2 flex flex-col items-center cursor-pointer" onclick="activateSpeech()">
                <div class="arc-container">
                    <div class="arc-ring ring-1"></div>
                    <div class="arc-ring ring-2"></div>
                    <div class="arc-ring ring-3"></div>
                    <div id="arcCore" class="arc-core"></div>
                </div>
                <p id="micHint" class="mt-3 font-orbitron text-xs tracking-widest opacity-80 uppercase animate-pulse">
                    Tocca il Reattore per parlare
                </p>
            </div>

            <!-- QUICK COMMAND BUTTONS -->
            <div class="w-full grid grid-cols-2 sm:grid-cols-4 gap-1.5 mb-1">
                <button onclick="runCommand('chi sei')" class="hud-btn p-1.5 rounded text-xs font-semibold">
                    <i class="fa-solid fa-user-shield block text-xs mb-0.5"></i>Chi Sei
                </button>
                <button onclick="runCommand('meteo')" class="hud-btn p-1.5 rounded text-xs font-semibold">
                    <i class="fa-solid fa-temperature-three-quarters block text-xs mb-0.5"></i>Meteo
                </button>
                <button onclick="runCommand('batteria')" class="hud-btn p-1.5 rounded text-xs font-semibold">
                    <i class="fa-solid fa-battery-half block text-xs mb-0.5"></i>Batteria
                </button>
                <button onclick="runCommand('programma di oggi')" class="hud-btn p-1.5 rounded text-xs font-semibold">
                    <i class="fa-solid fa-calendar-day block text-xs mb-0.5"></i>Agenda
                </button>
            </div>
        </section>

        <!-- RIGHT PANEL: WEEKLY SCHEDULE & INTERACTIVE LOG -->
        <section class="md:col-span-4 hud-panel p-3 flex flex-col justify-between overflow-hidden">
            
            <!-- PROGRAMMA SETTIMANALE -->
            <div class="flex-1 flex flex-col overflow-hidden mb-2">
                <h2 class="font-orbitron text-xs md:text-sm font-bold border-b border-cyan-800/50 pb-1 mb-2 flex justify-between items-center">
                    <span><i class="fa-solid fa-calendar-week mr-2"></i>PROGRAMMA SETTIMANA</span>
                </h2>

                <!-- Day Selector Tabs -->
                <div id="dayTabs" class="flex gap-1 overflow-x-auto pb-1 mb-2 text-[10px]">
                    <button onclick="selectDay('LUN')" class="hud-btn px-2 py-0.5 rounded" id="tab-LUN">LUN</button>
                    <button onclick="selectDay('MAR')" class="hud-btn px-2 py-0.5 rounded" id="tab-MAR">MAR</button>
                    <button onclick="selectDay('MER')" class="hud-btn px-2 py-0.5 rounded" id="tab-MER">MER</button>
                    <button onclick="selectDay('GIO')" class="hud-btn px-2 py-0.5 rounded" id="tab-GIO">GIO</button>
                    <button onclick="selectDay('VEN')" class="hud-btn px-2 py-0.5 rounded" id="tab-VEN">VEN</button>
                    <button onclick="selectDay('SAB')" class="hud-btn px-2 py-0.5 rounded" id="tab-SAB">SAB</button>
                    <button onclick="selectDay('DOM')" class="hud-btn px-2 py-0.5 rounded" id="tab-DOM">DOM</button>
                </div>

                <!-- Schedule List -->
                <div class="flex-1 overflow-y-auto pr-1">
                    <ul id="scheduleList" class="space-y-1.5 text-xs">
                        <li class="text-gray-500 italic text-center py-2">Seleziona un giorno per vedere gli impegni.</li>
                    </ul>
                </div>

                <!-- Add Item Form -->
                <form onsubmit="addScheduleItem(event)" class="mt-2 flex gap-1">
                    <input type="text" id="scheduleInput" placeholder="Aggiungi impegno per oggi..." 
                           class="w-full bg-black/40 border border-cyan-800/60 rounded px-2 py-1 text-xs text-white focus:outline-none focus:border-cyan-400">
                    <button type="submit" class="hud-btn px-2 py-1 rounded text-xs">+</button>
                </form>
            </div>

            <!-- CHAT LOG -->
            <div class="border-t border-cyan-800/40 pt-2 flex flex-col h-40">
                <h2 class="font-orbitron text-xs font-bold mb-1">
                    <i class="fa-solid fa-terminal mr-1"></i>REGISTRO
                </h2>
                <div id="chatLog" class="flex-1 overflow-y-auto space-y-1.5 text-[11px] pr-1 my-1">
                    <div class="p-1.5 rounded bg-black/30 border-l-2 border-current">
                        <span class="font-bold">J.A.R.V.I.S.:</span> In attesa dei suoi ordini, Signore.
                    </div>
                </div>

                <!-- Manual Input -->
                <form onsubmit="handleManualInput(event)" class="flex gap-1 mt-1">
                    <input type="text" id="manualInput" placeholder="Scrivi a J.A.R.V.I.S..." 
                           class="w-full bg-black/40 border border-cyan-800/60 rounded px-2 py-1 text-xs text-white focus:outline-none focus:border-cyan-400">
                    <button type="submit" class="hud-btn px-2 py-1 rounded text-xs">
                        <i class="fa-solid fa-paper-plane"></i>
                    </button>
                </form>
            </div>
        </section>
    </main>

    <!-- FOOTER -->
    <footer class="w-full hud-panel p-2 px-4 z-10 flex justify-between items-center text-[10px] md:text-xs">
        <div class="flex items-center space-x-2">
            <span class="inline-block w-2 h-2 rounded-full bg-green-400 animate-ping"></span>
            <span>SISTEMA REGOLARE</span>
        </div>
        <div>
            <span>SINTESI VOCALE: <strong class="text-white">ITALIANO</strong></span>
        </div>
    </footer>

    <!-- JAVASCRIPT SYSTEM ENGINE -->
    <script>
        // Data States
        let currentDay = 'LUN';
        let scheduleData = JSON.parse(localStorage.getItem('jarvis_schedule')) || {
            LUN: ["Studio Matematica", "Allenamento"],
            MAR: ["Verifica di Fisica", "Progetto Jarvis"],
            MER: ["Studio Inglese"],
            GIO: ["Allenamento", "Ripasso"],
            VEN: ["Uscita con amici"],
            SAB: ["Gaming Session", "Relax"],
            DOM: ["Pianificazione Settimana"]
        };

        let currentBatteryLevel = 100;
        let isCharging = false;

        // Speech Recognition & Speech Synthesis Initialization
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        const synth = window.speechSynthesis;
        let recognition = null;

        if (SpeechRecognition) {
            recognition = new SpeechRecognition();
            recognition.continuous = false;
            recognition.lang = 'it-IT';
            recognition.interimResults = false;

            recognition.onstart = () => {
                updateStatus("IN ASCOLTO...", "active");
                document.getElementById('micHint').innerText = "Ascolto in corso...";
            };

            recognition.onresult = (event) => {
                const command = event.results[0][0].transcript;
                addLog("Signore", command);
                processCommand(command);
            };

            recognition.onerror = () => {
                updateStatus("SYSTEM READY", "idle");
                document.getElementById('micHint').innerText = "Tocca il Reattore per parlare";
            };

            recognition.onend = () => {
                updateStatus("SYSTEM READY", "idle");
                document.getElementById('micHint').innerText = "Tocca il Reattore per parlare";
            };
        }

        // Voice Activation
        function activateSpeech() {
            if (!recognition) {
                speak("Signore, il browser non supporta l'input vocale. Usi la tastiera.");
                return;
            }
            if (synth.speaking) synth.cancel();
            try { recognition.start(); } catch (e) { recognition.stop(); }
        }

        // Text To Speech Synthesis
        function speak(text) {
            if (!synth) return;
            synth.cancel();

            const utterance = new SpeechSynthesisUtterance(text);
            utterance.lang = 'it-IT';
            utterance.rate = 1.05;
            utterance.pitch = 0.95;

            const voices = synth.getVoices();
            const itVoice = voices.find(v => v.lang.includes('it') || v.lang.includes('ITA'));
            if (itVoice) utterance.voice = itVoice;

            utterance.onstart = () => updateStatus("PARLANDO...", "speaking");
            utterance.onend = () => updateStatus("SYSTEM READY", "idle");

            addLog("J.A.R.V.I.S.", text);
            synth.speak(utterance);
        }

        // Dynamic Theme Switcher based on Battery Percentage
        function updateThemeColors(level) {
            const root = document.documentElement;
            const alertBox = document.getElementById('powerAlert');
            const alertText = document.getElementById('powerAlertText');
            const rangeHint = document.getElementById('batteryRangeHint');

            if (level > 40) {
                // NORMAL MODE: CYAN / BLUE
                root.style.setProperty('--hud-primary', '#00f3ff');
                root.style.setProperty('--hud-secondary', '#0066ff');
                root.style.setProperty('--hud-bg-panel', 'rgba(2, 16, 36, 0.7)');
                root.style.setProperty('--hud-border', 'rgba(0, 243, 255, 0.35)');
                root.style.setProperty('--hud-glow', 'rgba(0, 243, 255, 0.2)');
                alertBox.classList.add('hidden');
                rangeHint.innerText = "Sistema in sicurezza (>40%)";
            } 
            else if (level <= 40 && level > 20) {
                // WARNING MODE: ORANGE
                root.style.setProperty('--hud-primary', '#ff9900');
                root.style.setProperty('--hud-secondary', '#ff5500');
                root.style.setProperty('--hud-bg-panel', 'rgba(36, 18, 2, 0.7)');
                root.style.setProperty('--hud-border', 'rgba(255, 153, 0, 0.4)');
                root.style.setProperty('--hud-glow', 'rgba(255, 153, 0, 0.25)');
                alertBox.classList.remove('hidden');
                alertText.innerText = "RISERVA ENERGIA (<40%)";
                rangeHint.innerText = "Attenzione: Riserva sotto il 40%";
            } 
            else {
                // CRITICAL MODE: RED
                root.style.setProperty('--hud-primary', '#ff0033');
                root.style.setProperty('--hud-secondary', '#990011');
                root.style.setProperty('--hud-bg-panel', 'rgba(36, 2, 8, 0.8)');
                root.style.setProperty('--hud-border', 'rgba(255, 0, 51, 0.6)');
                root.style.setProperty('--hud-glow', 'rgba(255, 0, 51, 0.4)');
                alertBox.classList.remove('hidden');
                alertText.innerText = "ALLARME ENERGIA CRITICA (<20%)";
                rangeHint.innerText = "PERICOLO: Batteria quasi esaurita!";
            }
        }

        // Battery Monitor API Implementation
        function initBatteryMonitor() {
            if ('getBattery' in navigator) {
                navigator.getBattery().then(battery => {
                    function updateAllBatteryInfo() {
                        currentBatteryLevel = Math.round(battery.level * 100);
                        isCharging = battery.charging;

                        document.getElementById('batteryPercentText').innerText = currentBatteryLevel + "%";
                        document.getElementById('batteryBar').style.width = currentBatteryLevel + "%";
                        document.getElementById('chargingState').innerText = isCharging ? "In Carica ⚡" : "In Scarica";

                        updateThemeColors(currentBatteryLevel);
                    }

                    updateAllBatteryInfo();
                    battery.addEventListener('levelchange', updateAllBatteryInfo);
                    battery.addEventListener('chargingchange', updateAllBatteryInfo);
                });
            } else {
                // Fallback simulation if API not exposed
                updateThemeColors(currentBatteryLevel);
            }
        }

        // Live Weather Fetcher (Open-Meteo API for Bologna)
        async function fetchWeather() {
            try {
                const response = await fetch('https://api.open-meteo.com/v1/forecast?latitude=44.4938&longitude=11.3426&current_weather=true&hourly=relativehumidity_2m');
                const data = await response.json();
                
                const temp = Math.round(data.current_weather.temperature);
                const wind = Math.round(data.current_weather.windspeed);
                const weatherCode = data.current_weather.weathercode;

                document.getElementById('weatherTemp').innerText = `${temp}°C`;
                document.getElementById('weatherWind').innerText = `${wind} km/h`;
                document.getElementById('weatherHumidity').innerText = `65%`;

                // Weather Code Mapping
                let desc = "Sereno";
                let iconClass = "fa-sun text-yellow-400";

                if (weatherCode >= 1 && weatherCode <= 3) {
                    desc = "Parzialmente Nuvoloso";
                    iconClass = "fa-cloud-sun text-cyan-300";
                } else if (weatherCode >= 45 && weatherCode <= 48) {
                    desc = "Nebbia";
                    iconClass = "fa-smog text-gray-400";
                } else if (weatherCode >= 51 && weatherCode <= 67) {
                    desc = "Pioggia";
                    iconClass = "fa-cloud-rain text-blue-400";
                } else if (weatherCode >= 80) {
                    desc = "Temporale";
                    iconClass = "fa-bolt text-yellow-300";
                }

                document.getElementById('weatherDesc').innerText = desc;
                document.getElementById('weatherIcon').innerHTML = `<i class="fa-solid ${iconClass}"></i>`;

            } catch (err) {
                document.getElementById('weatherDesc').innerText = "Non disponibile";
                document.getElementById('weatherIcon').innerHTML = `<i class="fa-solid fa-cloud"></i>`;
            }
        }

        // Command Processing Logic
        function processCommand(cmd) {
            const input = cmd.toLowerCase().trim();

            if (input.includes("chi sei") || input.includes("presentati")) {
                speak("Sono J.A.R.V.I.S., il suo assistente virtuale, Signore. Controllo l'energia dell'iPad e le evito figuracce con gli impegni.");
            }
            else if (input.includes("ciao") || input.includes("buongiorno") || input.includes("buonasera")) {
                speak("Buonasera Signore. I sistemi sono operativi e pronti ai suoi ordini.");
            }
            else if (input.includes("batteria") || input.includes("energia") || input.includes("carica")) {
                let statusCharge = isCharging ? "in carica" : "in scarica";
                speak(`Signore, la carica attuale della batteria è al ${currentBatteryLevel} percento ed è ${statusCharge}.`);
            }
            else if (input.includes("meteo") || input.includes("tempo") || input.includes("temperatura")) {
                const tempStr = document.getElementById('weatherTemp').innerText;
                const descStr = document.getElementById('weatherDesc').innerText;
                speak(`A Bologna ci sono attualmente ${tempStr} con condizioni di ${descStr}, Signore.`);
            }
            else if (input.includes("programma") || input.includes("agenda") || input.includes("impegni")) {
                const dayTasks = scheduleData[currentDay];
                if (!dayTasks || dayTasks.length === 0) {
                    speak(`Per la giornata di ${currentDay} non ha alcun impegno in programma, Signore.`);
                } else {
                    speak(`Per la giornata di ${currentDay} ha in programma: ${dayTasks.join(", ")}, Signore.`);
                }
            }
            else if (input.includes("ora") || input.includes("ore")) {
                const now = new Date();
                speak(`Sono le ore ${now.toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' })}, Signore.`);
            }
            else {
                speak(`Comando "${cmd}" ricevuto, Signore. Ma non è ancora presente nei miei protocolli.`);
            }
        }

        // Schedule / Weekly Agenda Management
        function selectDay(day) {
            currentDay = day;
            document.querySelectorAll('#dayTabs button').forEach(b => b.classList.remove('tab-active'));
            const activeTab = document.getElementById(`tab-${day}`);
            if (activeTab) activeTab.classList.add('tab-active');
            renderSchedule();
        }

        function renderSchedule() {
            const listEl = document.getElementById('scheduleList');
            const items = scheduleData[currentDay] || [];

            if (items.length === 0) {
                listEl.innerHTML = `<li class="text-gray-500 italic text-center py-2">Nessun impegno per ${currentDay}.</li>`;
                return;
            }

            listEl.innerHTML = items.map((item, idx) => `
                <li class="p-1.5 bg-black/40 rounded border border-cyan-800/40 flex justify-between items-center">
                    <span>${item}</span>
                    <button onclick="deleteScheduleItem(${idx})" class="text-red-400 hover:text-red-200 px-1">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </li>
            `).join('');
        }

        function addScheduleItem(e) {
            e.preventDefault();
            const input = document.getElementById('scheduleInput');
            if (input.value.trim() !== '') {
                if (!scheduleData[currentDay]) scheduleData[currentDay] = [];
                scheduleData[currentDay].push(input.value.trim());
                localStorage.setItem('jarvis_schedule', JSON.stringify(scheduleData));
                input.value = '';
                renderSchedule();
            }
        }

        function deleteScheduleItem(index) {
            scheduleData[currentDay].splice(index, 1);
            localStorage.setItem('jarvis_schedule', JSON.stringify(scheduleData));
            renderSchedule();
        }

        // UI Helpers
        function runCommand(cmdText) {
            addLog("Signore", cmdText);
            processCommand(cmdText);
        }

        function handleManualInput(e) {
            e.preventDefault();
            const inputEl = document.getElementById('manualInput');
            if (inputEl.value.trim() !== '') {
                runCommand(inputEl.value);
                inputEl.value = '';
            }
        }

        function updateStatus(text, state) {
            document.getElementById('jarvisStatus').innerText = text;
            const core = document.getElementById('arcCore');
            core.classList.remove('active', 'speaking');
            if (state === 'active') core.classList.add('active');
            if (state === 'speaking') core.classList.add('speaking');
        }

        function addLog(sender, text) {
            const chatLog = document.getElementById('chatLog');
            const entry = document.createElement('div');
            entry.className = sender === "J.A.R.V.I.S." 
                ? "p-1.5 rounded bg-black/30 border-l-2 border-current" 
                : "p-1.5 rounded bg-black/20 border-r-2 border-current text-right";
            
            entry.innerHTML = `<span class="font-bold">${sender}:</span> ${text}`;
            chatLog.appendChild(entry);
            chatLog.scrollTop = chatLog.scrollHeight;
        }

        function updateClock() {
            const now = new Date();
            document.getElementById('timeDisplay').innerText = now.toLocaleTimeString('it-IT');
            const options = { weekday: 'short', day: '2-digit', month: 'short', year: 'numeric' };
            document.getElementById('dateDisplay').innerText = now.toLocaleDateString('it-IT', options).toUpperCase();
        }

        // Initialization
        window.onload = () => {
            setInterval(updateClock, 1000);
            updateClock();
            initBatteryMonitor();
            fetchWeather();
            
            // Set initial day tab to today
            const days = ['DOM', 'LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB'];
            const todayIndex = new Date().getDay();
            selectDay(days[todayIndex]);

            // Welcome Voice
            setTimeout(() => {
                speak("Sistemi aggiornati, Signore. Interfaccia, meteo, batteria e agenda della settimana sono pronti.");
            }, 800);
        };
    </script>
</body>
</html>
