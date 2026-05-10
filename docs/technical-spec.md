# 个人作品集官网技术说明

## 1. 项目目标

这是一个无后端、纯静态的个人作品集官网。它的目标不是做复杂系统，而是用一个高级、沉浸式的首页，把你的产品矩阵展示出来，并引导客户、合作方和自媒体观众去了解或使用你的产品。

当前网站是单页结构，核心文件是 `index.html`。页面使用 WebGL 渲染作品图片矩阵，配合鼠标移动视差、图片 hover 放大、点击弹层等交互。

后续开发必须遵守：

- 不引入后端。
- 不引入数据库。
- 不引入登录系统。
- 不引入复杂构建流程，除非后续明确决定重构。
- 首页第一视觉继续保持当前 WebGL 产品矩阵。
- 网站最终可以直接上传到静态服务器目录上线。

## 2. 文件结构

当前最小结构：

```text
/
├── index.html
└── docs/
    └── technical-spec.md
```

后续加入真实图片后，推荐结构：

```text
/
├── index.html
├── assets/
│   ├── product-agentos.webp
│   ├── product-visiondesk.webp
│   ├── product-promptlab.webp
│   ├── product-datapilot.webp
│   ├── coming-soon-1.webp
│   ├── coming-soon-2.webp
│   ├── favicon.png
│   └── og-image.jpg
└── docs/
    └── technical-spec.md
```

图片建议使用 `.webp`，控制体积，避免首屏加载卡顿。

## 3. 产品数量与状态

首页保持 6 个视觉位置，以保证当前构图完整。

业务上分为：

- 4 个正式产品：可以点击，可以打开弹层，可以配置产品链接。
- 2 个敬请期待产品：只作为占位展示，不跳转正式产品页面。

推荐给每个产品增加 `status` 字段：

```js
status: 'live'
```

或：

```js
status: 'coming-soon'
```

`live` 产品可以展示正式弹层和产品入口。`coming-soon` 产品只展示“敬请期待”信息，不应该出现正式产品链接。

## 4. 产品数据结构

所有作品信息集中维护在 `index.html` 的 `products` 数组中。

推荐完整字段如下：

```js
{
  title: 'DataPilot',
  status: 'live',
  hoverSummary: '用自然语言提问，快速读懂数据。',
  description: '自然语言数据分析助手，让用户用提问的方式理解数据，并把复杂数据转化成清晰的图表和洞察。',
  ctaLabel: '立即体验',
  ctaUrl: 'https://example.com',
  image: 'assets/product-datapilot.webp',
  rect: [-0.531, -0.401, 0.139, 0.385],
  start: [-0.085, -0.075],
  depth: 1.28,
  accent: '#c5c9c5'
}
```

字段说明：

- `title`：产品名称。用于首页大标题和弹层标题。
- `status`：产品状态。`live` 为正式产品，`coming-soon` 为占位产品。
- `hoverSummary`：鼠标悬停到作品图片上时展示的短简介。
- `description`：点击作品图片后，正式弹层里展示的完整简介。
- `ctaLabel`：正式产品的行动按钮文案，例如“立即体验”。
- `ctaUrl`：正式产品的外部链接。
- `image`：后续替换真实产品图时使用的图片路径。
- `rect`：WebGL 中作品最终位置和尺寸。
- `start`：作品入场动画起始位置。
- `depth`：鼠标视差移动强度。
- `accent`：产品主题色，用于默认色块、占位图和视觉氛围。

## 5. 两套产品简介字段

这是最容易出错的部分，必须严格区分。

### `hoverSummary`

`hoverSummary` 是鼠标悬停在作品图片上时使用的短简介。

用途：

- 只用于首页 hover 状态。
- 文案必须短，建议 12-24 个汉字。
- 作用是快速告诉用户“这个产品是干什么的”。
- 它不是正式产品详情。

示例：

```js
hoverSummary: '用自然语言提问，快速读懂数据。'
```

### `description`

`description` 是点击作品图片后，正式弹层中展示的产品简介。

用途：

- 只用于点击图片后的弹层详情。
- 文案可以更完整，说明产品价值、适用场景和解决的问题。
- 它不应该直接显示在首页大标题下面。

示例：

```js
description: '自然语言数据分析助手，让用户用提问的方式理解数据，并把复杂数据转化成清晰的图表和洞察。'
```

### 禁止混用

后续开发不能把 `description` 当成 hover 文案直接放到首页，也不能把 `hoverSummary` 当成弹层正式简介。

正确关系：

```text
首页大标题：title
鼠标悬停图片：hoverSummary
点击图片弹层：description
```

## 6. 首页展示规则

首页默认展示：

- 品牌名称。
- WebGL 产品矩阵。
- 当前激活产品的 `title`。
- 左下角操作提示。

首页默认不展示：

- 右下角数字计数，例如 `3 of 6`。
- 大标题下方的大段产品简介。
- 正式弹层里的 `description`。
- 产品 CTA 按钮。

鼠标靠近或悬停某个作品时：

- 大标题切换为该产品的 `title`。
- 图片可以保留 hover 放大和波纹显图效果。
- 如果后续重新打开 hover 简介显示，只能展示 `hoverSummary`，不能展示 `description`。
- hover 简介应该是轻量提示，不应该做成大面积文本块压在首页主标题下面。

## 7. 点击弹层规则

点击正式产品图片后，打开产品弹层。

弹层展示：

- 产品图。
- 产品名称 `title`。
- 正式产品简介 `description`。
- 后续可增加 CTA 按钮 `ctaLabel` / `ctaUrl`。

点击 `coming-soon` 产品时：

- 不跳转外链。
- 可以不打开弹层，或打开轻量提示“敬请期待”。
- 如果打开弹层，不能展示正式产品 CTA。

当前弹层关闭方式：

- 点击右上角关闭按钮。
- 按 `Escape` 键。

## 8. WebGL 交互规则

当前首页由 `canvas#stage` 渲染产品矩阵。

交互状态：

- `activeIndex`：当前离鼠标最近或被激活的产品，用于切换大标题。
- `hoveredIndex`：鼠标真正悬停到图片上的产品，用于 hover 放大和显图效果。
- `product.hover`：激活状态的缓动值。
- `product.zoom`：真实 hover 状态的缓动值。

不要把 `activeIndex` 和 `hoveredIndex` 混为一谈：

- `activeIndex` 可以随着鼠标靠近变化。
- `hoveredIndex` 只有鼠标进入图片矩形时才变化。
- 图片放大和 hover 特效应该优先使用 `hoveredIndex` / `product.zoom`。

## 9. 图片与视觉资源

当前代码中的图片由 `makeTextureCanvas()` 动态生成，占位用途较强。

后续替换真实作品图时，建议：

- 为每个产品增加 `image` 字段。
- 优先使用竖版产品封面或产品截图。
- 保持图片比例接近当前竖版构图。
- 图片文件放在 `assets/` 目录。
- 单张图片建议控制在 300KB-800KB。

替换真实图片时需要注意：

- 保留 WebGL 纹理创建逻辑。
- 图片加载完成后再创建 texture。
- 图片加载失败时，回退到当前 canvas 占位图。
- 不要因为图片加载失败导致整个页面空白。

## 10. 响应式规则

桌面端：

- 保留完整 WebGL 产品矩阵。
- 大标题保持视觉冲击力。
- 点击弹层采用左右布局。

移动端：

- 保留产品矩阵，但允许降低信息密度。
- 大标题不能溢出屏幕。
- 弹层改为上下布局。
- 自定义鼠标和 hover 相关信息可以弱化或隐藏，因为手机没有鼠标 hover。

移动端不要强依赖 hover 才能理解产品。正式产品信息必须能通过点击弹层访问。

## 11. 无后端上线规则

上线只需要静态文件：

- `index.html`
- `assets/` 图片资源
- favicon
- Open Graph 分享图

服务器要求：

- 支持静态文件访问。
- 支持 HTTPS。
- 不需要 Node.js。
- 不需要数据库。
- 不需要接口服务。

上线前建议补充 `<head>`：

```html
<title>麦克斯坦 - AI 产品作品集</title>
<meta name="description" content="麦克斯坦的 AI 产品作品集，展示个人产品、工具和创作项目。">
<meta property="og:title" content="麦克斯坦 - AI 产品作品集">
<meta property="og:description" content="查看我的 AI 产品、工具和创作项目。">
<meta property="og:image" content="https://your-domain.com/assets/og-image.jpg">
```

## 12. 开发禁区

后续开发不要做这些事：

- 不要重新加回右下角 `x of 6` 数字计数，除非明确要求。
- 不要把 `description` 放到首页大标题下面。
- 不要让 hover 文案和弹层文案共用一个字段。
- 不要把 6 个视觉位置改成 4 个，除非重新设计首页构图。
- 不要引入后端表单、数据库或登录系统。
- 不要破坏现有 hover 放大、鼠标视差、点击弹层。
- 不要让 Coming Soon 产品跳转到不存在的链接。

## 13. 验收清单

开发完成后必须检查：

- 首页只有产品名称，不显示正式简介。
- 右下角没有 `x of 6` 数字计数。
- 鼠标移动时，产品标题能正常切换。
- 鼠标悬停图片时，图片 hover 放大正常。
- 如果启用 hover 简介，展示内容必须来自 `hoverSummary`。
- 点击正式产品时，弹层展示内容必须来自 `description`。
- `hoverSummary` 和 `description` 修改其中一个，不影响另一个。
- 点击 Coming Soon 产品不会跳转错误链接。
- 弹层可以点击关闭，也可以按 `Escape` 关闭。
- 桌面端和手机端文字不溢出。
- 服务器静态部署后可以直接访问。

## 14. 当前实现状态

当前 `index.html` 已实现：

- WebGL 产品矩阵。
- 产品标题切换。
- 鼠标视差移动。
- 图片 hover 放大。
- 点击图片打开弹层。
- 右下角数字计数已移除。
- `products` 数据中已经存在 `hoverSummary` 和 `description` 两个字段。

当前页面没有渲染可见的 hover 文案浮层。后续如果要恢复“鼠标悬停图片展示短简介”的功能，必须按本文档约定使用 `hoverSummary`，并避免把它放成大标题下方的大段文字。
