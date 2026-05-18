#!/usr/bin/env bash
# 官网静态文件发布脚本：同步 website/ 整个静态站点目录到服务器。
# 会同步 index.html、pc.html、mobile.html、assets/ 等运行所需内容；
# 不同步部署方案、脚本、Git 元数据、文档目录和本机杂项文件。
#
# 环境变量（均可选）：
#   WEBSITE_DEPLOY_SSH_HOST     默认 my-mini-program
#   WEBSITE_DEPLOY_REMOTE_DIR   默认 /opt/mikestan-website
#
# 用法：
#   ./website/deploy.sh
#   或在 website/ 目录内执行 ./deploy.sh
#
# 前置条件（仅首次在服务器上）：
#   - 目录 ${WEBSITE_DEPLOY_REMOTE_DIR} 已存在且对部署用户可写
#   - Nginx 已配置 root 指向 ${WEBSITE_DEPLOY_REMOTE_DIR}
set -euo pipefail

WEBSITE_DIR="$(cd "$(dirname "$0")" && pwd)"
SSH_HOST="${WEBSITE_DEPLOY_SSH_HOST:-my-mini-program}"
REMOTE_DIR="${WEBSITE_DEPLOY_REMOTE_DIR:-/opt/mikestan-website}"

if [[ ! -f "${WEBSITE_DIR}/index.html" ]]; then
  echo "error: missing ${WEBSITE_DIR}/index.html" >&2
  exit 1
fi

ssh "${SSH_HOST}" "test -d '${REMOTE_DIR}' && test -w '${REMOTE_DIR}'" || {
  echo "error: remote directory ${REMOTE_DIR} does not exist or is not writable" >&2
  echo "hint: ssh ${SSH_HOST} \"sudo mkdir -p ${REMOTE_DIR} && sudo chown -R \\$USER:\\$USER ${REMOTE_DIR}\"" >&2
  exit 1
}

rsync -avz --delete -e ssh \
  --exclude=".DS_Store" \
  --exclude=".git" \
  --exclude=".gitignore" \
  --exclude="docs" \
  --exclude="deploy.sh" \
  --exclude="*.md" \
  "${WEBSITE_DIR}/" "${SSH_HOST}:${REMOTE_DIR}/"

echo "Website files deployed to ${SSH_HOST}:${REMOTE_DIR}"
