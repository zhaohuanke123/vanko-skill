# 交互式可视化系统

> **本文档说明如何生成交互式可视化组件，以及在课程中引用它们。**
>
> **AI读取时机：** 用户说"生成交互图X"、课程内容包含复杂图表时
>
> **配置引用：**
> - 输出目录：`config.json` → `visualization.outputSubdir`
> - 是否启用：`config.json` → `visualization.enabled`

---

## 核心思路

课程中复杂的图表、流程、结构，生成独立的HTML文件，用户点击链接在浏览器中打开交互。

**优势：**
- 动态交互（拖拽、缩放、展开/折叠）
- 动画演示（流程动画、状态变化）
- 真实数据（用户可修改参数看效果）
- 响应式设计（手机/平板也能看）

---

## 支持的可视化类型

| 类型 | 用途 | 交互功能 |
|-----|------|---------|
| 流程图 | 算法流程、执行顺序 | 点击节点展开详情、动画演示执行流程 |
| 树状图 | 数据结构、继承关系 | 展开/折叠节点、高亮路径 |
| 思维导图 | 知识结构、概念关联 | 拖拽布局、点击聚焦 |
| 对比表格 | 概念对比、优缺点 | 排序、筛选、高亮差异 |
| 时序图 | 执行过程、消息传递 | 动画播放、步进查看 |
| 状态机 | 状态转换、生命周期 | 点击触发转换、动画演示 |
| 代码执行 | 代码运行过程 | 逐行高亮、变量状态追踪 |
| 公式可视化 | 数学公式、推导 | 参数调节、实时计算 |

---

## 在课程中引用

课程Markdown文件中，使用以下格式引用可视化组件：

```markdown
## 内容讲解

### 作用域链的工作原理

当JavaScript引擎查找变量时，会沿着作用域链逐层向外查找...

> [!tip] 🔗 交互式演示
> **[[visuals/01_作用域链.html|点击打开：作用域链可视化]]**
>
> 在浏览器中打开后，你可以：
> - 点击不同作用域查看变量
> - 观察查找路径动画
> - 修改变量名观察查找结果
```

---

## 触发生成

**方式1：用户主动请求**
```
用户: 给这节课生成一个闭包原理的交互图
```

**方式2：AI自动判断**
当课程内容包含复杂流程、数据结构、对比表格时，AI主动建议：
```
AI: 这节课涉及闭包的执行流程，建议生成交互式演示。
是否需要？回复"是"或"生成"即可。
```

---

## 生成时机判断

AI在以下情况下主动建议生成可视化：

| 内容类型 | 判断条件 | 建议类型 |
|---------|---------|---------|
| 流程/步骤 | 超过3个步骤的顺序执行 | 流程图 |
| 层级结构 | 有明确的父子/嵌套关系 | 树状图 |
| 对比分析 | 对比2个以上事物的多个维度 | 对比表格 |
| 状态转换 | 有明确的状态和转换条件 | 状态机图 |
| 执行过程 | 代码执行需要理解中间状态 | 代码执行可视化 |
| 时间序列 | 有时间先后顺序的消息传递 | 时序图 |

---

## HTML组件规范

生成的HTML文件遵循以下规范：

1. **自包含** - 单文件，不依赖外部资源（CDN除外）
2. **离线可用** - 核心功能不依赖网络
3. **中文界面** - 所有文字使用中文
4. **交互引导** - 有简短的使用说明
5. **美观易用** - 使用Tailwind CSS或类似框架

---

## 模板文件位置

实际可用的HTML模板位于：
```
skills/interactive-learning/templates/
├── scope-chain-demo.html      # 作用域链可视化
└── closure-execution-demo.html # 闭包执行过程
```

---

## 常用模板示例

### 流程图模板

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>流程图 - [主题名]</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    <div class="container mx-auto p-4">
        <h1 class="text-2xl font-bold mb-4">[流程图标题]</h1>
        <div class="mb-4 text-gray-600">
            <p>💡 使用说明：点击节点查看详情，点击"演示"按钮查看执行流程动画</p>
        </div>
        <div class="flex gap-2 mb-4">
            <button onclick="playAnimation()" class="px-4 py-2 bg-blue-500 text-white rounded">▶ 播放动画</button>
            <button onclick="resetAnimation()" class="px-4 py-2 bg-gray-300 rounded">↺ 重置</button>
        </div>
        <div id="flowchart" class="bg-white rounded-lg p-6 shadow">
            <!-- 流程图内容 -->
        </div>
    </div>
    <script>
        // 交互逻辑
    </script>
</body>
</html>
```

### 代码执行模板

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>代码执行 - [主题名]</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    <div class="container mx-auto p-4">
        <h1 class="text-2xl font-bold mb-4">[代码执行标题]</h1>
        <div class="mb-4 text-gray-600">
            <p>💡 点击"下一步"逐行执行，观察变量变化</p>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
            <!-- 代码区域 -->
            <div class="bg-white rounded-lg shadow p-4">
                <pre><code id="code-block">
// 示例代码
                </code></pre>
            </div>
            <!-- 变量状态区域 -->
            <div class="bg-white rounded-lg shadow p-4">
                <div id="variables">变量状态</div>
            </div>
        </div>
        <div class="mt-4 flex gap-2">
            <button onclick="stepForward()" class="px-4 py-2 bg-blue-500 text-white rounded">下一步 →</button>
            <button onclick="runAll()" class="px-4 py-2 bg-green-500 text-white rounded">▶ 运行全部</button>
            <button onclick="reset()" class="px-4 py-2 bg-gray-300 rounded">↺ 重置</button>
        </div>
    </div>
    <script>
        // 执行逻辑
    </script>
</body>
</html>
```
