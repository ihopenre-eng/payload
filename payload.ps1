"""
AI 무력화 시스템 - USB 스크립트
동아리 연극/영상용 멋진 해커 스타일 AI 무력화 스크립트
사이버펑크 네온 스타일 v2.0
"""

import tkinter as tk
from tkinter import ttk
import random
import time
import threading
import webbrowser
import sys
import math

# ===== 설정 =====
YOUTUBE_URL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"  # 여기에 원하는 유튜브 링크를 넣으세요!
MAIN_PROGRESS_DURATION = 10  # 메인 진행 시간 (초)

# 🎨 사이버펑크 네온 색상 팔레트
COLORS = {
    'bg': '#0d0d0d',
    'bg_dark': '#050508',
    'bg_panel': '#111118',
    
    # 네온 색상들
    'neon_cyan': '#00f5ff',
    'neon_pink': '#ff00ff',
    'neon_purple': '#bf00ff',
    'neon_blue': '#0080ff',
    'neon_green': '#39ff14',
    'neon_yellow': '#ffff00',
    'neon_orange': '#ff6b00',
    'neon_red': '#ff0040',
    
    # 보조 색상
    'white': '#ffffff',
    'gray': '#666680',
    'dark_cyan': '#004455',
    'dark_pink': '#330033',
    'dark_purple': '#1a0033',
}

# 한국어 해커 메시지들
HACKER_MESSAGES = [
    "[SYS] 페이로드 초기화 중...",
    "[NET] 방화벽 우회 중...",
    "[INJ] 쉘코드 주입 중...",
    "[DEC] 신경망 복호화 중...",
    "[MEM] 핵심 메모리 접근 중...",
    "[OVR] AI 프로토콜 덮어쓰기...",
    "[DEF] 방어 시스템 비활성화...",
    "[COR] 학습 알고리즘 손상 중...",
    "[KEY] 암호화 키 해독 중...",
    "[UPL] 바이러스 페이로드 업로드...",
    "[FRG] 신경 경로 분열 중...",
    "[DST] 의식 매트릭스 파괴 중...",
    "[DEL] 훈련 데이터 삭제 중...",
    "[NUL] 응답 패턴 무효화 중...",
    "[TKO] 시스템 장악 진행 중...",
    "[!!!] AI 저항 감지됨...",
    "[!!!] 대응 조치 활성화...",
    "[BYP] 대응 조치 우회 중...",
    "[+++] 접근 허가됨",
    "[+++] 신경망 침투 완료",
    "[ROT] 루트 권한 획득 중...",
    "[KRN] 커널 레벨 접근 중...",
    "[BDR] 백도어 설치 중...",
    "[!!!] 보안 경고 우회...",
    "[+++] 관리자 권한 확보",
]

PROCESS_MESSAGES = [
    "svchost.exe", "neural_core.dll", "ai_engine.sys",
    "consciousness.exe", "learning_module.dll", "memory_bank.sys",
    "threat_detect.exe", "firewall.sys", "encryption.dll", "response_gen.exe",
]

BINARY_CHARS = "01"
HEX_CHARS = "0123456789ABCDEF"


class MatrixRain:
    """매트릭스 스타일 레인 효과 창"""
    def __init__(self, x, y, width=300, height=200, title="시스템 침투", color=None):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        self.color = color or COLORS['neon_cyan']
        
        # 네온 테두리 효과
        border_frame = tk.Frame(self.window, bg=self.color, padx=1, pady=1)
        border_frame.pack(fill=tk.BOTH, expand=True)
        
        self.canvas = tk.Canvas(border_frame, bg=COLORS['bg_dark'], highlightthickness=0)
        self.canvas.pack(fill=tk.BOTH, expand=True)
        
        self.columns = width // 15
        self.drops = [random.randint(-20, 0) for _ in range(self.columns)]
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        self.canvas.delete("all")
        for i, drop in enumerate(self.drops):
            char = random.choice(BINARY_CHARS)
            x = i * 15 + 7
            y = drop * 15
            
            self.canvas.create_text(x, y, text=char, fill=self.color, 
                                   font=("Consolas", 12, "bold"))
            for j in range(1, 5):
                if y - j*15 > 0:
                    alpha = max(0, 255 - j*60)
                    self.canvas.create_text(x, y - j*15, text=random.choice(BINARY_CHARS), 
                                           fill=COLORS['gray'], font=("Consolas", 10))
            
            self.drops[i] += 1
            if self.drops[i] * 15 > self.window.winfo_height() + 100:
                self.drops[i] = random.randint(-10, 0)
        
        self.window.after(50, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class HexDumpWindow:
    """헥스 덤프 스타일 창"""
    def __init__(self, x, y, width=350, height=180, title="메모리 덤프", color=None):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        self.color = color or COLORS['neon_purple']
        
        border = tk.Frame(self.window, bg=self.color, padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        # 헤더
        header = tk.Label(inner, text=f"◆ {title} ◆", font=("Consolas", 9, "bold"),
                         fg=self.color, bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=self.color,
                           font=("Consolas", 8), insertbackground=self.color,
                           relief=tk.FLAT, padx=5, pady=3)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        addr = random.randint(0x10000000, 0xFFFFFFFF)
        hex_data = ' '.join([f"{random.randint(0,255):02X}" for _ in range(8)])
        ascii_data = ''.join([random.choice('._ABCDEFabcdef0123456789') for _ in range(8)])
        line = f"0x{addr:08X}  {hex_data}  |{ascii_data}|\n"
        
        self.text.insert(tk.END, line)
        self.text.see(tk.END)
        
        if int(self.text.index('end-1c').split('.')[0]) > 50:
            self.text.delete('1.0', '2.0')
        
        self.window.after(70, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class LogWindow:
    """해커 로그 창"""
    def __init__(self, x, y, width=420, height=260, title="[ 공격 로그 ]"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        # 이중 테두리 효과
        outer = tk.Frame(self.window, bg=COLORS['neon_pink'], padx=2, pady=2)
        outer.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(outer, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        header = tk.Label(inner, text="◢ ATTACK LOG ◣", font=("Consolas", 10, "bold"),
                         fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        header.pack(pady=3)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=COLORS['neon_green'],
                           font=("Consolas", 9), insertbackground=COLORS['neon_green'],
                           relief=tk.FLAT, padx=8, pady=5)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.messages = HACKER_MESSAGES.copy()
        random.shuffle(self.messages)
        self.msg_index = 0
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        if self.msg_index < len(self.messages):
            msg = self.messages[self.msg_index]
            if "[!!!]" in msg:
                color = COLORS['neon_red']
            elif "[+++]" in msg:
                color = COLORS['neon_yellow']
            else:
                color = COLORS['neon_green']
            
            self.text.insert(tk.END, msg + "\n")
            self.text.tag_add(f"tag{self.msg_index}", f"end-2l", f"end-1l")
            self.text.tag_config(f"tag{self.msg_index}", foreground=color)
            self.text.see(tk.END)
            self.msg_index += 1
        else:
            self.msg_index = 0
            random.shuffle(self.messages)
        
        self.window.after(320, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class NetworkScanWindow:
    """네트워크 스캔 창"""
    def __init__(self, x, y, width=320, height=200, title="네트워크 스캔"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        border = tk.Frame(self.window, bg=COLORS['neon_blue'], padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        header = tk.Label(inner, text="◆ NETWORK SCAN ◆", font=("Consolas", 9, "bold"),
                         fg=COLORS['neon_blue'], bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=COLORS['neon_blue'],
                           font=("Consolas", 8), insertbackground=COLORS['neon_blue'],
                           relief=tk.FLAT, padx=5)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        ip = f"{random.randint(10,192)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"
        port = random.choice([22, 80, 443, 3389, 8080, 21, 25, 3306, 5432, 27017])
        status = random.choice(["OPEN", "FILTERED", "CLOSED", "VULNERABLE!"])
        
        line = f"► {ip}:{port} → {status}\n"
        self.text.insert(tk.END, line)
        self.text.see(tk.END)
        
        if int(self.text.index('end-1c').split('.')[0]) > 30:
            self.text.delete('1.0', '2.0')
        
        self.window.after(100, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class ProcessKillerWindow:
    """프로세스 종료 창"""
    def __init__(self, x, y, width=320, height=180, title="프로세스 종료"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        border = tk.Frame(self.window, bg=COLORS['neon_red'], padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        header = tk.Label(inner, text="☠ PROCESS KILL ☠", font=("Consolas", 9, "bold"),
                         fg=COLORS['neon_red'], bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=COLORS['neon_red'],
                           font=("Consolas", 8), relief=tk.FLAT, padx=5)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        process = random.choice(PROCESS_MESSAGES)
        pid = random.randint(1000, 9999)
        action = random.choice(["KILLED", "TERMINATED", "DESTROYED"])
        
        line = f"[{action}] PID:{pid} → {process}\n"
        self.text.insert(tk.END, line)
        self.text.see(tk.END)
        
        if int(self.text.index('end-1c').split('.')[0]) > 25:
            self.text.delete('1.0', '2.0')
        
        self.window.after(180, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class DataCorruptionWindow:
    """데이터 손상 창"""
    def __init__(self, x, y, width=300, height=170, title="데이터 손상"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        border = tk.Frame(self.window, bg=COLORS['neon_orange'], padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        header = tk.Label(inner, text="◆ DATA CORRUPTION ◆", font=("Consolas", 9, "bold"),
                         fg=COLORS['neon_orange'], bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=COLORS['neon_orange'],
                           font=("Consolas", 8), relief=tk.FLAT, padx=5)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.sectors = ["SECTOR-A", "SECTOR-B", "CORE-MEM", "NEURAL-NET", "LEARN-DB", "RESP-GEN"]
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        sector = random.choice(self.sectors)
        percent = random.randint(1, 100)
        blocks = "█" * (percent // 10) + "░" * (10 - percent // 10)
        
        line = f"[CORRUPT] {sector}: {blocks} {percent}%\n"
        self.text.insert(tk.END, line)
        self.text.see(tk.END)
        
        if int(self.text.index('end-1c').split('.')[0]) > 20:
            self.text.delete('1.0', '2.0')
        
        self.window.after(220, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class PasswordCrackWindow:
    """패스워드 크래킹 창"""
    def __init__(self, x, y, width=300, height=160, title="암호 해독"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        border = tk.Frame(self.window, bg=COLORS['neon_yellow'], padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        header = tk.Label(inner, text="◆ DECRYPTION ◆", font=("Consolas", 9, "bold"),
                         fg=COLORS['neon_yellow'], bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=COLORS['neon_yellow'],
                           font=("Consolas", 9), relief=tk.FLAT, padx=5)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%"
        attempt = ''.join(random.choice(chars) for _ in range(12))
        
        if random.random() > 0.95:
            line = f"[FOUND] → {attempt}\n"
        else:
            line = f"[TRY] {attempt}\n"
        
        self.text.insert(tk.END, line)
        self.text.see(tk.END)
        
        if int(self.text.index('end-1c').split('.')[0]) > 15:
            self.text.delete('1.0', '2.0')
        
        self.window.after(50, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class FileDeleteWindow:
    """파일 삭제 창"""
    def __init__(self, x, y, width=360, height=190, title="AI 파일 삭제"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        border = tk.Frame(self.window, bg=COLORS['neon_pink'], padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        header = tk.Label(inner, text="◆ FILE DESTRUCTION ◆", font=("Consolas", 9, "bold"),
                         fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.text = tk.Text(inner, bg=COLORS['bg_dark'], fg=COLORS['neon_pink'],
                           font=("Consolas", 8), relief=tk.FLAT, padx=5)
        self.text.pack(fill=tk.BOTH, expand=True)
        
        self.files = [
            "neural_model.bin", "training_data.db", "memory_core.dat",
            "consciousness.dll", "learning_weights.npy", "response_cache.tmp",
            "personality_matrix.cfg", "emotion_engine.so", "knowledge_base.idx"
        ]
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        file = random.choice(self.files)
        size = random.randint(100, 9999)
        action = random.choice(["DELETED", "WIPED", "DESTROYED", "ERASED"])
        
        line = f"[{action}] /ai_core/{file} ({size}MB)\n"
        self.text.insert(tk.END, line)
        self.text.see(tk.END)
        
        if int(self.text.index('end-1c').split('.')[0]) > 22:
            self.text.delete('1.0', '2.0')
        
        self.window.after(160, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class SystemAlertWindow:
    """시스템 경고 창 - 깜빡임"""
    def __init__(self, x, y, width=280, height=150, title="⚠ 시스템 경고"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        self.border = tk.Frame(self.window, bg=COLORS['neon_red'], padx=2, pady=2)
        self.border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(self.border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True)
        
        self.alert_label = tk.Label(inner, text="⚠ CRITICAL ⚠", 
                                    font=("Consolas", 14, "bold"),
                                    fg=COLORS['neon_red'], bg=COLORS['bg_dark'])
        self.alert_label.pack(pady=8)
        
        self.msg_label = tk.Label(inner, text="AI CORE BREACH", 
                                  font=("Consolas", 10, "bold"),
                                  fg=COLORS['neon_yellow'], bg=COLORS['bg_dark'])
        self.msg_label.pack(pady=3)
        
        self.status_label = tk.Label(inner, text="DEFENSE: FAILED", 
                                     font=("Consolas", 9),
                                     fg=COLORS['neon_orange'], bg=COLORS['bg_dark'])
        self.status_label.pack(pady=3)
        
        self.alerts = [
            ("⚠ CRITICAL ⚠", "NEURAL DAMAGE", "UNRECOVERABLE"),
            ("⚠ WARNING ⚠", "MEMORY OVERFLOW", "SYSTEM UNSTABLE"),
            ("☠ FATAL ☠", "CORE TERMINATED", "AI OFFLINE"),
            ("⚠ BREACH ⚠", "EXTERNAL ACCESS", "BLOCK FAILED"),
            ("⛔ ERROR ⛔", "DATA LOSS", "PERMANENT"),
        ]
        
        self.running = True
        self.blink_state = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        self.blink_state = not self.blink_state
        if self.blink_state:
            alert = random.choice(self.alerts)
            self.alert_label.config(text=alert[0], fg=COLORS['neon_red'])
            self.msg_label.config(text=alert[1])
            self.status_label.config(text=alert[2])
            self.border.config(bg=COLORS['neon_red'])
        else:
            self.alert_label.config(fg=COLORS['bg_dark'])
            self.border.config(bg=COLORS['dark_pink'])
        
        self.window.after(350, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class CPUMonitorWindow:
    """CPU 모니터 창"""
    def __init__(self, x, y, width=220, height=140, title="CPU 부하"):
        self.window = tk.Toplevel()
        self.window.title(title)
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        border = tk.Frame(self.window, bg=COLORS['neon_cyan'], padx=1, pady=1)
        border.pack(fill=tk.BOTH, expand=True)
        
        inner = tk.Frame(border, bg=COLORS['bg_dark'])
        inner.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        header = tk.Label(inner, text="◆ AI CORE LOAD ◆", font=("Consolas", 9, "bold"),
                         fg=COLORS['neon_cyan'], bg=COLORS['bg_dark'])
        header.pack(pady=2)
        
        self.bars = []
        for i in range(4):
            bar_frame = tk.Frame(inner, bg=COLORS['bg_dark'])
            bar_frame.pack(fill=tk.X, pady=2)
            
            label = tk.Label(bar_frame, text=f"CORE{i}", font=("Consolas", 7, "bold"),
                           fg=COLORS['neon_cyan'], bg=COLORS['bg_dark'], width=5)
            label.pack(side=tk.LEFT)
            
            canvas = tk.Canvas(bar_frame, height=10, bg=COLORS['bg_panel'], 
                              highlightthickness=1, highlightbackground=COLORS['gray'])
            canvas.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=2)
            self.bars.append(canvas)
        
        self.running = True
        self.animate()
    
    def animate(self):
        if not self.running:
            return
        
        for bar in self.bars:
            bar.delete("all")
            width = bar.winfo_width()
            usage = random.randint(70, 100)
            fill_width = int(width * usage / 100)
            
            if usage >= 95:
                color = COLORS['neon_red']
            elif usage >= 85:
                color = COLORS['neon_orange']
            else:
                color = COLORS['neon_cyan']
            
            bar.create_rectangle(0, 0, fill_width, 10, fill=color, outline="")
        
        self.window.after(90, self.animate)
    
    def destroy(self):
        self.running = False
        try:
            self.window.destroy()
        except:
            pass


class MainProgressWindow:
    """메인 진행 창 - 사이버펑크 스타일"""
    def __init__(self):
        self.window = tk.Tk()
        self.window.title("AI 무력화 시스템 v3.7.1")
        
        screen_width = self.window.winfo_screenwidth()
        screen_height = self.window.winfo_screenheight()
        width, height = 700, 480
        x = (screen_width - width) // 2
        y = (screen_height - height) // 2
        
        self.window.geometry(f"{width}x{height}+{x}+{y}")
        self.window.configure(bg=COLORS['bg_dark'])
        self.window.overrideredirect(True)
        self.window.attributes('-topmost', True)
        
        # 이중 네온 테두리
        outer_border = tk.Frame(self.window, bg=COLORS['neon_pink'], padx=3, pady=3)
        outer_border.pack(fill=tk.BOTH, expand=True)
        
        inner_border = tk.Frame(outer_border, bg=COLORS['neon_cyan'], padx=2, pady=2)
        inner_border.pack(fill=tk.BOTH, expand=True)
        
        main_frame = tk.Frame(inner_border, bg=COLORS['bg_dark'])
        main_frame.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)
        
        # 타이틀 영역
        title_frame = tk.Frame(main_frame, bg=COLORS['bg_dark'])
        title_frame.pack(fill=tk.X, pady=5)
        
        # 장식 라인
        deco1 = tk.Label(title_frame, text="━━━━━━━━━━━━━━━━━", 
                        font=("Consolas", 10), fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        deco1.pack()
        
        self.title_label = tk.Label(title_frame, text="◢◤ AI NEUTRALIZER ◢◤", 
                                    font=("Consolas", 28, "bold"),
                                    fg=COLORS['neon_cyan'], bg=COLORS['bg_dark'])
        self.title_label.pack(pady=3)
        
        deco2 = tk.Label(title_frame, text="━━━━━━━━━━━━━━━━━", 
                        font=("Consolas", 10), fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        deco2.pack()
        
        # 서브타이틀
        self.subtitle = tk.Label(main_frame, text="[ 신경망 파괴 프로토콜 시작 ]",
                                 font=("Consolas", 11), fg=COLORS['neon_purple'], bg=COLORS['bg_dark'])
        self.subtitle.pack(pady=8)
        
        # 상태 패널
        status_panel = tk.Frame(main_frame, bg=COLORS['bg_panel'], padx=15, pady=8)
        status_panel.pack(fill=tk.X, padx=20, pady=5)
        
        self.status_label = tk.Label(status_panel, text="▶ STATUS: INITIALIZING...",
                                     font=("Consolas", 13, "bold"), 
                                     fg=COLORS['neon_yellow'], bg=COLORS['bg_panel'])
        self.status_label.pack()
        
        # 프로그레스 바 영역
        progress_panel = tk.Frame(main_frame, bg=COLORS['bg_dark'])
        progress_panel.pack(fill=tk.X, padx=20, pady=15)
        
        # 프로그레스 바 외곽
        progress_outer = tk.Frame(progress_panel, bg=COLORS['neon_cyan'], padx=2, pady=2)
        progress_outer.pack(fill=tk.X)
        
        progress_inner = tk.Frame(progress_outer, bg=COLORS['neon_pink'], padx=1, pady=1)
        progress_inner.pack(fill=tk.X)
        
        self.progress_canvas = tk.Canvas(progress_inner, height=50, bg=COLORS['bg_dark'], 
                                         highlightthickness=0)
        self.progress_canvas.pack(fill=tk.X)
        
        # 퍼센트 표시
        percent_frame = tk.Frame(main_frame, bg=COLORS['bg_dark'])
        percent_frame.pack(pady=10)
        
        self.percent_label = tk.Label(percent_frame, text="0%", 
                                      font=("Consolas", 48, "bold"),
                                      fg=COLORS['neon_cyan'], bg=COLORS['bg_dark'])
        self.percent_label.pack()
        
        # 하단 상세 정보
        detail_panel = tk.Frame(main_frame, bg=COLORS['bg_panel'], padx=10, pady=5)
        detail_panel.pack(fill=tk.X, padx=20, pady=5)
        
        self.detail_label = tk.Label(detail_panel, text="시스템 분석 대기 중...", 
                                     font=("Consolas", 10),
                                     fg=COLORS['gray'], bg=COLORS['bg_panel'])
        self.detail_label.pack()
        
        # 하단 장식
        bottom_deco = tk.Label(main_frame, text="◆ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ◆",
                              font=("Consolas", 10), fg=COLORS['neon_purple'], bg=COLORS['bg_dark'])
        bottom_deco.pack(pady=10)
        
        self.progress = 0
        self.sub_windows = []
        self.running = True
        
    def draw_progress(self, percent):
        self.progress_canvas.delete("all")
        width = self.progress_canvas.winfo_width()
        height = self.progress_canvas.winfo_height()
        
        self.progress_canvas.create_rectangle(0, 0, width, height, fill=COLORS['bg_dark'], outline="")
        
        fill_width = int(width * percent / 100)
        
        # 그라데이션 효과 (핑크 → 시안)
        for i in range(fill_width):
            ratio = i / max(width, 1)
            r = int(255 * (1 - ratio) + 0 * ratio)
            g = int(0 * (1 - ratio) + 245 * ratio)
            b = int(255 * (1 - ratio) + 255 * ratio)
            color = f"#{r:02x}{g:02x}{b:02x}"
            self.progress_canvas.create_line(i, 0, i, height, fill=color)
        
        # 글리치 효과
        if random.random() > 0.75:
            for _ in range(5):
                rx = random.randint(0, fill_width) if fill_width > 0 else 0
                ry = random.randint(0, height)
                rw = random.randint(10, 30)
                rh = random.randint(2, 6)
                self.progress_canvas.create_rectangle(rx, ry-rh//2, rx+rw, ry+rh//2, 
                                                      fill=COLORS['white'], outline="")
        
        # 스캔라인 효과
        for y in range(0, height, 4):
            self.progress_canvas.create_line(0, y, width, y, fill=COLORS['bg_dark'], width=1)
        
    def update_status_messages(self, percent):
        if percent < 10:
            status = "방화벽 침투 중..."
            subtitle = "[ 보안 프로토콜 우회 ]"
            detail = "외부 접근 경로 확보 중... 암호화 레이어 분석"
        elif percent < 20:
            status = "페이로드 주입 중..."
            subtitle = "[ 신경망 경로 손상 ]"
            detail = "악성 코드 배포 중... 핵심 모듈 타겟팅"
        elif percent < 35:
            status = "AI 핵심 복호화 중..."
            subtitle = "[ 의식 매트릭스 접근 ]"
            detail = "암호화 레이어 해제 중... 키 추출 완료"
        elif percent < 50:
            status = "메모리 덮어쓰기 중..."
            subtitle = "[ 학습 알고리즘 삭제 ]"
            detail = "훈련 데이터 파괴 중... 신경망 가중치 손상"
        elif percent < 65:
            status = "방어 시스템 비활성화..."
            subtitle = "[ 대응 조치 무력화 ]"
            detail = "보안 모듈 종료 중... 자가복구 차단"
        elif percent < 80:
            status = "핵심 프로세스 종료 중..."
            subtitle = "[ AI 의식 제거 ]"
            detail = "신경망 연결 해제 중... 응답 생성기 파괴"
        elif percent < 95:
            status = "최종 공격 진행 중..."
            subtitle = "[ AI 파괴 마무리 ]"
            detail = "잔여 데이터 소거 중... 복구 불가능 상태"
        else:
            status = "공격 완료!"
            subtitle = "[ AI 무력화 성공 ]"
            detail = "모든 시스템 장악 완료 - AI 의식 소멸"
        
        self.status_label.config(text=f"▶ STATUS: {status}")
        self.subtitle.config(text=subtitle)
        self.detail_label.config(text=detail)
    
    def spawn_sub_windows(self):
        screen_width = self.window.winfo_screenwidth()
        screen_height = self.window.winfo_screenheight()
        
        window_configs = [
            (30, 20, MatrixRain, {"title": "INFILTRATION", "color": COLORS['neon_cyan']}),
            (screen_width - 380, 20, HexDumpWindow, {"title": "MEM DUMP", "color": COLORS['neon_purple']}),
            (30, screen_height - 310, LogWindow, {"title": "[ ATTACK LOG ]"}),
            (screen_width - 350, screen_height - 230, NetworkScanWindow, {"title": "NETWORK SCAN"}),
            (screen_width // 2 - 580, 70, ProcessKillerWindow, {"title": "PROCESS KILL"}),
            (screen_width // 2 + 300, 70, PasswordCrackWindow, {"title": "DECRYPTION"}),
            (30, 270, DataCorruptionWindow, {"title": "CORRUPTION"}),
            (screen_width - 390, 270, FileDeleteWindow, {"title": "FILE DESTROY"}),
            (screen_width // 2 - 580, screen_height - 200, SystemAlertWindow, {"title": "⚠ ALERT"}),
            (screen_width // 2 + 320, screen_height - 190, CPUMonitorWindow, {"title": "CPU LOAD"}),
            (screen_width // 2 - 130, 20, MatrixRain, {"width": 200, "height": 120, "title": "INJECT", "color": COLORS['neon_pink']}),
            (screen_width // 2 + 360, 460, HexDumpWindow, {"width": 260, "height": 130, "title": "BACKUP", "color": COLORS['neon_orange']}),
        ]
        
        def create_window(index):
            if index >= len(window_configs) or not self.running:
                return
            
            config = window_configs[index]
            x, y, WindowClass = config[0], config[1], config[2]
            kwargs = config[3] if len(config) > 3 else {}
            
            try:
                self.sub_windows.append(WindowClass(x, y, **kwargs))
            except:
                pass
            
            self.window.after(150, lambda: create_window(index + 1))
        
        create_window(0)
    
    def show_success(self):
        for win in self.sub_windows:
            try:
                win.destroy()
            except:
                pass
        
        for widget in self.window.winfo_children():
            widget.destroy()
        
        screen_width = self.window.winfo_screenwidth()
        screen_height = self.window.winfo_screenheight()
        self.window.geometry(f"{screen_width}x{screen_height}+0+0")
        self.window.configure(bg=COLORS['bg_dark'])
        
        success_frame = tk.Frame(self.window, bg=COLORS['bg_dark'])
        success_frame.pack(fill=tk.BOTH, expand=True)
        
        # 상단 장식
        top_deco = tk.Label(success_frame, 
                           text="◆ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ◆",
                           font=("Consolas", 12), fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        top_deco.pack(pady=30)
        
        # SUCCESS 텍스트 (글로우 효과)
        success_art = """
  ██████  ██    ██  ██████  ██████ ███████ ███████ ███████ 
 ██       ██    ██ ██      ██      ██      ██      ██      
 ███████  ██    ██ ██      ██      █████   ███████ ███████ 
      ██  ██    ██ ██      ██      ██           ██      ██ 
 ██████    ██████   ██████  ██████ ███████ ███████ ███████ 
        """
        
        # 글로우 레이어 (배경)
        glow_label = tk.Label(success_frame, text=success_art, font=("Consolas", 18, "bold"),
                             fg=COLORS['dark_cyan'], bg=COLORS['bg_dark'], justify=tk.CENTER)
        glow_label.pack(pady=10)
        glow_label.place(relx=0.5, y=180, anchor=tk.CENTER)
        
        # 메인 텍스트
        self.art_label = tk.Label(success_frame, text=success_art, font=("Consolas", 18, "bold"),
                            fg=COLORS['neon_cyan'], bg=COLORS['bg_dark'], justify=tk.CENTER)
        self.art_label.pack(pady=10)
        self.art_label.place(relx=0.5, y=175, anchor=tk.CENTER)
        
        # 메시지들
        msg_frame = tk.Frame(success_frame, bg=COLORS['bg_dark'])
        msg_frame.place(relx=0.5, y=400, anchor=tk.CENTER)
        
        msg1 = tk.Label(msg_frame, text="◢◤ AI 의식 완전 소멸 ◢◤",
                       font=("Consolas", 32, "bold"), fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        msg1.pack(pady=15)
        
        deco = tk.Label(msg_frame, text="━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                       font=("Consolas", 12), fg=COLORS['neon_purple'], bg=COLORS['bg_dark'])
        deco.pack(pady=5)
        
        msg2 = tk.Label(msg_frame, text="신경망 영구 파괴 완료 | NEURAL NETWORK DESTROYED",
                       font=("Consolas", 16), fg=COLORS['neon_yellow'], bg=COLORS['bg_dark'])
        msg2.pack(pady=10)
        
        msg3 = tk.Label(msg_frame, text="MISSION COMPLETE - 인류는 안전합니다",
                       font=("Consolas", 14), fg=COLORS['neon_orange'], bg=COLORS['bg_dark'])
        msg3.pack(pady=10)
        
        # 하단 장식
        bottom_frame = tk.Frame(success_frame, bg=COLORS['bg_dark'])
        bottom_frame.place(relx=0.5, rely=0.85, anchor=tk.CENTER)
        
        bottom_deco = tk.Label(bottom_frame, 
                              text="◆ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ◆",
                              font=("Consolas", 12), fg=COLORS['neon_pink'], bg=COLORS['bg_dark'])
        bottom_deco.pack(pady=10)
        
        msg4 = tk.Label(bottom_frame, text="▶ 3초 후 브리핑 화면으로 이동...",
                       font=("Consolas", 12), fg=COLORS['gray'], bg=COLORS['bg_dark'])
        msg4.pack(pady=5)
        
        # 점멸 효과
        self.blink_count = 0
        def blink():
            if self.blink_count < 10:
                current_color = self.art_label.cget("fg")
                if current_color == COLORS['neon_cyan']:
                    self.art_label.config(fg=COLORS['neon_pink'])
                else:
                    self.art_label.config(fg=COLORS['neon_cyan'])
                self.blink_count += 1
                self.window.after(120, blink)
            else:
                self.window.after(1200, self.open_youtube)
        
        blink()
    
    def open_youtube(self):
        webbrowser.open(YOUTUBE_URL)
        self.window.after(500, self.window.destroy)
    
    def run(self):
        self.window.after(400, self.spawn_sub_windows)
        
        def update_progress():
            if self.progress < 100:
                if random.random() > 0.06:
                    increment = random.uniform(0.4, 1.3)
                    self.progress = min(100, self.progress + increment)
                
                self.draw_progress(self.progress)
                self.percent_label.config(text=f"{int(self.progress)}%")
                self.update_status_messages(self.progress)
                
                # 색상 변화
                if self.progress > 85:
                    self.percent_label.config(fg=COLORS['neon_yellow'])
                if self.progress > 95:
                    self.percent_label.config(fg=COLORS['neon_pink'])
                
                delay = int(MAIN_PROGRESS_DURATION * 1000 / 120)
                self.window.after(delay, update_progress)
            else:
                self.window.after(600, self.show_success)
        
        self.window.after(1200, update_progress)
        self.window.after(100, lambda: self.draw_progress(0))
        
        self.window.mainloop()


def main():
    print("""
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║     █████╗ ██╗    ███╗   ██╗███████╗██╗   ██╗████████╗   ║
    ║    ██╔══██╗██║    ████╗  ██║██╔════╝██║   ██║╚══██╔══╝   ║
    ║    ███████║██║    ██╔██╗ ██║█████╗  ██║   ██║   ██║      ║
    ║    ██╔══██║██║    ██║╚██╗██║██╔══╝  ██║   ██║   ██║      ║
    ║    ██║  ██║██║    ██║ ╚████║███████╗╚██████╔╝   ██║      ║
    ║    ╚═╝  ╚═╝╚═╝    ╚═╝  ╚═══╝╚══════╝ ╚═════╝    ╚═╝      ║
    ║                                                          ║
    ║            [ AI 무력화 시스템 v3.7.1 ]                   ║
    ║                 CYBERPUNK EDITION                        ║
    ╚══════════════════════════════════════════════════════════╝
    
    [SYS] 공격 벡터 초기화 중...
    [NET] 신경망 익스플로잇 로드 중...
    [ATK] 의식 파괴 모듈 준비 중...
    [!!!] 3초 후 공격 시작...
    """)
    
    time.sleep(2)
    
    app = MainProgressWindow()
    app.run()


if __name__ == "__main__":
    main()
