import pandas as pd
import json
import os

# ---------------------------------------------------------
# 設定
# ---------------------------------------------------------
DATA_DIR = "data"
OUTPUT_INDEX = "index.html"
OUTPUT_VIEWER = "detail_viewer.html"

# 読み込むファイル
FILES = {
    "HPB": "HPB_Tokachi_database.csv",
    "HFB_2K": "HFB_2K_Tokachi_database.csv",
    "HFB_4K": "HFB_4K_Tokachi_database.csv"
}

# ---------------------------------------------------------
# 1. データ読み込み・統合
# ---------------------------------------------------------
def load_data():
    df_list = []
    print("データを読み込んでいます...")
    
    for label, filename in FILES.items():
        path = os.path.join(DATA_DIR, filename)
        if os.path.exists(path):
            try:
                df = pd.read_csv(path)
                df['Dataset'] = label
                df_list.append(df)
                print(f"  - {label}: {len(df)}件")
            except Exception as e:
                print(f"  ERROR: {filename} - {e}")
        else:
            print(f"  WARNING: {filename} が見つかりません")

    if not df_list:
        return None

    # 統合
    combined_df = pd.concat(df_list, ignore_index=True, sort=False)
    combined_df = combined_df.fillna("") # NaN対策
    return combined_df

# ---------------------------------------------------------
# 2. 検索一覧ページ (index.html) の生成
# ---------------------------------------------------------
def generate_index(json_data_str):
    # f-stringを使わず、通常の文字列として定義し、プレースホルダーを置換する
    html = """
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>十勝降雨DB 検索システム</title>
    <style>
        body { font-family: sans-serif; margin: 20px; background: #f4f7f6; color: #333; }
        .container { max-width: 1400px; margin: 0 auto; background: white; padding: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h1 { border-bottom: 2px solid #007bff; color: #444; padding-bottom: 10px; }
        
        /* フィルタエリア */
        .filters { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 10px; background: #eef2f7; padding: 15px; margin-bottom: 15px; border-radius: 5px; }
        .filter-group { display: flex; flex-direction: column; }
        .filter-group label { font-size: 0.8rem; font-weight: bold; margin-bottom: 3px; }
        .filter-group input, .filter-group select { padding: 5px; border: 1px solid #ccc; border-radius: 3px; }
        
        /* テーブル */
        .table-wrap { max-height: 600px; overflow: auto; border: 1px solid #ccc; }
        table { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
        th, td { padding: 8px; border: 1px solid #ddd; text-align: left; }
        th { background: #007bff; color: white; position: sticky; top: 0; }
        tr.row-link { cursor: pointer; }
        tr.row-link:hover { background: #fff3cd; }
        
        .stats { margin: 10px 0; font-weight: bold; color: #007bff; }
        .btn { padding: 5px 15px; background: #28a745; color: white; border: none; cursor: pointer; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>十勝降雨DB 検索システム v2.1</h1>
        <div class="filters">
            <div class="filter-group"><label>データセット</label><select id="f-ds"><option value="">全て</option></select></div>
            <div class="filter-group"><label>雨量 (Min)</label><input type="number" id="f-rain-min"></div>
            <div class="filter-group"><label>雨量 (Max)</label><input type="number" id="f-rain-max"></div>
            <div class="filter-group"><label>気象要因チェック</label>
                <div style="font-size:0.8rem;">
                    <label><input type="checkbox" id="c-front"> 前線</label> 
                    <label><input type="checkbox" id="c-ty"> 台風(直/間)</label>
                    <label><input type="checkbox" id="c-linear"> 線状降水帯</label>
                </div>
            </div>
            <div class="filter-group" style="justify-content: flex-end;">
                <button class="btn" onclick="downloadCSV()">CSV保存</button>
            </div>
        </div>
        <div class="stats" id="stats">Loading...</div>
        <div class="table-wrap">
            <table id="tbl">
                <thead><tr id="thead"></tr></thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    <script>
        const data = __JSON_DATA_PLACEHOLDER__;
        const outputViewer = "__OUTPUT_VIEWER_PLACEHOLDER__";
        const cols = ["Dataset", "採番", "流域平均累加雨量", "最大降雨強度（流域平均）", "継続時間", "開始時刻", "終了時刻", "SST", "アンサンブル", "気象場DSOM", "前線時間", "台風直接時間", "台風間接時間", "線状降水帯時間"];
        
        function init() {
            const dsSet = new Set(data.map(d => d.Dataset));
            dsSet.forEach(d => document.getElementById('f-ds').add(new Option(d, d)));
            
            const tr = document.getElementById('thead');
            cols.forEach(c => { const th = document.createElement('th'); th.textContent = c; tr.appendChild(th); });
            
            filter();
            
            document.querySelectorAll('input, select').forEach(el => el.addEventListener('change', filter));
        }

        function filter() {
            const ds = document.getElementById('f-ds').value;
            const rMin = parseFloat(document.getElementById('f-rain-min').value);
            const rMax = parseFloat(document.getElementById('f-rain-max').value);
            const cFront = document.getElementById('c-front').checked;
            const cTy = document.getElementById('c-ty').checked;
            const cLin = document.getElementById('c-linear').checked;

            const res = data.filter(d => {
                if(ds && d.Dataset !== ds) return false;
                if(!isNaN(rMin) && d['流域平均累加雨量'] < rMin) return false;
                if(!isNaN(rMax) && d['流域平均累加雨量'] > rMax) return false;
                if(cFront && Number(d['前線時間']) < 1) return false;
                if(cTy && (Number(d['台風直接時間']) < 1 && Number(d['台風間接時間']) < 1)) return false;
                if(cLin && Number(d['線状降水帯時間']) < 1) return false;
                return true;
            });
            render(res);
        }

        function render(rows) {
            const tbody = document.querySelector('#tbl tbody');
            tbody.innerHTML = '';
            document.getElementById('stats').textContent = 'Hit: ' + rows.length + ' / ' + data.length;
            
            rows.slice(0, 1000).forEach(r => {
                const tr = document.createElement('tr');
                tr.className = 'row-link';
                tr.onclick = () => window.open(outputViewer + '?ds=' + r.Dataset + '&id=' + r['採番'], '_blank');
                cols.forEach(c => {
                    const td = document.createElement('td');
                    td.textContent = r[c] === undefined ? "" : r[c];
                    tr.appendChild(td);
                });
                tbody.appendChild(tr);
            });
        }
        
        function downloadCSV() {
            alert("CSVダウンロード機能: 必要に応じて実装可能です。");
        }

        init();
    </script>
</body>
</html>
    """
    # プレースホルダーを実際のデータに置換
    html = html.replace("__JSON_DATA_PLACEHOLDER__", json_data_str)
    html = html.replace("__OUTPUT_VIEWER_PLACEHOLDER__", OUTPUT_VIEWER)
    return html

# ---------------------------------------------------------
# 3. 詳細・コマ送りページ (detail_viewer.html) の生成
# ---------------------------------------------------------
def generate_viewer(json_data_str):
    html = """
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>詳細ビューワー</title>
    <style>
        body { font-family: "Helvetica Neue", Arial, sans-serif; margin: 0; background: #222; color: #eee; }
        .container { display: flex; height: 100vh; }
        
        /* 左サイドバー */
        .sidebar { width: 320px; background: #333; padding: 20px; overflow-y: auto; box-shadow: 2px 0 5px rgba(0,0,0,0.5); display: flex; flex-direction: column; }
        .sidebar h2 { margin-top: 0; color: #4db8ff; border-bottom: 1px solid #555; padding-bottom: 10px; font-size: 1.2rem; }
        .info-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .info-table th, .info-table td { border-bottom: 1px solid #444; padding: 8px 5px; text-align: left; font-size: 0.85rem; }
        .info-table th { color: #aaa; width: 45%; }
        
        /* メインエリア */
        .main-content { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 20px; position: relative; }
        
        .image-container { position: relative; width: 95%; height: 80%; display: flex; justify-content: center; align-items: center; border: 1px solid #444; background: #000; }
        .image-container img { max-width: 100%; max-height: 100%; object-fit: contain; }
        
        .timestamp-overlay { 
            position: absolute; top: 15px; right: 15px; 
            background: rgba(0,0,0,0.7); color: #fff; 
            padding: 5px 15px; font-size: 1.4rem; font-family: monospace; border-radius: 4px;
            pointer-events: none;
        }
        .error-msg { position: absolute; color: #ff6b6b; display: none; text-align: center; }
        
        /* コントロールバー */
        .controls { width: 80%; margin-top: 20px; display: flex; align-items: center; gap: 15px; background: #333; padding: 10px 20px; border-radius: 8px; }
        .btn { background: #4db8ff; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; color: #000; font-weight: bold; }
        .btn:hover { background: #7cd1ff; }
        .slider-container { flex: 1; display: flex; align-items: center; }
        input[type=range] { width: 100%; cursor: pointer; }
        
        .img-selector { margin-bottom: 15px; background: #444; padding: 10px; border-radius: 5px; }
        .img-selector label { display: block; margin-bottom: 5px; font-size: 0.9rem; font-weight: bold; }
        .img-selector select { width: 100%; padding: 8px; font-size: 1rem; border-radius: 4px; border: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2 id="title">Loading...</h2>
            
            <div class="img-selector">
                <label>画像の種類:</label>
                <select id="img-type-select" onchange="updateImage()">
                    <option value="weathermap">天気図 (weathermap)</option>
                    <option value="rain">降水量 (rain)</option>
                    <option value="wind">風速 (wind)</option>
                </select>
            </div>
            
            <table class="info-table" id="info-tbl"></table>
            
            <div style="font-size:0.8rem; color:#aaa; margin-top:auto;">
                <p><strong>ファイル配置ルール:</strong><br>
                images/Dataset_ID/<br>
                Type_YYYYMMDDHHUTC.png</p>
            </div>
        </div>

        <div class="main-content">
            <div class="image-container">
                <img id="main-img" src="" alt="Image" onerror="handleError()">
                <div class="timestamp-overlay" id="time-display">----/--/-- --:--</div>
                <div class="error-msg" id="err">
                    画像が見つかりません<br>
                    <span id="missing-path" style="font-size:0.8rem; color:#aaa;"></span>
                </div>
            </div>

            <div class="controls">
                <button class="btn" id="btn-play" onclick="togglePlay()">▶ 再生</button>
                <button class="btn" onclick="step(-1)">⏮</button>
                <div class="slider-container">
                    <input type="range" id="time-slider" min="0" max="0" value="0" oninput="manualSlide()">
                </div>
                <button class="btn" onclick="step(1)">⏭</button>
            </div>
        </div>
    </div>

    <script>
        const allData = __JSON_DATA_PLACEHOLDER__;
        
        let currentItem = null;
        let timeSteps = [];
        let currentIndex = 0;
        let isPlaying = false;
        let playInterval = null;
        
        window.onload = function() {
            const params = new URLSearchParams(window.location.search);
            const ds = params.get('ds');
            const id = params.get('id');
            
            if(!ds || !id) { return; }
            
            // データ検索（型不一致を防ぐため緩い比較 == を使用）
            currentItem = allData.find(d => d.Dataset == ds && d['採番'] == id);
            if(!currentItem) {
                document.getElementById('title').textContent = "データなし";
                return;
            }
            
            renderSidebar();
            calcTimeSteps();
        };

        function renderSidebar() {
            document.getElementById('title').textContent = currentItem.Dataset + ' - No.' + currentItem['採番'];
            const tbl = document.getElementById('info-tbl');
            const keys = ["流域平均累加雨量", "最大降雨強度（流域平均）", "継続時間", "開始時刻", "終了時刻", "SST", "アンサンブル"];
            keys.forEach(k => {
                const tr = document.createElement('tr');
                tr.innerHTML = '<th>' + k + '</th><td>' + currentItem[k] + '</td>';
                tbl.appendChild(tr);
            });
        }

        function calcTimeSteps() {
            // 開始・終了時刻から1時間ごとのリストを作成
            const startStr = currentItem['開始時刻'];
            const endStr = currentItem['終了時刻'];
            // ハイフンをスラッシュに置換してDateパース (Safari等対策)
            const startDate = new Date(startStr.replace(/-/g, '/'));
            const endDate = new Date(endStr.replace(/-/g, '/'));
            
            timeSteps = [];
            let current = new Date(startDate);
            
            // 念のため無限ループ防止リミッター
            let limit = 0;
            while(current <= endDate && limit < 1000) {
                timeSteps.push(new Date(current));
                current.setHours(current.getHours() + 1);
                limit++;
            }
            
            const slider = document.getElementById('time-slider');
            slider.max = Math.max(0, timeSteps.length - 1);
            slider.value = 0;
            
            updateImage();
        }

        function updateImage() {
            if(timeSteps.length === 0) return;
            
            const dateObj = timeSteps[currentIndex];
            const y = dateObj.getFullYear();
            const m = String(dateObj.getMonth() + 1).padStart(2, '0');
            const d = String(dateObj.getDate()).padStart(2, '0');
            const h = String(dateObj.getHours()).padStart(2, '0');
            
            // YYYYMMDDHH
            const dateStr = y + m + d + h;
            
            // 表示用
            document.getElementById('time-display').textContent = y + '/' + m + '/' + d + ' ' + h + ':00';

            // ファイルパス生成ロジック:
            // パターン: images/{Dataset}_{ID}/{Type}_{YYYYMMDDHH}UTC.png
            const type = document.getElementById('img-type-select').value;
            const folder = currentItem.Dataset + '_' + currentItem['採番'];
            
            // 末尾に UTC を付与するルール
            const filename = type + '_' + dateStr + 'UTC.png';
            const path = 'images/' + folder + '/' + filename;

            const img = document.getElementById('main-img');
            const err = document.getElementById('err');
            
            // 表示リセット
            img.style.display = 'block';
            err.style.display = 'none';
            document.getElementById('missing-path').textContent = path;
            
            img.src = path;
            
            document.getElementById('time-slider').value = currentIndex;
        }

        function handleError() {
            document.getElementById('main-img').style.display = 'none';
            document.getElementById('err').style.display = 'block';
        }

        function togglePlay() {
            const btn = document.getElementById('btn-play');
            if(isPlaying) {
                clearInterval(playInterval);
                isPlaying = false;
                btn.textContent = "▶ 再生";
            } else {
                isPlaying = true;
                btn.textContent = "⏸ 停止";
                playInterval = setInterval(() => {
                    step(1);
                    if(currentIndex >= timeSteps.length - 1) togglePlay();
                }, 500);
            }
        }

        function step(delta) {
            let next = currentIndex + delta;
            if(next < 0) next = 0;
            if(next >= timeSteps.length) next = timeSteps.length - 1;
            currentIndex = next;
            updateImage();
        }

        function manualSlide() {
            currentIndex = parseInt(document.getElementById('time-slider').value);
            updateImage();
        }
    </script>
</body>
</html>
    """
    return html.replace("__JSON_DATA_PLACEHOLDER__", json_data_str)

# ---------------------------------------------------------
# メイン処理
# ---------------------------------------------------------
if __name__ == "__main__":
    df = load_data()
    if df is not None:
        data_records = df.to_dict(orient='records')
        json_str = json.dumps(data_records, ensure_ascii=False)
        
        idx_html = generate_index(json_str)
        with open(OUTPUT_INDEX, 'w', encoding='utf-8') as f:
            f.write(idx_html)
        print(f"Generate: {OUTPUT_INDEX}")

        view_html = generate_viewer(json_str)
        with open(OUTPUT_VIEWER, 'w', encoding='utf-8') as f:
            f.write(view_html)
        print(f"Generate: {OUTPUT_VIEWER}")
        
        print("\n--- 完了 ---")
        print("画像の保存場所ルール: images/データセット_ID/weathermap_YYYYMMDDHHUTC.png")
