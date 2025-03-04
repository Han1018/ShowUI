import json
import random

def sample_icons_from_json(input_file, output_file):
    # 讀取原始 JSON
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # 最後要輸出的新結構
    output_data = {}
    
    # 我們只關注這三個區塊
    categories_to_sample = ["desktop", "web", "mobile"]
    
    # 依序處理這三個區塊
    for category in categories_to_sample:
        # 若該區塊不存在，則略過
        if category not in data:
            continue
        
        # 若該區塊下沒有 "icon" 欄位，則略過
        if "icon" not in data[category]:
            continue
        
        # 原始 icon 陣列
        icon_list = data[category]["icon"]
        
        # 隨機抽樣最多 10 筆
        if len(icon_list) > 10:
            icon_list = random.sample(icon_list, 10)
        
        # 將抽樣結果存到新的結構
        output_data[category] = {
            "icon": icon_list
        }
    
    # 將只含抽樣結果的新 JSON 寫出到指定檔案
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output_data, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    # 設定輸入檔與輸出檔
    input_json = "./logs/debug/2025-02-22_17-35-25/tmp/screenspot_filter_acc0.json"   # 請換成你的檔案路徑
    output_json = "./logs/debug/2025-02-22_17-35-25/tmp/sample_10_failed_tasks.json" # 請換成你想輸出的檔案路徑
    
    sample_icons_from_json(input_json, output_json)
    print(f"抽樣完成，結果已寫入 {output_json}。")
