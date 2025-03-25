# script.py
import os
from openai import OpenAI
import json

# 获取事件数据文件路径
event_path = os.getenv('GITHUB_EVENT_PATH')

if not event_path:
    raise ValueError("GITHUB_EVENT_PATH 环境变量未找到")

# 读取并解析 JSON 数据
with open(event_path, 'r') as f:
    event_data = json.load(f)

# 提取评论内容
comment_body = event_data.get('comment', {}).get('body')


# Non-streaming:
# print("----- standard event_data:",event_data)
# print("----- standard comment_body:",comment_body)
print("----- standard request, comment_body:",comment_body)
# gets API Key from environment variable OPENAI_API_KEY
client = OpenAI(
    api_key=os.getenv('HUNYUAN_API_KEY'), # 混元 APIKey
    base_url="https://api.hunyuan.cloud.tencent.com/v1", # 混元 endpoint
)

completion = client.chat.completions.create(
    model="hunyuan-turbo",
    messages=[
        {
            "role": "user",
            "content": f"""请帮我把以下中文文档翻译成英文,并以markdown格式输出:
{comment_body}""",
        },
    ],
)
print(completion.choices[0].message.content)

# 写入文件
file_path = "../../CHANGELOG.md"
new_content = f"""{completion.choices[0].message.content}


"""
line_number = 1

try:
    # 读取原文件内容
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # 处理行号（将人类理解的 1-based 转为 0-based）
    insert_pos = line_number - 1

    # 处理行号超出范围的情况（插入到文件末尾）
    if insert_pos > len(lines):
        insert_pos = len(lines)

    # 插入新内容（自动添加换行符）
    if not new_content.endswith('\n'):
        new_content += '\n'
    lines.insert(insert_pos, new_content)

    # 写回文件
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)

    print(f"成功在第 {line_number} 行插入内容")

except FileNotFoundError:
    print(f"错误：文件 {file_path} 不存在")
except Exception as e:
    print(f"操作失败：{str(e)}")