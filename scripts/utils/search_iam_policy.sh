# AWS IAM ポリシーをインタラクティブに検索する関数
# 依存: curl, jq, peco
# WARN: エラーハンドリングはなにもしてない
search_iam_policy() {
    local service_list service_name service_url service_detail api_name

    service_list="$(curl -s https://servicereference.us-east-1.amazonaws.com)"

    service_name="$(echo "${service_list}" | jq -r '.[].service' | peco)"
    service_url="$(echo "${service_list}" | jq -r --arg name "${service_name}" '.[] | select(.service == $name) | .url')"

    service_detail="$(curl -s "${service_url}")"

    api_name="$(echo "${service_detail}" | jq -r '.Operations[].Name' | peco)"

    echo "${service_detail}" | jq --arg name "${api_name}" '.Operations[] | select(.Name == $name)'
}
