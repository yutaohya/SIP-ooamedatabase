% =========================================================================
% 🌐 HTML文言＆機能一括更新プログラム（台風 直接・間接 分離版）
% =========================================================================

T = struct();

% --- 1. 共通・ホーム画面 ---
T.sys_title       = '十勝川流域 大雨データベース β版';
T.sys_subtitle    = 'd4PDF-5km 北海道版(15日実験)に基づく、降雨特性と浸水リスクの統合検索システム';
T.menu_weather    = '気象検索モード';
T.menu_weather_p  = '降雨量や気象要因（台風直接・間接、前線等）の条件を指定し、該当する降雨イベントおよびその浸水深マップを抽出・表示';
T.btn_weather     = 'データベースを開く';
T.menu_flood      = '浸水検索モード';
T.menu_flood_p    = '対象地域内の任意のメッシュを選択し、当該地点における浸水イベントおよびその要因となる気象パターンの統計情報を可視化';
T.btn_flood       = 'マップを開く';
T.nav_back_home   = 'トップページへ戻る';

% --- 2. イベント詳細ビューワー ---
T.dv_title        = 'イベント詳細ビューワー';
T.dv_loading      = '読込中...';
T.dv_close        = '閉じる';
T.dv_info_title   = 'イベント基本情報';
T.dv_th_id        = 'イベントID';
T.dv_th_scene     = 'シナリオ';
T.dv_th_year      = '発生年';
T.dv_note         = '※システムはimagesフォルダ内の該当図面を自動表示します。';
T.dv_img1_title   = 'ハイドログラフ・ハイエトグラフ';
T.dv_img2_title   = '気象場・天気図';
T.dv_img3_title   = '最大浸水深分布マップ';
T.dv_err_nodata   = '※画像ファイルが取得できませんでした。';
T.dv_err_nomap    = '※画像が存在しません。<br><span style="font-size:0.85rem; color:#666; font-weight:normal;">（全域の浸水深が0.1m未満であるためマップが生成されていない可能性があります）</span>';

% --- 3. 気象検索モード ---
T.wx_panel_title  = '大雨イベント検索';
T.wx_filter_all   = 'すべて';
T.wx_filter_rain  = '最低雨量 (mm)';
T.wx_filter_none  = '指定なし';
T.wx_filter_exist = 'あり';
T.wx_result_msg   = '抽出結果:';
T.wx_result_note  = '※一覧の行を選択すると、右画面に浸水深マップが表示されます。';
T.wx_th_rain      = '雨量 (mm)';
T.wx_th_dur       = '継続 (h)';
T.wx_th_tyD       = '台風直接';
T.wx_th_tyI       = '台風間接';
T.wx_th_front     = '前線';
T.wx_th_lin       = '線状降水帯';
T.wx_map_default  = '左のリストからイベントを選択してください';
T.wx_btn_detail   = '詳細図面・ハイドログラフを開く';
T.wx_js_loading   = '画像を読み込んでいます...';
T.wx_js_success   = 'マップ画像の表示が完了しました。';
T.wx_js_error     = '※マップ画像が取得できませんでした。<br><span style="font-size:0.9rem;">（浸水深0.1m未満のイベントの可能性があります）</span>';
T.wx_js_noimg     = '※画像なし';

T.wx_th_rt        = '雨の時間パターン';
T.wx_th_rs        = '雨の空間パターン';

% ★新設: 検索フィルター用
T.wx_filter_tyD   = '台風(500km以内)';
T.wx_filter_tyI   = '台風(1500km以内)';
T.wx_filter_front = '前線(150km以内)';
T.wx_filter_lin   = '線状降水帯(流域内)';
T.wx_filter_rt    = '雨パターン(時間)';
T.wx_filter_rs    = '雨パターン(空間)';

% --- 4. 浸水検索モード ---
T.fl_select_scene = '気候変動シナリオの選択';
T.fl_opt_hpb      = 'HPB (現在気候)';
T.fl_opt_4k       = 'HFB_4K (4度上昇)';
T.fl_opt_2k       = 'HFB_2K (2度上昇)';
T.fl_mesh_label   = '選択メッシュコード';
T.fl_mesh_default = '地図上で対象エリアを選択してください';
T.fl_rank_title   = '浸水深ランキング (上位3件)';
T.fl_rank_note    = '※一覧の行を選択すると詳細情報が表示されます。';
T.fl_detail_title = '大雨要因詳細';
T.fl_lbl_rain     = '流域平均累加雨量';
T.fl_lbl_dur      = '継続時間';
T.fl_btn_detail   = '詳細データ・図面を表示';
T.fl_chart_pie    = '気象要因の割合 <span style="font-weight:normal;font-size:0.8rem;color:#777;">(円グラフ)</span>';
T.fl_chart_sct    = '浸水深と雨量の関係 <span style="font-weight:normal;font-size:0.8rem;color:#777;">(散布図)</span>';
T.fl_chart_cls    = '上位降雨クラスター画像';
T.fl_th_rank      = '順位';
T.fl_th_depth     = '浸水深';
T.fl_js_nodata    = '※該当データが存在しません。';
T.fl_js_nodata_m  = 'データなし';
T.fl_js_nodata_p  = '指定された範囲内に0.1m以上の浸水データは存在しません。';
T.fl_js_nodb      = 'DB未収録';

% ★新設: マップ上のタグ用
T.fl_tag_tyD      = '台風直接';
T.fl_tag_tyI      = '台風間接';
T.fl_tag_front    = '前線要因';
T.fl_tag_lin      = '線状降水帯';

%% --- 以降はシステム処理 ---
rain_dbs = {'HPB_Tokachi_database.csv', 'HFB_4K_Tokachi_database.csv', 'HFB_2K_Tokachi_database.csv'};
rain_dbs = {'HPB_Tokachi_database2.csv', 'HFB_4K_Tokachi_database2.csv', 'HFB_2K_Tokachi_database2.csv'};
flood_csvs = {'HPB_MaxDepth_All_0.1m以上.csv', 'HFB_4K_MaxDepth_All_0.1m以上.csv', 'HFB_2K_MaxDepth_All_0.1m以上.csv'};
dataset_names = {'HPB', 'HFB_4K', 'HFB_2K'};
all_rain_events_for_index = ""; rain_json_parts = strings(3, 1);
% ★追加: 数値から文字列への変換用対応表（辞書）
map_rt = containers.Map({1, 2, 3}, {'集中型', '一般型', '分散型'});
% ★追加: 空間パターン（数値）から文字列への変換用対応表（辞書）
map_rs = containers.Map(...
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, ...
    {'中北部・上流域型', '北部山沿い型', '北西部・源流域型', '西部・日高北部型', '東部・平野部偏重型', ...
     '流域全域分散型', '流域西半域型', '南西部・中流域型', '南部局地型', '南西部・極端集中型'});
for d_idx = 1:3
    if ~isfile(rain_dbs{d_idx}), rain_json_parts(d_idx) = "{}"; continue; end
    opts_r = detectImportOptions(rain_dbs{d_idx}); opts_r.VariableNamingRule = 'preserve'; r_db = readtable(rain_dbs{d_idx}, opts_r); r_lookup = struct();
    for r_idx = 1:height(r_db)
        ens = r_db.("アンサンブル")(r_idx); if isnan(ens); continue; end
        time_val = r_db.("開始時刻")(r_idx); if iscell(time_val), time_val = time_val{1}; end
        if isdatetime(time_val), year_val = time_val.Year; else
            time_str = char(string(time_val)); try start_dt = datetime(time_str); year_val = start_dt.Year; catch, continue; end
        end
        sst_val = ''; if ismember('SST', r_db.Properties.VariableNames), sst_raw = r_db.("SST")(r_idx); if iscell(sst_raw), sst_val = char(sst_raw{1}); elseif isstring(sst_raw) || ischar(sst_raw), sst_val = char(string(sst_raw)); end; end
        if strcmp(dataset_names{d_idx}, 'HPB') || isempty(sst_val) || strcmp(sst_val, 'HPB'), key_str = sprintf('%s_m%03d_%d', dataset_names{d_idx}, ens, year_val); else, key_str = sprintf('%s_%s_m%03d_%d', dataset_names{d_idx}, sst_val, ens, year_val); end
        R_val = r_db.("流域平均累加雨量")(r_idx); D_val = r_db.("継続時間")(r_idx); TYPD_val = r_db.("台風直接時間")(r_idx); TYPI_val = r_db.("台風間接時間")(r_idx); F_val = r_db.("前線時間")(r_idx); L_val = r_db.("線状降水帯時間")(r_idx);num_rt = r_db.("rain_time")(r_idx);num_rs = r_db.("rain_space")(r_idx);
        % ★追加: 数値を文字列に変換（対応表にない値や欠損値の場合は '-' にする）
        if isKey(map_rt, num_rt), str_rt = map_rt(num_rt); else, str_rt = '-'; end
        if isKey(map_rs, num_rs), str_rs = map_rs(num_rs); else, str_rs = '-'; end
        r_lookup.(key_str).R = R_val; r_lookup.(key_str).D = D_val; r_lookup.(key_str).TYPD = TYPD_val; r_lookup.(key_str).TYPI = TYPI_val; r_lookup.(key_str).F = F_val; r_lookup.(key_str).L = L_val;r_lookup.(key_str).RT = str_rt; r_lookup.(key_str).RS = str_rs;
        evt_json = sprintf('{"Dataset":"%s","EventName":"%s","R":%.2f,"D":%.1f,"TYPD":%.1f,"TYPI":%.1f,"F":%.1f,"L":%.1f,"RT":"%s","RS":"%s"},', ...
    dataset_names{d_idx}, key_str, R_val, D_val, TYPD_val, TYPI_val, F_val, L_val, str_rt, str_rs);
        all_rain_events_for_index = all_rain_events_for_index + evt_json;
    end
    rain_json_parts(d_idx) = jsonencode(r_lookup);
end
if strlength(all_rain_events_for_index) > 0, all_rain_events_for_index = extractBefore(all_rain_events_for_index, strlength(all_rain_events_for_index)); end
mesh_json_strings = strings(3, 1);
for d_idx = 1:3
    if ~isfile(flood_csvs{d_idx}), mesh_json_strings(d_idx) = "{}"; continue; end
    opts_f = detectImportOptions(flood_csvs{d_idx}); opts_f.VariableNamingRule = 'preserve'; f_db = readtable(flood_csvs{d_idx}, opts_f);
    for c = 2:width(f_db), if iscell(f_db{:,c}) || isstring(f_db{:,c}) || ischar(f_db{:,c}), f_db{:,c} = str2double(string(f_db{:,c})); end; end
    event_names = string(f_db.Properties.VariableNames(2:end)); num_meshes = height(f_db); mesh_codes_str = compose("%d", f_db.MeshCode); m_char = char(mesh_codes_str);
    lat_arr = str2double(string(m_char(:,1:2)))/1.5 + str2double(string(m_char(:,5)))*5/60 + str2double(string(m_char(:,7)))*30/3600 + str2double(string(m_char(:,9)))*3/3600 + str2double(string(m_char(:,11)))*0.3/3600;
    lon_arr = str2double(string(m_char(:,3:4)))+100 + str2double(string(m_char(:,6)))*7.5/60 + str2double(string(m_char(:,8)))*45/3600 + str2double(string(m_char(:,10)))*4.5/3600 + str2double(string(m_char(:,12)))*0.45/3600;
    data_matrix = table2array(f_db(:, 2:end)); [sorted_vals, sorted_idx] = sort(data_matrix, 2, 'descend'); json_parts = strings(num_meshes, 1);
    for i = 1:num_meshes
        vals = sorted_vals(i, 1:3); valid_idx_sorted = vals >= 0.1; vals = vals(valid_idx_sorted); idxs = sorted_idx(i, valid_idx_sorted);
        if isempty(vals); continue; end
        chunk = ""; for k = 1:length(vals), chunk = chunk + sprintf('{"eid":"%s","d":%.2f},', event_names(idxs(k)), vals(k)); end
        json_parts(i) = sprintf('"%s":{"lat":%.5f,"lng":%.5f,"r":[%s]}', mesh_codes_str(i), lat_arr(i), lon_arr(i), extractBefore(chunk, strlength(chunk)));
    end
    json_parts(json_parts == "") = []; mesh_json_strings(d_idx) = "{" + strjoin(json_parts, ',') + "}";
end

html_home = strjoin({'<!DOCTYPE html><html lang="ja"><head><meta charset="UTF-8"><title>[sys_title]</title><style>body{font-family:"Yu Gothic", "Meiryo", sans-serif;margin:0;background:#f5f7fa;display:flex;flex-direction:column;align-items:center;justify-content:center;height:100vh;}.header{text-align:center;margin-bottom:40px;}.header h1{color:#2c3e50;font-size:2.2rem;margin-bottom:10px;font-weight:bold;}.header p{color:#555;font-size:1.1rem;}.card-container{display:flex;gap:30px;max-width:900px;width:100%;padding:0 20px;}.card{flex:1;background:white;border-radius:4px;padding:40px 30px;box-shadow:0 4px 10px rgba(0,0,0,0.05);text-align:center;text-decoration:none;color:inherit;border-top:4px solid transparent;transition:all 0.2s ease;}.card:hover{transform:translateY(-3px);box-shadow:0 8px 20px rgba(0,0,0,0.1);}.weather{border-top-color:#2c3e50;}.flood{border-top-color:#34495e;}.card h2{color:#2c3e50;margin-bottom:15px;font-size:1.4rem;}.card p{color:#666;line-height:1.6;font-size:0.95rem;margin-bottom:25px;text-align:left;}.btn{display:inline-block;padding:10px 30px;border-radius:3px;font-weight:bold;font-size:0.95rem;transition:background 0.2s;border:1px solid;}.weather .btn{background:#fff;color:#2c3e50;border-color:#2c3e50;}.weather:hover .btn{background:#2c3e50;color:#fff;}.flood .btn{background:#fff;color:#34495e;border-color:#34495e;}.flood:hover .btn{background:#34495e;color:#fff;}</style></head><body><div class="header"><h1>[sys_title]</h1><p>[sys_subtitle]</p></div><div class="card-container"><a href="index.html" class="card weather"><h2>[menu_weather]</h2><p>[menu_weather_p]</p><span class="btn">[btn_weather]</span></a><a href="obihiro_flood_hazard_integrated_map.html" class="card flood"><h2>[menu_flood]</h2><p>[menu_flood_p]</p><span class="btn">[btn_flood]</span></a></div></body></html>'}, char(10));
html_detail = strjoin({'<!DOCTYPE html><html lang="ja"><head><meta charset="UTF-8"><title>[dv_title]</title><style>body{font-family:"Yu Gothic", "Meiryo", sans-serif;margin:0;background:#f8f9fa;color:#333;}.navbar{background:#2c3e50;padding:12px 20px;display:flex;justify-content:space-between;align-items:center;color:white;}.navbar a{color:#ecf0f1;text-decoration:none;font-weight:bold;font-size:0.95rem;border:1px solid #ecf0f1;padding:4px 12px;border-radius:3px;transition:all 0.2s;}.navbar a:hover{background:#ecf0f1;color:#2c3e50;}.container{display:flex;height:calc(100vh - 45px);}.sidebar{width:320px;background:#ffffff;padding:20px;box-shadow:2px 0 5px rgba(0,0,0,0.05);border-right:1px solid #e0e0e0;}.sidebar h2{color:#2c3e50;border-bottom:2px solid #34495e;padding-bottom:10px;font-size:1.1rem;}.info-table{width:100%;border-collapse:collapse;margin-bottom:20px;}.info-table th,.info-table td{border-bottom:1px solid #eee;padding:10px 5px;text-align:left;font-size:0.9rem;}.info-table th{color:#666;width:40%;font-weight:normal;}.main-content{flex:1;padding:20px;display:flex;flex-direction:column;align-items:center;overflow-y:auto;}.image-grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;width:100%;max-width:1200px;}.img-card{background:#fff;border:1px solid #ddd;border-radius:4px;padding:15px;text-align:center;box-shadow:0 2px 4px rgba(0,0,0,0.02);}.img-card img{max-width:100%;max-height:400px;border-radius:3px;object-fit:contain;background:#fafafa;}.img-card h4{margin:0 0 10px 0;color:#2c3e50;font-size:1rem;border-bottom:1px solid #eee;padding-bottom:8px;}.err-msg{color:#c0392b;font-size:0.95rem;margin-top:20px;display:none;line-height:1.5;}</style></head><body><div class="navbar"><span id="event-title" style="font-weight:bold;letter-spacing:1px;">[dv_title]: [dv_loading]</span><a href="javascript:window.close();">[dv_close]</a></div><div class="container"><div class="sidebar"><h2>[dv_info_title]</h2><table class="info-table"><tr><th>[dv_th_id]</th><td id="info-id">-</td></tr><tr><th>[dv_th_scene]</th><td id="info-scenario">-</td></tr><tr><th>[dv_th_year]</th><td id="info-year">-</td></tr></table><p style="color:#888;font-size:0.8rem;line-height:1.5;">[dv_note]</p></div><div class="main-content"><div class="image-grid"><div class="img-card"><h4>[dv_img1_title]</h4><img id="img-hydro" src="" onerror="handleError(this)"><div class="err-msg">[dv_err_nodata]</div></div><div class="img-card"><h4>[dv_img2_title]</h4><img id="img-weather" src="" onerror="handleError(this)"><div class="err-msg">[dv_err_nodata]</div></div><div class="img-card" style="grid-column:span 2;"><h4>[dv_img3_title]</h4><img id="img-inundation" src="" style="max-height:600px;" onerror="handleError(this)"><div class="err-msg">[dv_err_nomap]</div></div></div></div></div><script>const params=new URLSearchParams(window.location.search);const eventId=params.get("event");if(eventId){document.getElementById("event-title").textContent=`[dv_title]: ${eventId}`;document.getElementById("info-id").textContent=eventId;const parts=eventId.split("_");if(parts.length>=3){document.getElementById("info-year").textContent=parts.pop()+"年";parts.pop();document.getElementById("info-scenario").textContent=parts.join("_");}const basePath=`images/${eventId}/`;document.getElementById("img-hydro").src=basePath+"hyeto_hydro.png";document.getElementById("img-weather").src=basePath+"weather_map.png";document.getElementById("img-inundation").src=basePath+"inundation.png";}function handleError(img){img.style.display="none";img.nextElementSibling.style.display="block";}</script></body></html>'}, char(10));
html_index = strjoin({'<!DOCTYPE html><html lang="ja"><head><meta charset="UTF-8"><title>[menu_weather]</title><style>body{font-family:"Yu Gothic", "Meiryo", sans-serif;margin:0;background:#f5f7fa;overflow:hidden;}.navbar{background:#2c3e50;color:white;padding:12px 20px;display:flex;justify-content:space-between;align-items:center;}.navbar a{color:white;text-decoration:none;font-weight:bold;font-size:0.95rem;border:1px solid #ecf0f1;padding:4px 12px;border-radius:3px;transition:all 0.2s;}.navbar a:hover{background:#ecf0f1;color:#2c3e50;}#content{display:flex;height:calc(100vh - 49px);}#left-panel{width:55%;padding:20px;overflow-y:auto;background:white;box-shadow:2px 0 5px rgba(0,0,0,0.05);z-index:10;}#right-panel{width:45%;position:relative;background:#eef2f7;}h2{color:#2c3e50;font-size:1.2rem;margin-top:0;border-bottom:2px solid #34495e;padding-bottom:10px;}.filters{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:15px;background:#f8f9fa;padding:15px;margin-bottom:15px;border-radius:4px;border:1px solid #e0e0e0;}.filter-group{display:flex;flex-direction:column;}label{font-size:0.8rem;font-weight:bold;margin-bottom:5px;color:#555;}input,select{padding:6px;border:1px solid #ccc;border-radius:3px;font-family:inherit;}table{width:100%;border-collapse:collapse;font-size:0.85rem;}th,td{border:1px solid #ddd;padding:8px 6px;text-align:left;}th{background:#34495e;color:white;position:sticky;top:0;font-weight:normal;}.row-link{cursor:pointer;transition:background 0.1s;}.row-link:hover{background:#f1f8ff;}.row-link.active{background:#dcedff;font-weight:bold;}#overlay-info{position:absolute;top:15px;right:15px;z-index:1000;background:rgba(255,255,255,0.95);padding:20px;border-radius:4px;box-shadow:0 4px 12px rgba(0,0,0,0.15);display:none;max-width:320px;border:1px solid #ddd;}.detail-btn{display:block;margin-top:15px;padding:10px;background:#34495e;color:white;text-align:center;text-decoration:none;border-radius:3px;font-weight:bold;font-size:0.9rem;transition:background 0.2s;}.detail-btn:hover{background:#2c3e50;}#map-container{width:100%; height:100%; display:flex; align-items:center; justify-content:center; flex-direction:column;}#map-img{max-width:100%; max-height:100%; object-fit:contain; display:none; box-shadow:0 4px 15px rgba(0,0,0,0.1);}#map-placeholder{color:#7f8c8d; font-size:1.1rem; text-align:center; padding:20px;}</style></head><body><div class="navbar"><span style="font-size:1.1rem;font-weight:bold;letter-spacing:1px;">[menu_weather]</span><a href="home.html">[nav_back_home]</a></div><div id="content"><div id="left-panel"><h2>[wx_panel_title]</h2>'
    '<div class="filters"><div class="filter-group"><label>[dv_th_scene]</label><select id="f-ds"><option value="">[wx_filter_all]</option><option value="HPB">HPB</option><option value="HFB_2K">HFB_2K</option><option value="HFB_4K">HFB_4K</option></select></div><div class="filter-group"><label>[wx_filter_rain]</label><input type="number" id="f-rmin"></div>'
    '<div class="filter-group"><label>[wx_filter_front]</label><select id="f-front"><option value="">[wx_filter_none]</option><option value="1">[wx_filter_exist]</option></select></div>'
    '<div class="filter-group"><label>[wx_filter_tyD]</label><select id="f-tyD"><option value="">[wx_filter_none]</option><option value="1">[wx_filter_exist]</option></select></div>'
    '<div class="filter-group"><label>[wx_filter_tyI]</label><select id="f-tyI"><option value="">[wx_filter_none]</option><option value="1">[wx_filter_exist]</option></select></div>'
    '<div class="filter-group"><label>[wx_filter_lin]</label><select id="f-lin"><option value="">[wx_filter_none]</option><option value="1">[wx_filter_exist]</option></select></div></div>'
    '<div class="filter-group"><label>[wx_filter_rt]</label><select id="f-rt"><option value="">[wx_filter_all]</option><option value="集中型">短期集中型</option><option value="一般型">一般型</option><option value="分散型">長期分散型</option></select></div>'
    '<div class="filter-group"><label>[wx_filter_rs]</label><select id="f-rs">'
    '<option value="">[wx_filter_all]</option>'
        '<option value="中北部・上流域型">1. 中北部・上流域型</option>'
        '<option value="北部山沿い型">2. 北部山沿い型</option>'
        '<option value="北西部・源流域型">3. 北西部・源流域型</option>'
        '<option value="西部・日高北部型">4. 西部・日高北部型</option>'
        '<option value="東部・平野部偏重型">5. 東部・平野部偏重型</option>'
        '<option value="流域全域分散型">6. 流域全域分散型</option>'
        '<option value="流域西半域型">7. 流域西半域型</option>'
        '<option value="南西部・中流域型">8. 南西部・中流域型</option>'
        '<option value="南部局地型">9. 南部局地型</option>'
        '<option value="南西部・極端集中型">10. 南西部・極端集中型</option>'
'</select></div>'
    '<div id="stats" style="font-weight:bold;margin-bottom:10px;color:#2c3e50;">[wx_result_msg] - / - <span style="font-size:0.8rem;color:#777;font-weight:normal;margin-left:10px;">[wx_result_note]</span></div><div style="overflow-x:auto;max-height:60vh;"><table id="tbl"><thead><tr><th>[dv_th_scene]</th><th>[dv_th_id]</th><th>[wx_th_rain]</th><th>[wx_th_dur]</th><th>[wx_th_tyD]</th><th>[wx_th_tyI]</th><th>[wx_th_front]</th><th>[wx_th_lin]</th><th>[wx_th_rt]</th><th>[wx_th_rs]</th></tr></thead><tbody></tbody></table></div></div><div id="right-panel"><div id="map-container"><div id="map-placeholder">[wx_map_default]</div><img id="map-img" src="" alt="Map"></div><div id="overlay-info"><h3 style="margin:0 0 8px 0;color:#2c3e50;font-size:1.1rem;border-bottom:1px solid #eee;padding-bottom:5px;" id="info-evt-id">-</h3><p id="info-msg" style="margin:0;font-size:0.85rem;color:#666;line-height:1.4;"></p><a href="#" id="link-detail" class="detail-btn" target="_blank">[wx_btn_detail]</a></div></div></div>'
    '<script>'
    ['const data = [' char(all_rain_events_for_index) '];']
    'let activeRow = null;'
%     'function filterData(){const ds=document.getElementById("f-ds").value;const rMin=parseFloat(document.getElementById("f-rmin").value);const fFront=document.getElementById("f-front").value;const fTyD=document.getElementById("f-tyD").value;const fTyI=document.getElementById("f-tyI").value;const fLin=document.getElementById("f-lin").value;const res=data.filter(d=>{if(ds&&d.Dataset!==ds)return false;if(!isNaN(rMin)&&d.R<rMin)return false;if(fFront==="1"&&d.F<=0)return false;if(fTyD==="1"&&d.TYPD<=0)return false;if(fTyI==="1"&&d.TYPI<=0)return false;if(fLin==="1"&&d.L<=0)return false;return true;});render(res);}'
%     'function render(rows){const tbody=document.querySelector("#tbl tbody");tbody.innerHTML="";document.getElementById("stats").innerHTML=`[wx_result_msg] ${rows.length} / ${data.length} <span style="font-size:0.8rem;color:#777;font-weight:normal;margin-left:10px;">[wx_result_note]</span>`;rows.slice(0,500).forEach(r=>{const tr=document.createElement("tr");tr.className="row-link";tr.onclick=function(){ if(activeRow) activeRow.classList.remove("active"); tr.classList.add("active"); activeRow=tr; selectEvent(r.EventName); };tr.innerHTML=`<td>${r.Dataset}</td><td>${r.EventName}</td><td>${r.R.toFixed(1)}</td><td>${r.D.toFixed(1)}</td><td>${r.TYPD.toFixed(1)}</td><td>${r.TYPI.toFixed(1)}</td><td>${r.F.toFixed(1)}</td><td>${r.L.toFixed(1)}</td>`;tbody.appendChild(tr);});}'
%     // ★追加: fRt, fRsの取得と、文字列一致によるフィルタリング条件の追加
    'function filterData(){const ds=document.getElementById("f-ds").value;const rMin=parseFloat(document.getElementById("f-rmin").value);const fFront=document.getElementById("f-front").value;const fTyD=document.getElementById("f-tyD").value;const fTyI=document.getElementById("f-tyI").value;const fLin=document.getElementById("f-lin").value; const fRt=document.getElementById("f-rt").value; const fRs=document.getElementById("f-rs").value; const res=data.filter(d=>{if(ds&&d.Dataset!==ds)return false;if(!isNaN(rMin)&&d.R<rMin)return false;if(fFront==="1"&&d.F<=0)return false;if(fTyD==="1"&&d.TYPD<=0)return false;if(fTyI==="1"&&d.TYPI<=0)return false;if(fLin==="1"&&d.L<=0)return false; if(fRt&&d.RT!==fRt)return false; if(fRs&&d.RS!==fRs)return false; return true;});render(res);}'
%     // ★追加: <td>${r.RT}</td><td>${r.RS}</td> を末尾に追加
    'function render(rows){const tbody=document.querySelector("#tbl tbody");tbody.innerHTML="";document.getElementById("stats").innerHTML=`[wx_result_msg] ${rows.length} / ${data.length} <span style="font-size:0.8rem;color:#777;font-weight:normal;margin-left:10px;">[wx_result_note]</span>`;rows.slice(0,500).forEach(r=>{const tr=document.createElement("tr");tr.className="row-link";tr.onclick=function(){ if(activeRow) activeRow.classList.remove("active"); tr.classList.add("active"); activeRow=tr; selectEvent(r.EventName); };tr.innerHTML=`<td>${r.Dataset}</td><td>${r.EventName}</td><td>${r.R.toFixed(1)}</td><td>${r.D.toFixed(1)}</td><td>${r.TYPD.toFixed(1)}</td><td>${r.TYPI.toFixed(1)}</td><td>${r.F.toFixed(1)}</td><td>${r.L.toFixed(1)}</td><td>${r.RT}</td><td>${r.RS}</td>`;tbody.appendChild(tr);});}'
    'function selectEvent(eventId){const infoBox = document.getElementById("overlay-info"); infoBox.style.display="block"; document.getElementById("info-evt-id").innerText=eventId; document.getElementById("link-detail").href=`detail_viewer.html?event=${eventId}`; const msg = document.getElementById("info-msg"); msg.innerText=`[wx_js_loading]`; msg.style.color="#666"; const imgEl = document.getElementById("map-img"); const placeholder = document.getElementById("map-placeholder"); imgEl.style.display = "none"; placeholder.style.display = "block"; placeholder.innerHTML = `[wx_js_loading]`; const imgUrl = `images/${eventId}/inundation.png?t=${new Date().getTime()}`; imgEl.onload = function(){ imgEl.style.display="block"; placeholder.style.display="none"; msg.innerText=`[wx_js_success]`; }; imgEl.onerror = function(){ placeholder.innerHTML=`[wx_js_error]`; msg.innerHTML=`[wx_js_noimg]`; msg.style.color="#c0392b"; }; imgEl.src = imgUrl;}'
    'document.querySelectorAll("input,select").forEach(e=>e.addEventListener("change",filterData));filterData();</script></body></html>'
}, char(10));

html_map = strjoin({
    '<!DOCTYPE html><html lang="ja"><head><meta charset="UTF-8"><title>[menu_flood]</title>'
    '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/><script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>'
    '<style>body{margin:0;padding:0;display:flex;flex-direction:column;height:100vh;font-family:"Yu Gothic", "Meiryo", sans-serif;background:#f5f7fa;}.navbar{background:#2c3e50;color:white;padding:12px 20px;display:flex;justify-content:space-between;align-items:center;z-index:1000;}.navbar a{color:white;text-decoration:none;font-weight:bold;font-size:0.95rem;border:1px solid #ecf0f1;padding:4px 12px;border-radius:3px;transition:all 0.2s;}.navbar a:hover{background:#ecf0f1;color:#2c3e50;}#main{display:flex;flex:1;overflow:hidden;}#map{flex:1;}#sidebar{width:480px;background:#ffffff;padding:25px;overflow-y:auto;border-left:1px solid #e0e0e0;box-shadow:-2px 0 5px rgba(0,0,0,0.05);}h3{color:#2c3e50;font-size:1.1rem;margin-top:0;border-bottom:2px solid #34495e;padding-bottom:8px;}.control-group{background:#f8f9fa;padding:15px;border-radius:4px;border:1px solid #e0e0e0;margin-bottom:20px;}select{width:100%;padding:8px;border-radius:3px;border:1px solid #ccc;font-family:inherit;color:#333;}table{width:100%;border-collapse:collapse;margin-top:10px;background:#fff;}th,td{text-align:left;padding:10px 8px;border-bottom:1px solid #eee;font-size:0.9rem;}th{background:#34495e;color:white;font-weight:normal;}#ranking-result table tr{cursor:pointer;transition:background 0.1s;}#ranking-result table tr:hover{background:#f1f8ff;}.depth-val{font-weight:bold;color:#c0392b;}.factor-tag{display:inline-block;padding:3px 8px;border-radius:3px;font-size:0.75rem;font-weight:bold;color:white;margin-right:5px;}'
    '.tag-typhoon-d{background:#d35400;}.tag-typhoon-i{background:#f39c12;}.tag-front{background:#16a085;}.tag-linear{background:#c0392b;}'
    '.detail-btn{display:block;width:calc(100% - 20px);text-align:center;background:#34495e;color:white;padding:10px;margin-top:15px;border-radius:3px;text-decoration:none;font-weight:bold;font-size:0.95rem;transition:background 0.2s;}.detail-btn:hover{background:#2c3e50;}.pre-img { width: 100%; border: 1px solid #ddd; border-radius: 3px; display: none; margin-bottom: 5px; background:#fff;}.msg { font-size:0.8rem; color:#c0392b; margin: 0; }.data-label { font-size:0.8rem; color:#666; display:block; margin-bottom:2px; } .data-value { font-size:1rem; color:#2c3e50; font-weight:bold; margin-bottom:10px; }</style></head>'
    '<body><div class="navbar"><span style="font-size:1.1rem;font-weight:bold;letter-spacing:1px;">[menu_flood]</span><a href="home.html">[nav_back_home]</a></div>'
    '<div id="main"><div id="map"></div><div id="sidebar"><div class="control-group"><label style="font-weight:bold;font-size:0.9rem;display:block;margin-bottom:8px;color:#2c3e50;">[fl_select_scene]</label><select id="dataset-select"><option value="HPB">[fl_opt_hpb]</option><option value="HFB_4K">[fl_opt_4k]</option><option value="HFB_2K">[fl_opt_2k]</option></select></div><div class="control-group" style="padding:10px 15px;"><span class="data-label">[fl_mesh_label]</span><span id="mesh-coords" class="data-value" style="margin-bottom:0;color:#777;font-weight:normal;font-size:0.9rem;">[fl_mesh_default]</span></div><h3>[fl_rank_title]</h3><div id="ranking-result"><p style="font-size:0.9rem;color:#666;">[fl_rank_note]</p></div><div id="heavyrain-info" class="control-group" style="display:none;margin-top:20px;border-left:4px solid #34495e;background:#fff;"><h3 style="margin-top:0;border:none;padding-bottom:0;">[fl_detail_title]</h3><div style="display:flex; flex-wrap:wrap; gap:15px; margin-top:15px;"><div style="flex:1;"><span class="data-label">[dv_th_id]</span><span id="rain-event-id" class="data-value">-</span></div><div style="flex:1;"><span class="data-label">[fl_lbl_rain]</span><span id="rain-total" class="data-value">- mm</span></div><div style="flex:1;"><span class="data-label">[fl_lbl_dur]</span><span id="rain-dur" class="data-value">- h</span></div></div>'
    '<div style="margin-top:10px;"><span id="tag-typD" class="factor-tag tag-typhoon-d">[fl_tag_tyD]</span><span id="tag-typI" class="factor-tag tag-typhoon-i">[fl_tag_tyI]</span><span id="tag-front" class="factor-tag tag-front">[fl_tag_front]</span><span id="tag-linear" class="factor-tag tag-linear">[fl_tag_lin]</span></div><a href="#" id="link-detail" class="detail-btn" target="_blank">[fl_btn_detail]</a></div><div id="analytics-area" style="display:none;"><div class="control-group"><h3 style="margin-top:0; font-size:1rem;">[fl_chart_pie]</h3><img id="img-pie" class="pre-img" src=""><p id="msg-pie" class="msg"></p></div><div class="control-group"><h3 style="margin-top:0; font-size:1rem;">[fl_chart_sct]</h3><img id="img-scatter" class="pre-img" src=""><p id="msg-scatter" class="msg"></p></div><div class="control-group"><h3 style="margin-top:0; font-size:1rem;">[fl_chart_cls]</h3><img id="img-cluster" class="pre-img" src=""><p id="msg-cluster" class="msg"></p></div></div></div></div>'
    '<script>'
    ['const meshData={"HPB":' char(mesh_json_strings(1)) ',"HFB_4K":' char(mesh_json_strings(2)) ',"HFB_2K":' char(mesh_json_strings(3)) '};']
    ['const rainData={"HPB":' char(rain_json_parts(1)) ',"HFB_4K":' char(rain_json_parts(2)) ',"HFB_2K":' char(rain_json_parts(3)) '};']
    'const map=L.map("map").setView([42.924,143.196],12);L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",{maxZoom:18}).addTo(map);let currentMarker=null;let lastClick=null;document.getElementById("dataset-select").addEventListener("change",()=>{document.getElementById("heavyrain-info").style.display="none";if(lastClick)processClick(lastClick);});map.on("click",e=>{lastClick=e.latlng;document.getElementById("heavyrain-info").style.display="none";processClick(lastClick);});'
    'function processClick(latlng){const sc=document.getElementById("dataset-select").value;const meshSet=meshData[sc];let nearestMesh=null;let minSqDist=Infinity;for(const code in meshSet){const sqDist=Math.pow(latlng.lat-meshSet[code].lat,2)+Math.pow(latlng.lng-meshSet[code].lng,2);if(sqDist<minSqDist){minSqDist=sqDist;nearestMesh=code;}}if(nearestMesh&&minSqDist<0.0004){const data=meshSet[nearestMesh];document.getElementById("mesh-coords").innerHTML=`<strong>${nearestMesh}</strong> <span style="font-size:0.8rem;color:#777;margin-left:10px;">(Lat: ${data.lat.toFixed(5)}, Lng: ${data.lng.toFixed(5)})</span>`;document.getElementById("analytics-area").style.display="block";const bPath=`images/analytics/${sc}_${nearestMesh}`;const pImg=document.getElementById("img-pie"); pImg.src=`${bPath}_pie.png`; pImg.style.display="block"; document.getElementById("msg-pie").innerText="";pImg.onerror=function(){ this.style.display="none"; document.getElementById("msg-pie").innerText=`[fl_js_nodata]`; };const sImg=document.getElementById("img-scatter"); sImg.src=`${bPath}_scatter.png`; sImg.style.display="block"; document.getElementById("msg-scatter").innerText="";sImg.onerror=function(){ this.style.display="none"; document.getElementById("msg-scatter").innerText=`[fl_js_nodata]`; };const cImg=document.getElementById("img-cluster"); cImg.src=`${bPath}_cluster.png`; cImg.style.display="block"; document.getElementById("msg-cluster").innerText="";cImg.onerror=function(){ this.style.display="none"; document.getElementById("msg-cluster").innerText=`[fl_js_nodata]`; };let html=`<table><thead><tr><th>[fl_th_rank]</th><th>[dv_th_year]</th><th>[fl_th_depth]</th></tr></thead><tbody>`;data.r.forEach((item,i)=>{let year=item.eid.split("_").pop()+"年";html+=`<tr onclick="showHeavyRainInfo(''${sc}'',''${item.eid}'')"><td>${i+1}</td><td>${year}</td><td class="depth-val">${item.d.toFixed(2)} m</td></tr>`;});html+=`</tbody></table>`;document.getElementById("ranking-result").innerHTML=html;if(currentMarker)map.removeLayer(currentMarker);currentMarker=L.circleMarker([data.lat,data.lng],{radius:8,color:"#c0392b",fillColor:"#e74c3c",fillOpacity:0.6}).addTo(map);}else{document.getElementById("mesh-coords").innerHTML=`<span style="color:#c0392b;">[fl_js_nodata_m]</span>`;document.getElementById("ranking-result").innerHTML=`<p style="font-size:0.9rem;color:#666;">[fl_js_nodata_p]</p>`;document.getElementById("analytics-area").style.display="none";if(currentMarker)map.removeLayer(currentMarker);}}'
    'function showHeavyRainInfo(scen,eventId){let info = rainData[scen][eventId];if(!info){const match = eventId.match(/m\d{3}_\d{4}/);if(match){ const shortKey = match[0]; const foundKey = Object.keys(rainData[scen]).find(k => k.includes(shortKey)); if(foundKey) info = rainData[scen][foundKey]; }}const infoDiv=document.getElementById("heavyrain-info"); infoDiv.style.display="block"; document.getElementById("rain-event-id").innerText=eventId;if(!info){document.getElementById("rain-total").innerText=`[fl_js_nodb]`; document.getElementById("rain-dur").innerText="-";document.getElementById("tag-typD").style.display="none";document.getElementById("tag-typI").style.display="none"; document.getElementById("tag-front").style.display="none"; document.getElementById("tag-linear").style.display="none";document.getElementById("link-detail").href=`detail_viewer.html?event=${eventId}`; window.open(`detail_viewer.html?event=${eventId}`, "_blank"); return;}document.getElementById("rain-total").innerText=info.R.toFixed(1)+" mm";document.getElementById("rain-dur").innerText=info.D.toFixed(1)+" h";document.getElementById("tag-typD").style.display=(info.TYPD>0)?"inline-block":"none";document.getElementById("tag-typI").style.display=(info.TYPI>0)?"inline-block":"none";document.getElementById("tag-front").style.display=(info.F>0)?"inline-block":"none";document.getElementById("tag-linear").style.display=(info.L>0)?"inline-block":"none";document.getElementById("link-detail").href=`detail_viewer.html?event=${eventId}`;window.open(`detail_viewer.html?event=${eventId}`, "_blank");}'
    '</script></body></html>'
}, char(10));

% --- テキスト置換 ---
fields = fieldnames(T);
for i = 1:numel(fields)
    key = sprintf('[%s]', fields{i});
    html_home   = strrep(html_home, key, T.(fields{i}));
    html_detail = strrep(html_detail, key, T.(fields{i}));
    html_index  = strrep(html_index, key, T.(fields{i}));
    html_map    = strrep(html_map, key, T.(fields{i}));
end

fid = fopen('home.html', 'w', 'n', 'UTF-8'); fprintf(fid, '%s', html_home); fclose(fid);
fid = fopen('detail_viewer.html', 'w', 'n', 'UTF-8'); fprintf(fid, '%s', html_detail); fclose(fid);
fid = fopen('index.html', 'w', 'n', 'UTF-8'); fprintf(fid, '%s', html_index); fclose(fid);
fid = fopen('obihiro_flood_hazard_integrated_map.html', 'w', 'n', 'UTF-8'); fprintf(fid, '%s', html_map); fclose(fid);

fprintf('【完了】台風(直接/間接)の分離アップデートが完了しました！\n');
