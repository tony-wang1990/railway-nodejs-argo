# railway-nodejs-argo

在 Railway 或 Docker 上一键部署 Argo 隧道（支持 VLESS / VMess / Trojan），并可选接入哪吒探针。

> ⚠️ **重要声明：`index.js` 为混淆代码，不可审计。**
> 本仓库的核心文件 `index.js`（约 101 KB，仅 2 行）是上游原样带来的混淆产物，
> 标识符均为 `_0x…` 形式，其具体逻辑、下载来源、配置处理与密钥处理方式均无法逐行核实。
> 因此**本仓库仅供个人实验，请勿用于生产环境**，也不要在其中存放任何真实凭据。
> 如需可审计的版本，请改用上游未混淆源码自行重建（见“与上游的关系”）。

## 与上游的关系

本仓库是 [`eooce/nodejs-argo`](https://github.com/eooce/nodejs-argo) 的 fork（上游约 8,487 ★）。

- 本 fork 创建于 2025-11-04，最后一次代码推送也是 2025-11-04。
- 与上游相比：**本 fork 落后上游 15 个提交**（上游最后推送 2026-11-02），本 fork 独有 3 个提交。
- 本次整理**没有同步上游**：直接合并 15 个提交存在冲突风险（尤其 `index.js` 为混淆代码，
  冲突无法人工判断），同步需另行在分支上逐项比对后进行。
- 上游原作者为 `eooce`；本 fork 的维护者为 `tony-wang1990`（见 `package.json`）。
- 许可证：本仓库随附 GPL-3.0（`LICENSE`），`package.json` 已统一为 `GPL-3.0`。

## 环境变量

下表变量名取自对混淆后的 `index.js` 的**字符串扫描结果**，仅能确认变量名出现过，
**未逐项验证其含义与默认值**（混淆代码无法可靠验证）。部署前请以上游文档为准。

| 变量 | 说明（未完全核实） |
| --- | --- |
| `UUID` | 节点 UUID |
| `ARGO_AUTH` | Argo 隧道授权（token 或 JSON） |
| `ARGO_DOMAIN` | Argo 固定域名 |
| `ARGO_PORT` | Argo 端口 |
| `NEZHA_SERVER` | 哪吒探针服务端地址 |
| `NEZHA_PORT` | 哪吒探针端口 |
| `NEZHA_KEY` | 哪吒探针密钥 |
| `CFIP` / `CFPORT` | Cloudflare 优选 IP / 端口 |
| `FILE_PATH` | 文件路径相关配置 |
| `SUB_PATH` | 订阅路径 |
| `UPLOAD_URL` | 上传地址 |
| `PROJECT_URL` | 项目地址 |
| `NAME` | 节点名称 |
| `PORT` | 服务监听端口，默认 `3000`（见 `Dockerfile` 的 `EXPOSE 3000`） |

## Railway 部署

1. 在 Railway 中从本仓库新建项目（或直接部署本 fork）。
2. 在 Railway 的 Variables 中按上表设置 `UUID`、`ARGO_AUTH` 等变量。
3. Railway 会使用仓库内的 `Dockerfile` 构建并运行，服务监听 `PORT`（默认 `3000`）。

## Docker 部署

```bash
docker build -t railway-nodejs-argo .
docker run -d --name railway-nodejs-argo \
  -p 3000:3000 \
  -e UUID="<你的 UUID>" \
  -e ARGO_AUTH="<你的 Argo 授权>" \
  railway-nodejs-argo
```

或使用 GHCR 镜像（CI 在推送到 `main` 时构建并推送）：

```bash
docker pull ghcr.io/tony-wang1990/railway-nodejs-argo:latest
```

本地开发：

```bash
npm ci
npm start
```

## 注意事项

- 构建使用 `npm ci` 与 `package-lock.json`，依赖版本已锁定（`axios 1.21.1`、`express 4.22.3`），Node 要求 `>= 20`。
- 镜像以非 root 用户（`node`）运行，工作目录为 `/app`，并带有 `HEALTHCHECK`（尽力而为的存活探测：
  只要 `http://127.0.0.1:3000/` 能返回任意 HTTP 响应即视为存活——上游未公开健康检查端点，无法做更精确的判断）。
- 不要把真实的 `UUID` / `ARGO_AUTH` / `NEZHA_KEY` 提交进仓库；只通过环境变量传入。
